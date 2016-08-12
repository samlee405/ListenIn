//
//  FollowingTableViewController.swift
//  ListenIn
//
//  Created by Sam Lee on 7/25/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var followingArray: [String] = []
    var followingArrayDisplayName: [String] = []
    
    lazy var currentSession: SPTSession? = {
        return SPTAuth.defaultInstance().session ?? nil
    }()
    
    lazy var currentUserURI: String = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        return appDelegate.currentUserURI
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func findNewFollowers(sender: AnyObject) {
        self.performSegueWithIdentifier("addNewFollowersSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Find all the people you're following
        self.followingArray = []
        self.followingArrayDisplayName = []
        ref.child("follow").child(self.currentUserURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            for entry in snapshot.children {
                self.followingArray.append(entry.value)
            }
            
            self.displayUsernames(
            )
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func displayUsernames() {
        for entry in self.followingArray {
            let username = entry.componentsSeparatedByString(":").last!
            SPTUser.requestUser(username, withAccessToken: SPTAuth.defaultInstance().session.accessToken) { (error: NSError!, data: AnyObject!) in
                if let error = error {
                    print(error)
                    return
                }
                self.followingArrayDisplayName.append(data.displayName)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func unwindToFollowers(segue: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addNewFollowersSegue" {
            // Send current Spotify session
            let destinationViewController: AddFollowersTableViewController = segue.destinationViewController as! AddFollowersTableViewController
            destinationViewController.currentSession = currentSession
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingArrayDisplayName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowingTableViewCell", forIndexPath: indexPath) as! FollowingTableViewCell
        
        cell.contentView.backgroundColor = UIColor.whiteColor()
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(5, 5, self.view.frame.size.width - 10, 35))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [56, 78, 119, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 3.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(0, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        let someUser = followingArrayDisplayName[indexPath.row]
        cell.followedUser.text = String(someUser)
        cell.index = indexPath.row
        cell.currentUser = followingArray[indexPath.row]
        cell.userURI = followingArray[indexPath.row]
        cell.followButton.setTitle("Unfollow", forState: .Normal)
        
        return cell
    }
}