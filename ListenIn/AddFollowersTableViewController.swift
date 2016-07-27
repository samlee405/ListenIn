//
//  AddFollowersTableViewController.swift
//  ListenIn
//
//  Created by Sam Lee on 7/26/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase

class AddFollowersTableViewController: UITableViewController {
    
    var currentSession: SPTSession?
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var usersImFollowing: [String] = []
    var usersNotFollowing: [String] = []
    var usersNotFollowingDisplayName: [String] = []
    var isFollowed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUnfollowedUsers()
    }
    
    func getUnfollowedUsers() {
        ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.getFollowedUsersForUser(snapshot)
            self.createListOfUnfollowedUsers()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getFollowedUsersForUser(snapshot: FIRDataSnapshot) {
        for entry in snapshot.children {
            self.usersImFollowing.append(entry.value)
        }
    }
    
    func createListOfUnfollowedUsers() {
        self.ref.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.filterOutFollowedUsers(snapshot)
            self.displayUsernames()
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func filterOutFollowedUsers(snapshot:FIRDataSnapshot) {
        for anEntry in snapshot.children {
            let entry = anEntry as! FIRDataSnapshot
            self.isFollowed = false
            
            for follower in self.usersImFollowing {
                if follower == entry.key {
                    self.isFollowed = true
                }
            }
            
            if !self.isFollowed {
                self.usersNotFollowing.append(entry.key)
            }
        }
    }
    
    func displayUsernames() {
        for entry in self.usersNotFollowing {
            print(entry)
            let username = entry.componentsSeparatedByString(":").last!
            SPTUser.requestUser(username, withAccessToken: SPTAuth.defaultInstance().session.accessToken) { (error: NSError!, data: AnyObject!) in
                if let error = error {
                    print(error)
                    return
                }
                self.usersNotFollowingDisplayName.append(data.displayName)
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersNotFollowingDisplayName.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Make sure to change userURI
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddFollowersTableViewCell", forIndexPath: indexPath) as! AddFollowersTableViewCell
        
        let someUser = usersNotFollowingDisplayName[indexPath.row]
        cell.someUser.text = String(someUser)
        cell.userURI = usersNotFollowing[indexPath.row]
        
        return cell
    }
}