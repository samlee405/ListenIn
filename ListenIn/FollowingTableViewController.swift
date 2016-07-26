//
//  FollowingTableViewController.swift
//  ListenIn
//
//  Created by Sam Lee on 7/25/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowingTableViewController: UITableViewController {
    
    var currentSession: SPTSession?
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var followingArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find all the people you're following
        ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in

//            self.followingArray = snapshot as! [Dictionary<String, String>]
        for entry in snapshot.children {
            self.followingArray.append(entry.value)
            self.tableView.reloadData()
        }
            
        }) { (error) in
            
            print(error.localizedDescription)
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowingTableViewCell", forIndexPath: indexPath) as! FollowingTableViewCell
        
        let someUser = followingArray[indexPath.row]
        cell.followedUser.text = String(someUser)
        
        return cell
    }
}