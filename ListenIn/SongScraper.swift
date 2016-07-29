//
//  SongScraper.swift
//  ListenIn
//
//  Created by Sam Lee on 7/18/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class SongScraper {
    
    static var playlistHasSongs = true
    
    static func getSongsFromPlaylist(spotifyAccount: String, session: SPTSession, numberOfSongs: Int, locationOfCall: String, completionHandler: (songs: [SPTPartialTrack]) -> Void) {
        
        SongScraper.playlistHasSongs = true

        SPTPlaylistList.playlistsForUser(spotifyAccount, withSession: session) { (error: NSError!, data: AnyObject!) in
            
            let playlists = data as! SPTPlaylistList
            let random = Int(arc4random_uniform(UInt32(playlists.items.count)))
            let playlist = playlists.items[random] as! SPTPartialPlaylist
            
            var songs: [SPTPartialTrack] = []
            
            SPTPlaylistSnapshot.playlistWithURI(playlist.uri, session: session) { (error: NSError!, data: AnyObject!) in
                
                let playlistViewer = data as! SPTPlaylistSnapshot
                let playlist = playlistViewer.firstTrackPage
                
                if let actualPlaylist = playlist, actualItems = actualPlaylist.items {
                    if actualItems.count == 0 {
                        SongScraper.playlistHasSongs = false
                        print("Empty playlist, loading another playlist")
                        return
                    }
                    
                    for _ in 1...numberOfSongs {
                        let random = Int(arc4random_uniform(UInt32(actualItems.count)))
                        songs.append(actualPlaylist.items[random] as! SPTPartialTrack)
                    }
                    
                    completionHandler(songs: songs)
                }
                else {
                    print("Returned a nil playlist, loading another playlist")
                    SongScraper.playlistHasSongs = false
                    return
                }
            }
        }
    }
}