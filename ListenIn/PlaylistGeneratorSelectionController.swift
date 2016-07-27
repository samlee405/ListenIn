//
//  PlaylistGeneratorSelectionController.swift
//  ListenIn
//
//  Created by Sam Lee on 7/13/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class PlaylistGeneratorSelectionController: UIViewController {
    
    var currentSession = SPTSession()
    static var aSongs: [NSURL] = []
    static var currentUserURI = ""
    static var currentUserID = ""
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    @IBOutlet weak var dividerBar: UIView!

    @IBAction func autogeneratePlaylist(sender: AnyObject) {
        self.performSegueWithIdentifier("showAutoGeneratedPlaylistSegue", sender: self)
    }
    
//    @IBAction func manuallyGeneratePlaylist(sender: AnyObject) {
//        self.performSegueWithIdentifier("showManuallyGeneratedPlaylistSegue", sender: self)
//    }
    
    @IBAction func editFollowingUsers(sender: AnyObject) {
        self.performSegueWithIdentifier("showFollowingUsersSegue", sender: self)
    }
    
    @IBAction func findNewFollowers(sender: AnyObject) {
        self.performSegueWithIdentifier("addNewFollowersSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dividerBar.layer.cornerRadius = 5
        
        SPTUser.requestCurrentUserWithAccessToken(SPTAuth.defaultInstance().session.accessToken) { (error: NSError!, data: AnyObject!) in
            PlaylistGeneratorSelectionController.currentUserURI = String(data.uri)
            PlaylistGeneratorSelectionController.currentUserID = data.displayName
            
        self.ref.child("users").child(PlaylistGeneratorSelectionController.currentUserURI).child("username").setValue(PlaylistGeneratorSelectionController.currentUserID)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showAutoGeneratedPlaylistSegue" {
            // Send current Spotify session
            let destinationViewController: PlaylistAutoGenerator = segue.destinationViewController as! PlaylistAutoGenerator
            destinationViewController.currentSession = currentSession
        }
        
        if segue.identifier == "showFollowingUsersSegue" {
            // Send current Spotify session
            let destinationViewController: FollowingTableViewController = segue.destinationViewController as! FollowingTableViewController
            destinationViewController.currentSession = currentSession
        }
        
        if segue.identifier == "addNewFollowersSegue" {
            // Send current Spotify session
            let destinationViewController: AddFollowersTableViewController = segue.destinationViewController as! AddFollowersTableViewController
            destinationViewController.currentSession = currentSession
        }
    }
}