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
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
        
        cell.contentView.backgroundColor = UIColor.whiteColor()
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(5, 5, self.view.frame.size.width - 10, 37.5))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [56, 78, 119, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 3.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        cell.songTitle.text = listOfSongs[indexPath.row].name
        cell.artistTitle.text = listOfSongs[indexPath.row].artists.first!.name
        cell.songURI = listOfSongs[indexPath.row].playableUri
        
        return cell
    }
}
