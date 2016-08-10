//
//  ViewConstructedPlaylist.swift
//  ListenIn
//
//  Created by Sam Lee on 8/10/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class ViewConstructedPlaylist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tracksForPlaylist: [SPTPartialTrack] = []
    
    lazy var currentSession: SPTSession? = {
        return SPTAuth.defaultInstance().session ?? nil
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        buildPlaylist()
    }
    
    func buildPlaylist() {
        for playlist in ConstructPlaylist.playlistsToBuildFrom {
            self.getSongsFromPlaylist(playlist)
        }
    }
    
    func getSongsFromPlaylist(playlistURI: NSURL) {
        SPTPlaylistSnapshot.playlistWithURI(playlistURI, session: currentSession) { (error: NSError!, data: AnyObject!) in
            
            let playlistViewer = data as! SPTPlaylistSnapshot
            let playlist = playlistViewer.firstTrackPage
            
            if let actualPlaylist = playlist, actualItems = actualPlaylist.items {
                if actualItems.count == 0 {
                    SongScraper.playlistHasSongs = false
                    print("Empty playlist, loading another playlist")
                    return
                }
                
                for _ in 1...5 {
                    let random = Int(arc4random_uniform(UInt32(actualItems.count)))
                    self.tracksForPlaylist.append(actualPlaylist.items[random] as! SPTPartialTrack)
                }
                
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
        return tracksForPlaylist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ViewConstructedPlaylistTableViewCell", forIndexPath: indexPath) as! ViewConstructedPlaylistTableViewCell
        
        cell.songName.text = self.tracksForPlaylist[indexPath.row].name
        cell.artistName.text = self.tracksForPlaylist[indexPath.row].artists.first!.name
        
        return cell
    }
}