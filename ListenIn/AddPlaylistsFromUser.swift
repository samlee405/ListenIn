//
//  AddPlaylistsFromUser.swift
//  ListenIn
//
//  Created by Sam Lee on 8/10/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class AddPlaylistsFromUser: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var playlistForUser: String!
    var playlistList: [SPTPartialPlaylist] = []
    
    lazy var currentSession: SPTSession? = {
        return SPTAuth.defaultInstance().session ?? nil
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getPlaylists()
    }
    
    func getPlaylists() {
        self.playlistList = []
        SPTPlaylistList.playlistsForUser(playlistForUser.componentsSeparatedByString(":").last!, withSession: currentSession) { (error: NSError!, data: AnyObject!) in
            let myPlaylists = data as! SPTPlaylistList
            for playlist in myPlaylists.items {
                self.playlistList.append(playlist as! SPTPartialPlaylist)
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddPlaylistsFromUserTableViewCell", forIndexPath: indexPath) as! AddPlaylistsFromUserTableViewCell
        
        cell.playlistName.text = self.playlistList[indexPath.row].name
        cell.playlistURI = self.playlistList[indexPath.row].uri
        
        return cell
    }
}