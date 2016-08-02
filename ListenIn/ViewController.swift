//
//  ViewController.swift
//  ListenIn
//
//  Created by Sam Lee on 7/12/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPTAuthViewDelegate, SPTAudioStreamingDelegate {
    
    let kClientID = "be6510d70bda4a288b2725ff06c4b2e3"
    let kCallbackURL = "listenin://callback"
    
    static var player: SPTAudioStreamingController = SPTAudioStreamingController.sharedInstance()
    let spotifyAuthenticator = SPTAuth.defaultInstance()
    var loginSession = SPTSession()
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func signIntoSpotify(sender: AnyObject) {
        
        // Pass through authentication details
        spotifyAuthenticator.clientID = kClientID
        spotifyAuthenticator.requestedScopes = [SPTAuthPlaylistModifyPublicScope, SPTAuthUserFollowReadScope, SPTAuthUserLibraryReadScope, SPTAuthStreamingScope]
        spotifyAuthenticator.redirectURL = NSURL(string: kCallbackURL)
        
        // Create and prepare to open the Spotify log in controller
        let spotifyAuthenticationViewController = SPTAuthViewController.authenticationViewController()
        spotifyAuthenticationViewController.delegate = self

        spotifyAuthenticationViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        spotifyAuthenticationViewController.definesPresentationContext = true
        
        presentViewController(spotifyAuthenticationViewController, animated: false, completion: nil)
        
    }
    
    // If login succeeds:
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        
        self.loginSession = session
        self.loginWithSession(self.loginSession)
        self.performSegueWithIdentifier("PlaylistGeneratorSelectionSegue", sender: self)
    }
    
    // If login fails:
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("Login failed... \(error)")
    }
    
    // If login is cancelled:
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("Did Cancel Login...")
    }
    
    func loginWithSession(session: SPTSession) {
        ViewController.player.delegate = self
        do {
            try ViewController.player.startWithClientId("be6510d70bda4a288b2725ff06c4b2e3")
        }
        catch let error {
            print(error)
        }
        
        ViewController.player.loginWithAccessToken(session.accessToken)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PlaylistGeneratorSelectionSegue" {
            // Send current Spotify session
            let destinationViewController: PlaylistGeneratorSelectionController = segue.destinationViewController as! PlaylistGeneratorSelectionController
            destinationViewController.currentSession = loginSession
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.cornerRadius = 25
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

