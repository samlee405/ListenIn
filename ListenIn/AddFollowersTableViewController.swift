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
        
        // Populate table view with users I'm not following
        ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            for entry in snapshot.children {
                self.usersImFollowing.append(entry.value)
                self.tableView.reloadData()
            }
            
            self.ref.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
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
//                        SPTUser.requestUser(entry.key, withAccessToken: SPTAuth.defaultInstance().session.accessToken) { (error: NSError!, data: AnyObject!) in
//                            self.usersNotFollowingDisplayName.append(data as! (String))
//                        }
                    }
                }
                
                print("\npopulating usersNotFollowingDisplayName")
                
                for entry in self.usersNotFollowing {
                    SPTUser.requestUser(entry, withAccessToken: SPTAuth.defaultInstance().session.accessToken) { (error: NSError!, data: AnyObject!) in
                        self.usersNotFollowingDisplayName.append(data as! String)
                        print(self.usersNotFollowingDisplayName.count)
                    }
                }
                
                self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersNotFollowing.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Make sure to change userURI
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddFollowersTableViewCell", forIndexPath: indexPath) as! AddFollowersTableViewCell
        
        print(usersNotFollowing)
        print(usersNotFollowing.count)
        print(self.usersNotFollowingDisplayName.count)
        
        let someUser = usersNotFollowingDisplayName[indexPath.row]
        cell.someUser.text = String(someUser)
        
        return cell
    }
}