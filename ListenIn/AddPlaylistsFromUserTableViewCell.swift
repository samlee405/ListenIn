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
    var didAddPlaylist: Bool = true
    
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var addPlaylistButton: UIButton!
    
    @IBAction func addPlaylist(sender: AnyObject) {
        if didAddPlaylist {
            ConstructPlaylist.playlistsToBuildFrom.append(playlistURI)
            self.didAddPlaylist = false
            self.addPlaylistButton.setTitle("Added", forState: .Normal)
        }
        else {
            print("Playlist has already been added")
        }
    }
}