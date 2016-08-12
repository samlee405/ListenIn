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
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(5, 5, self.view.frame.size.width - 10, 35))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [56, 78, 119, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 3.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(0, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        cell.playlistName.text = self.playlistList[indexPath.row].name
        cell.playlistURI = self.playlistList[indexPath.row].uri
        
        return cell
    }
}