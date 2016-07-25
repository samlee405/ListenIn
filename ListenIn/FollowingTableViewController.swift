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
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    
    
    
    
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistTableViewCell", forIndexPath: indexPath) as! PlaylistTableViewCell
//        print("loading data:")
//        let song = data[indexPath.row]
//        cell.songTitle.text = String(song)
//        
//        return cell
//    }
}