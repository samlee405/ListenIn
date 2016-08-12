//
//  ConstructPlaylist.swift
//  ListenIn
//
//  Created by Sam Lee on 8/10/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ConstructPlaylist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var followedUsers: [String] = []
    var followedUsersDisplayName: [String] = []
    static var playlistsToBuildFrom: [NSURL] = []
    var valueToPass: String!
    
    lazy var currentUserURI: String = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        return appDelegate.currentUserURI
    }()

    @IBOutlet weak var numberOfPlaylists: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func buildPlaylist(sender: AnyObject) {
    }
    
    @IBAction func unwindToFollowedUsers(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        getFollowedUsers()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        numberOfPlaylists.text = "\(ConstructPlaylist.playlistsToBuildFrom.count) playlists selected"
    }
    
    func getFollowedUsers() {
        ref.child("follow").child(self.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            for entry in snapshot.children {
                self.followedUsers.append(entry.value)
            }
            
            self.displayUsernames()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func displayUsernames() {
        for entry in self.followedUsers {
            let username = entry.componentsSeparatedByString(":").last!
            SPTUser.requestUser(username, withAccessToken: SPTAuth.defaultInstance().session.accessToken) { (error: NSError!, data: AnyObject!) in
                if let error = error {
                    print(error)
                    return
                }
                self.followedUsersDisplayName.append(data.displayName)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! ConstructPlaylistTableViewCell
        valueToPass = followedUsers[indexPath.row]
        
        performSegueWithIdentifier("showPlaylistForUser", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlaylistForUser" {
            let viewController = segue.destinationViewController as! AddPlaylistsFromUser
            viewController.playlistForUser = valueToPass
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedUsersDisplayName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ConstructPlaylistTableViewCell", forIndexPath: indexPath) as! ConstructPlaylistTableViewCell
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(5, 5, self.view.frame.size.width - 10, 35))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [56, 78, 119, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 3.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(0, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        cell.followedUser.text = followedUsersDisplayName[indexPath.row]
        
        return cell
    }
}