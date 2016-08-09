//
//  AddFollowersTableViewController.swift
//  ListenIn
//
//  Created by Sam Lee on 7/26/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase

class AddFollowersTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var currentSession: SPTSession? = {
        return SPTAuth.defaultInstance().session ?? nil
    }()
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var usersImFollowing: [String] = []
    var usersNotFollowing: [String] = []
    var usersNotFollowingDisplayName: [String] = []
    var isFollowed: Bool = false
    
    lazy var currentUserURI: String = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        return appDelegate.currentUserURI
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getUnfollowedUsers()
    }
    
    func getUnfollowedUsers() {
        ref.child("follow").child(self.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersNotFollowingDisplayName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddFollowersTableViewCell", forIndexPath: indexPath) as! AddFollowersTableViewCell
        
        let someUser = usersNotFollowingDisplayName[indexPath.row]
        cell.someUser.text = String(someUser)
        cell.currentUser = usersNotFollowing[indexPath.row]
        cell.userURI = usersNotFollowing[indexPath.row]
        
        return cell
    }
}