//
//  PlaylistGeneratorSelectionController.swift
//  ListenIn
//
//  Created by Sam Lee on 7/13/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation
import UIKit

class PlaylistGeneratorSelectionController: UIViewController {
    
    var currentSession = SPTSession()
    static var aSongs: [NSURL] = []
    
    @IBOutlet weak var dividerBar: UIView!

    @IBAction func autogeneratePlaylist(sender: AnyObject) {
        // Transition to tableview for newly generated playlist
    }
    
    @IBAction func manuallyGeneratePlaylist(sender: AnyObject) {
        // Transition to tableview for newly generated playlist
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dividerBar.layer.cornerRadius = 5
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let controller = segue.destinationViewController as! PlaylistAutoGenerator
        controller.currentSession = currentSession
    }
}


// Cliff's ID : 128153085


