//
//  PlaylistAutoGenerator.swift
//  ListenIn
//
//  Created by Sam Lee on 7/18/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import UIKit

class PlaylistAutoGenerator: UITableViewController {
    
    var currentSession: SPTSession?
    var data:[NSURL] = [NSURL]()
    
//    var songCells = [PlaylistTableViewCell]()
    
    override func viewDidLoad() {
        
        print("Entered view did load")
        
        if let unwrappedSession = currentSession {
            SongScraper.getSongsFromPlaylist("128153085", session: unwrappedSession, numberOfSongs: 2) { (songs) in
                
                print("entered callback")
                print("songs: \(songs)")
                
                self.data = songs
//                self.loadSongs()
                self.tableView.reloadData()
                
                print("Finished loading songs")
            }
        }
        else {
            print("Did not load session")
        }
    }
    
//    func loadSongs() {
//        
//        for uri in data {
//            
//            let song = PlaylistTableViewCell()
//            song.songName = String(uri)
//
//            songCells.append(song)
//        }
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistTableViewCell", forIndexPath: indexPath) as! PlaylistTableViewCell
        print("loading data:")
        let song = data[indexPath.row]
        cell.songTitle.text = String(song)
        
        return cell
    }
}