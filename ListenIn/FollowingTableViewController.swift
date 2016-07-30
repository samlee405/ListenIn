//
//  FollowingTableViewController.swift
//  ListenIn
//
//  Created by Sam Lee on 7/25/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentSession: SPTSession?
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var followingArray: [String] = []
    var followingArrayDisplayName: [String] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Find all the people you're following
        ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in

            for entry in snapshot.children {
                self.followingArray.append(entry.value)
                self.tableView.reloadData()
            }
            
            self.displayUsernames()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func displayUsernames() {
        for entry in self.followingArray {
            let username = entry.componentsSeparatedByString(":").last!
            SPTUser.requestUser(username, withAccessToken: SPTAuth.defaultInstance().session.accessToken) { (error: NSError!, data: AnyObject!) in
                if let error = error {
                    print(error)
                    return
                }
                self.followingArrayDisplayName.append(data.displayName)
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingArrayDisplayName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowingTableViewCell", forIndexPath: indexPath) as! FollowingTableViewCell
        
        let someUser = followingArrayDisplayName[indexPath.row]
        cell.followedUser.text = String(someUser)
        cell.index = indexPath.row
        cell.currentUser = followingArray[indexPath.row]
        
        return cell
    }
}