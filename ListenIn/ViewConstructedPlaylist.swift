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
    var uploadPlaylistBool = true
    
    lazy var currentSession: SPTSession? = {
        return SPTAuth.defaultInstance().session ?? nil
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadPlaylistButton: UIButton!
    
    @IBAction func uploadToSpotify(sender: AnyObject) {
        if uploadPlaylistBool {
            SPTPlaylistList.createPlaylistWithName("Your ListenIn Playlist", publicFlag: true, session: currentSession) { (error: NSError!, data: SPTPlaylistSnapshot!) in
                data.addTracksToPlaylist(self.tracksForPlaylist, withSession: self.currentSession, callback: { (error: NSError!) in
                    if let someError = error {
                        print("Error uploading playlist")
                        print(someError)
                    }
                })
            }
            
            self.uploadPlaylistBool = false
            self.uploadPlaylistButton.setTitle("Playlist uploaded", forState: .Normal)
            
            ConstructPlaylist.playlistsToBuildFrom = []
        }
        else {
            print("Playlist has been uploaded")
        }
    }
    
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "delete") { action, index in
            self.tracksForPlaylist.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracksForPlaylist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ViewConstructedPlaylistTableViewCell", forIndexPath: indexPath) as! ViewConstructedPlaylistTableViewCell
        
        cell.songTitle.text = self.tracksForPlaylist[indexPath.row].name
        cell.artistTitle.text = self.tracksForPlaylist[indexPath.row].artists.first!.name
        
        return cell
    }
}