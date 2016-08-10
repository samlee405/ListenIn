//
//  PlaylistViewer.swift
//  ListenIn
//
//  Created by Sam Lee on 8/9/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class PlaylistViewer: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var currentSession: SPTSession? = {
        return SPTAuth.defaultInstance().session ?? nil
    }()
    
    var playlistToLoad: SPTPartialPlaylist!
    var listOfSongs: [SPTPartialTrack] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadSongs()
    }
    
    func loadSongs() {
        var songs: [SPTPartialTrack] = []
        
        SPTPlaylistSnapshot.playlistWithURI(playlistToLoad.uri, session: currentSession) { (error: NSError!, data: AnyObject!) in
            
            let playlistViewer = data as! SPTPlaylistSnapshot
            let playlist = playlistViewer.firstTrackPage
            
            if let actualPlaylist = playlist, actualItems = actualPlaylist.items {
                if actualItems.count == 0 {
                    SongScraper.playlistHasSongs = false
                    print("Empty playlist, loading another playlist")
                    return
                }
                
                for index in 0...actualItems.count - 1 {
                    songs.append(actualPlaylist.items[index] as! SPTPartialTrack)
                }
                
                self.listOfSongs = songs
                self.tableView.reloadData()
            }
            else {
                print("Returned a nil playlist, loading another playlist")
                SongScraper.playlistHasSongs = false
                return
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSongs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistViewerTableViewCell", forIndexPath: indexPath) as! PlaylistViewerTableViewCell
        
        cell.songTitle.text = listOfSongs[indexPath.row].name
        cell.artistTitle.text = listOfSongs[indexPath.row].artists.first!.name
        cell.songURI = listOfSongs[indexPath.row].playableUri
        
        return cell
    }
}
