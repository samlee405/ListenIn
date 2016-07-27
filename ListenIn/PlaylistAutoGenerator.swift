//
//  PlaylistAutoGenerator.swift
//  ListenIn
//
//  Created by Sam Lee on 7/18/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class PlaylistAutoGenerator: UITableViewController {
    
    var currentSession: SPTSession?
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var followedUsers: [String] = []
    var data:[NSURL] = [NSURL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFollowers()
    }
    
    func getFollowers() {
        ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for entry in snapshot.children {
                self.followedUsers.append(entry.value)
            }
            
            self.buildPlaylist()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func buildPlaylist() {
        if let unwrappedSession = currentSession {
            SongScraper.getSongsFromPlaylist("128153085", session: unwrappedSession, numberOfSongs: 2) { (songs) in
                self.data = songs
                self.tableView.reloadData()
            }
        }
        else {
            print("Did not load session")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistTableViewCell", forIndexPath: indexPath) as! PlaylistTableViewCell

        let song = data[indexPath.row]
        cell.songTitle.text = String(song)
        
        return cell
    }
}