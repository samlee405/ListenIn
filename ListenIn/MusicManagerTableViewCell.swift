//
//  MusicManagerTableViewCell.swift
//  ListenIn
//
//  Created by Sam Lee on 8/8/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class MusicManagerTableViewCell: UITableViewCell {
    
    var index = 0
    var playlistURI: NSURL!
    
    @IBOutlet weak var playlistName: UILabel!
    
    @IBAction func playPlaylist(sender: AnyObject) {
        if ViewController.player.isPlaying {
            PlaylistAutoGenerator.audioStreamingDidLogin(ViewController.player, uri: playlistURI!)
        }
        else {
            PlaylistAutoGenerator.audioStreamingDidLogin(ViewController.player, uri: playlistURI!)
        }
    }
}