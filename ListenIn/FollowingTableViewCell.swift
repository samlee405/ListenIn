//
//  FollowingTableViewCell.swift
//  ListenIn
//
//  Created by Sam Lee on 7/25/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowingTableViewCell: UITableViewCell {
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var index: Int = 0
    var currentUser: String = ""
    
    @IBOutlet weak var followedUser: UILabel!
    
    @IBAction func unfollowUser(sender: AnyObject) {
        
        print(currentUser)
        
        self.ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            print(PlaylistGeneratorSelectionController.currentUserURI)
            print(self.ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI))
            
            var isThere = false
            var userToBeUnfollowed: String = ""
            
            for user in snapshot.children {
                let majorKey = user as! FIRDataSnapshot
                if (majorKey.value as! String) == self.currentUser {
                    userToBeUnfollowed = String(majorKey.key)
                    isThere = true
                    break
                }
            }
            
            if isThere {
                print("The following user will be unfollowed " + userToBeUnfollowed)
                
                self.ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).child(userToBeUnfollowed).removeValue()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
            
            
        
    }
}