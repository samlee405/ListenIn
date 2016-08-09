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
    @IBOutlet weak var artistTitle: UILabel!

    @IBAction func playSong(sender: AnyObject) {
        if ViewController.player.isPlaying {
            if ViewController.player.currentTrackURI == songURI {
                ViewController.player.setIsPlaying(false, callback: { (error: NSError!) in
                })
            }
            else {
                PlaylistAutoGenerator.audioStreamingDidLogin(ViewController.player, uri: songURI!)
            }
        }
        else {
            if ViewController.player.currentTrackURI == songURI {
                ViewController.player.setIsPlaying(true, callback: { (error: NSError!) in
                })
            }
            else {
                PlaylistAutoGenerator.audioStreamingDidLogin(ViewController.player, uri: songURI!)
            }
        }
    }
}