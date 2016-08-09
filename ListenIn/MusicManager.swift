//
//  MusicManager.swift
//  ListenIn
//
//  Created by Sam Lee on 8/8/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class MusicManager: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var currentSession: SPTSession? = {
        return SPTAuth.defaultInstance().session ?? nil
    }()
    
    lazy var currentUserURI: String = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        return appDelegate.currentUserURI
    }()
    
    var playlistList: [SPTPartialPlaylist] = []
    var valueToPass: SPTPartialPlaylist!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getMyPlaylists()
    }
    
    func getMyPlaylists() {
        self.playlistList = []
        SPTPlaylistList.playlistsForUser(self.currentUserURI.componentsSeparatedByString(":").last!, withSession: currentSession) { (error: NSError!, data: AnyObject!) in
            let myPlaylists = data as! SPTPlaylistList
            for playlist in myPlaylists.items {
                self.playlistList.append(playlist as! SPTPartialPlaylist)
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

//        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! MusicManagerTableViewCell
        valueToPass = playlistList[currentCell.index]
        
        performSegueWithIdentifier("showMusicForPlaylist", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMusicForPlaylist" {
            let viewController = segue.destinationViewController as! PlaylistViewer
            viewController.playlistToLoad = valueToPass
        }
    }
    
    @IBAction func unwindToPlaylistList(segue: UIStoryboardSegue) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MusicManagerTableViewCell", forIndexPath: indexPath) as! MusicManagerTableViewCell
        
        cell.index = indexPath.row
        cell.playlistName.text = self.playlistList[indexPath.row].name
        
        return cell
    }
}