//
//  SongScraper.swift
//  ListenIn
//
//  Created by Sam Lee on 7/18/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class SongScraper {
    
    func findSongs(numberOfSongs: Int, spotifyAccount: String, session: SPTSession) {
        
        SPTPlaylistList.playlistsForUser(spotifyAccount, withSession: session, callback: nil)
        
        for playlists in STPPlaylistList {
            
        }
    }
}