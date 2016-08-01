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
    var userURI: String = ""
    var ifFollowingBool = true
    
    @IBOutlet weak var followedUser: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func unfollowUser(sender: AnyObject) {
        
        if ifFollowingBool {
            
            print("entered unfollow")
            self.ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
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
            
            self.ifFollowingBool = false
            self.followButton.setTitle("Follow", forState: .Normal)
        }
        else {
            
            print("entered follow")
            let userToFollow = self.ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).childByAutoId()
            userToFollow.setValue(self.userURI)
            
            self.ifFollowingBool = true
            self.followButton.setTitle("Unfollow", forState: .Normal)
        }
            
            
        
    }
}