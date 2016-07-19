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
    
    override func viewDidLoad() {
        
        if let session = currentSession {
            SongScraper.getSongsFromPlaylist("128153085", session: session, numberOfSongs: 3) { (songs) in
                print(songs)
                self.data = songs
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////        let cell =
//        
////        cell.text = data
//    }
}