//
//  PlaylistTableViewCell.swift
//  ListenIn
//
//  Created by Sam Lee on 7/19/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class PlaylistTableViewCell: UITableViewCell {
    
    var songURI: NSURL?
    
    @IBOutlet weak var songTitle: UILabel!

    @IBAction func playSong(sender: AnyObject) {
        PlaylistAutoGenerator.audioStreamingDidLogin(PlaylistAutoGenerator.player, uri: songURI!)
    }
}