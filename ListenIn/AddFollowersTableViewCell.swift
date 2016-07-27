//
//  AddFollowersTableViewCell.swift
//  ListenIn
//
//  Created by Sam Lee on 7/26/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase

class AddFollowersTableViewCell: UITableViewCell {
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var userURI: String = ""
    
    @IBOutlet weak var someUser: UILabel!
    
    @IBAction func followUser(sender: AnyObject) {
        
        let userToFollow = self.ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).childByAutoId()
        userToFollow.setValue(someUser.text)
    }
}