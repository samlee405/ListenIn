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
    var uploadPlaylistBool = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadPlaylistButton: UIButton!
    
    @IBAction func uploadPlaylist(sender: AnyObject) {
        if uploadPlaylistBool {
            SPTPlaylistList.createPlaylistWithName("Your ListenIn Playlist", publicFlag: true, session: currentSession) { (error: NSError!, data: SPTPlaylistSnapshot!) in
                data.addTracksToPlaylist(self.data, withSession: self.currentSession, callback: { (error: NSError!) in
                    if let someError = error {
                        print("Error uploading playlist")
                        print(someError)
                    }
                })
            }
            
            self.uploadPlaylistBool = false
            self.uploadPlaylistButton.setTitle("Playlist uploaded", forState: .Normal)
        }
        else {
            print("Playlist has been uploaded")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFollowers()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        for item in followedUsers {
            let username = item.componentsSeparatedByString(":").last!
            
            if let unwrappedSession = currentSession {
                SongScraper.getSongsFromPlaylist(username, session: unwrappedSession, numberOfSongs: 4, locationOfCall: "PlaylistAutoGenerator") { (songs) in
                    self.data = self.data + songs
                    self.tableView.reloadData()
                    
                    self.recursiveCallForSongs(username, session: self.currentSession!, numberOfSongs: 4, locationOfCall: "PlaylistAutoGenerator")
                }
            }
            else {
                print("Did not load session")
            }
        }
    }
    
    func recursiveCallForSongs(username: String, session: SPTSession, numberOfSongs: Int, locationOfCall: String) {
        while SongScraper.playlistHasSongs == false {
            SongScraper.getSongsFromPlaylist(username, session: session, numberOfSongs: 4, locationOfCall: "PlaylistAutoGenerator") { (songs) in
                self.data = self.data + songs
                print("Additional songs loaded")
                self.tableView.reloadData()
                self.recursiveCallForSongs(username, session: session, numberOfSongs: numberOfSongs, locationOfCall: locationOfCall)
            }
        }
    }
    
    static func audioStreamingDidLogin(audioStreaming: SPTAudioStreamingController, uri: NSURL) {
        ViewController.player.playURI(uri) { (error: NSError!) in
            if error != nil {
                print("Failed to play: \(error!)")
                return
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
        cell.songURI = data[indexPath.row].playableUri
        
        return cell
    }
}