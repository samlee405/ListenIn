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
    var currentUserURI = ""
    var currentUserID = ""
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    @IBOutlet weak var dividerBar: UIView!

    @IBAction func autogeneratePlaylist(sender: AnyObject) {
        // Transition to tableview for newly generated playlist
    }
    
    @IBAction func manuallyGeneratePlaylist(sender: AnyObject) {
        // Transition to tableview for newly generated playlist
    }
    
    @IBAction func editFollowingUsers(sender: AnyObject) {
        // Edit people you follow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dividerBar.layer.cornerRadius = 5
        
        SPTUser.requestCurrentUserWithAccessToken(SPTAuth.defaultInstance().session.accessToken) { (error: NSError!, data: AnyObject!) in
            self.currentUserURI = String(data.uri)
            self.currentUserID = data.displayName
            
            print("The current user is \(self.currentUserID) with uri \(self.currentUserURI)")
            
            self.ref.child("users").child(self.currentUserURI).child("username").setValue(self.currentUserID)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let controller = segue.destinationViewController as! PlaylistAutoGenerator
        controller.currentSession = currentSession
    }
}


// Cliff's ID : 128153085


