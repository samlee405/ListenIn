//
//  SongScraper.swift
//  ListenIn
//
//  Created by Sam Lee on 7/18/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation


class SongScraper {
    
    static func getSongsFromPlaylist(spotifyAccount: String, session: SPTSession, numberOfSongs: Int, completionHandler: (songs:[NSURL]) -> Void) {

        SPTPlaylistList.playlistsForUser(spotifyAccount, withSession: session) { (error: NSError!, data: AnyObject!) in
            
            let playlists = data as! SPTPlaylistList
            let random = Int(arc4random_uniform(UInt32(playlists.items.count)))
            let playlist = playlists.items[random] as! SPTPartialPlaylist
            
            var songs:[NSURL] = [NSURL]()
            
            for i in 1...numberOfSongs {
                SPTPlaylistSnapshot.playlistWithURI(playlist.uri, session: session) { (error: NSError!, data: AnyObject!) in
                
                    let playlistViewer = data as! SPTPlaylistSnapshot
                    let playlist = playlistViewer.firstTrackPage
                    let random = Int(arc4random_uniform(UInt32(playlist.items.count)))
                    songs.append(playlist.items[random].uri)
                    
                    print(songs[i-1])
                    
                    if i == numberOfSongs {
                        completionHandler(songs: songs)
                    }
                }
            }
            print(songs)
        }
    }
}