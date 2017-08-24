//
//  MusicPermissionsVC.swift
//  Queue
//
//  Created by Aditya Gunda on 8/17/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import FirebaseAuth
import StoreKit
import MediaPlayer
import Alamofire
import SwiftyJSON
import SafariServices

class MusicPermissionsVC: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    //var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPermissionsVC.updateAfterFirstLogin), name: Notification.Name(rawValue: "loginSuccessfull") ,object: nil)
    }
    
    func setup() {
        auth.clientID = "72d8cf3b5c014ce694675d2c931e339e"
        auth.redirectURL = URL(string: "Queue://returnAfterLogin")
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserLibraryReadScope, SPTAuthUserLibraryModifyScope, SPTAuthUserReadPrivateScope]
        //auth.tokenSwapURL = URL(string: "https://queue-music.herokuapp.com/swap") //do something to ping server to keep it alive
       // auth.tokenRefreshURL =  URL(string: "https://queue-music.herokuapp.com/refresh") //do something to ping server to keep it alive
        loginUrl = auth.spotifyWebAuthenticationURL()
        
        
    }
    
    func updateAfterFirstLogin () {
        let userDefaults = UserDefaults.standard
        if let sessionObj: AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            print(sessionDataObj)
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            //write token values to database
            DataService.instance.writeUserData(uid: Auth.auth().currentUser!.uid, key: "spotify_access_token", data: session.accessToken)
            //DataService.instance.writeUserData(uid: Auth.auth().currentUser!.uid, key: "spotify_refresh_token", data: session.encryptedRefreshToken ?? nil)
            
            //initializePlayer(authSession: session)
            self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
        }
    }
    
    /*
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    */
    
    func refreshSpotifyToken()
    {
        print("refresh token: \(self.session.encryptedRefreshToken)")
        //auth.tokenRefreshURL =  URL(string: "https://queue-music.herokuapp.com/") //do something to ping server to keep it alive
        /*
        let parameters: Parameters = ["grant_type": "refresh_token", "refresh_token": session.encryptedRefreshToken] //fix refresh token
        Alamofire.request("https://accounts.spotify.com/api/token", method: .post, parameters: parameters, encoding: JSONEncoding(options: [])).responseJSON { response in
            let value = response.result.value as! Data
            switch response.result {
            case .success:
                print("successful token refresh")
                let json = JSON(data: value)
                let newAccessToken = json["access_token"].stringValue
                DataService.instance.writeUserData(uid: Auth.auth().currentUser!.uid, key: "spotify_access_token", data: newAccessToken)
            case .failure(let error):
                print("token refresh error \(error)")
            }
            // save new session?
        }
 */
    }
    
    
    @IBAction func spotifyBtnPressed(_ sender: Any) {
            // fix view controller
            //let vc = SFSafariViewController(url: loginUrl!, entersReaderIfAvailable: false)
           // present(vc, animated: true)
        
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
    
    @IBAction func applemusicBtnPressed(_ sender: Any) {
        appleMusicRequestPermission()
    }
    
    func appleMusicRequestPermission() {
        SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
            switch status {
            case .authorized:
                print("All good - the user tapped 'OK', so you're clear to move forward and start playing.")
                self.appleMusicPlayTrackId(ids: ["201234458"])
                self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
            case .denied:
                print("The user tapped 'Don't allow'. Read on about that below...")
            case .notDetermined:
                print("The user hasn't decided or it's not clear whether they've confirmed or denied.")
            case .restricted:
                print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
            }
        }
    }
    
    let applicationMusicPlayer = MPMusicPlayerController.applicationMusicPlayer()
    
    func appleMusicPlayTrackId(ids:[String]) {
        
        applicationMusicPlayer.setQueueWithStoreIDs(ids)
        applicationMusicPlayer.play()
        
    }
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
    }

}
