//
//  AddPlaylistsFromUserTableViewCell.swift
//  ListenIn
//
//  Created by Sam Lee on 8/10/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class AddPlaylistsFromUserTableViewCell: UITableViewCell {
    
    var playlistURI: NSURL!
    
    @IBOutlet weak var playlistName: UILabel!
    
    @IBAction func addPlaylist(sender: AnyObject) {
        ConstructPlaylist.playlistsToBuildFrom.append(playlistURI)
    }
}