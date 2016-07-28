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

class PlaylistAutoGenerator: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentSession: SPTSession?
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var followedUsers: [String] = []
    var data: [SPTPartialTrack] = []
    let currentUserID = PlaylistGeneratorSelectionController.currentUserID
    let currentUserURI = PlaylistGeneratorSelectionController.currentUserURI.componentsSeparatedByString(":").last!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func uploadPlaylist(sender: AnyObject) {
        SPTPlaylistList.createPlaylistWithName("Your ListenIn Playlist", publicFlag: true, session: currentSession) { (error: NSError!, data: SPTPlaylistSnapshot!) in
            data.addTracksToPlaylist(self.data, withSession: self.currentSession, callback: { (error: NSError!) in
                if let someError = error {
                    print("Error uploading playlist")
                    print(someError)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFollowers()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Make this into a button's IBAction later
//    func uploadPlaylist() {
//        
//        SPTPlaylistList.createPlaylistWithName(currentUserURI, publicFlag: true, session: currentSession) { (error: NSError!, data: SPTPlaylistSnapshot!) in
//            data.addTracksToPlaylist(self.data, withSession: self.currentSession, callback: { (error: NSError!) in
//                if let someError = error {
//                    print("Error uploading playlist")
//                    print(someError)
//                }
//            })
//        }
//    }
    
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
        for item in followedUsers {
            let username = item.componentsSeparatedByString(":").last!
            
            if let unwrappedSession = currentSession {
                SongScraper.getSongsFromPlaylist(username, session: unwrappedSession, numberOfSongs: 4) { (songs) in
                    self.data = self.data + songs
                    self.tableView.reloadData()
                    print("there are \(self.data.count) songs")
                }
            }
            else {
                print("Did not load session")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistTableViewCell", forIndexPath: indexPath) as! PlaylistTableViewCell

        let song = data[indexPath.row].name
        cell.songTitle.text = String(song)
        
        return cell
    }
}