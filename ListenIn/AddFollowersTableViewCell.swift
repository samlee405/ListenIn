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
    var ifFollowingBool = false
    var currentUser: String = ""
    
    @IBOutlet weak var someUser: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func followUser(sender: AnyObject) {
        if !ifFollowingBool {
            print("entered follow")
            let userToFollow = self.ref.child("follow").child(PlaylistGeneratorSelectionController.currentUserURI).childByAutoId()
            userToFollow.setValue(userURI)
            
            self.ifFollowingBool = true
            self.followButton.setTitle("Unfollow", forState: .Normal)
        }
        else {
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
    }
}