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
import SwiftMessages

class MusicPermissionsVC: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var loginUrl: URL?
    var spotifyAuthVC: SFSafariViewController?
    let failedAlert = MessageView.viewFromNib(layout: .CardView)

    override func viewDidLoad() {
        super.viewDidLoad()
        SP_setup()
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPermissionsVC.sp_updateAfterFirstLogin), name: Notification.Name(rawValue: "loginSuccessfull") ,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPermissionsVC.closeSpotifyAuthVC), name: Notification.Name(rawValue: "loginSuccessfull") ,object: nil)
    }
    
    func SP_setup() {
        sp_auth.clientID = SPclient_ID
        sp_auth.redirectURL = URL(string: SPredirect_URL)
        sp_auth.requestedScopes = SPrequested_scopes
        loginUrl = sp_auth.spotifyWebAuthenticationURL()
    }
    
    func sp_updateAfterFirstLogin () {
        //load session data from user defaults
        let userDefaults = UserDefaults.standard
        if let sessionObj: AnyObject = userDefaults.object(forKey: SPSession_UserDefaults_Key) as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            print(sessionDataObj)
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            sp_session = firstTimeSession
            
            //write token values to database
            DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyAccessTokenKey, data: sp_session.accessToken)
            /*
            ///TESTING TO GET SPOTIFY USER'S PLAYLISTS
            if sp_session != nil {
                SPTPlaylistList.playlists(forUser: sp_session.canonicalUsername, withAccessToken: sp_session.accessToken, callback: { (error, list) in
                    if error == nil{
                        //let json = JSON(list)
                       // print(json.array)
                        do {
                            let data = nil
                            let request = try SPTPlaylistList.createRequestForGettingPlaylists(forUser: sp_session.canonicalUsername!, withAccessToken: sp_session.accessToken)
                        SPTPlaylistList.init(from: data!, with: request)
                        } catch {
                         //error handling
                        }
                    }
                })
            } else {
                print("spotify session = nil")
            }
            */
            
        }
    }
    
    func closeSpotifyAuthVC(){
        spotifyAuthVC?.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
    }

    @IBAction func spotifyBtnPressed(_ sender: Any) {
         spotifyAuthVC = SFSafariViewController(url: loginUrl!)
         present(spotifyAuthVC!, animated: true, completion: nil)
    }
    
    @IBAction func applemusicBtnPressed(_ sender: Any) {
        appleMusicCheckIfDeviceCanPlayback()
    }
    
    func appleMusicCheckIfDeviceCanPlayback() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities { (capability:SKCloudServiceCapability, err:Error?) in
            if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) {  //The user has an Apple Music subscription and can playback music!
                self.appleMusicRequestPermission()
            } else if  capability.contains(SKCloudServiceCapability.addToCloudMusicLibrary) { //The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library
                self.appleMusicRequestPermission()
            } else { //The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one?
                self.failedAlert.configureTheme(.error)
                self.failedAlert.button?.isHidden = true
                self.failedAlert.configureContent(title: "Woops!", body: "It looks like you don't have a valid Apple Music subscription!", iconText: iconText)
                SwiftMessages.show(view: self.failedAlert)
            }
        }
    }

    
    func appleMusicRequestPermission() {
        SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
            switch status {
            case .authorized:
                //self.appleMusicPlayTrackId(ids: ["201234458"])
                
                let myPlaylistQuery = MPMediaQuery.playlists()
                let playlists = myPlaylistQuery.collections
                for playlist in playlists! {
                    print(playlist.value(forProperty: MPMediaPlaylistPropertyName)!)
                    
                    /*
                    let songs = playlist.items
                    for song in songs {
                        let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
                        print("\t\t", songTitle!)
                    }
                     */
                }
                
                self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
            case .denied:
                self.failedAlert.configureTheme(.error)
                self.failedAlert.button?.isHidden = true
                self.failedAlert.configureContent(title: "Woops!", body: "It looks like you didn't allows us to acccess your Apple Music library.", iconText: iconText)
                SwiftMessages.show(view: self.failedAlert)
            case .notDetermined:
                self.failedAlert.configureTheme(.error)
                self.failedAlert.button?.isHidden = true
                self.failedAlert.configureContent(title: "Woops!", body: "Something went wrong with trying to access your Apple Music membership. Please try again.", iconText: iconText)
                SwiftMessages.show(view: self.failedAlert)
            case .restricted:
                self.failedAlert.configureTheme(.error)
                self.failedAlert.button?.isHidden = true
                self.failedAlert.configureContent(title: "Woops!", body: "It looks like your Apple Music membership won't let us access it.", iconText: iconText)
                SwiftMessages.show(view: self.failedAlert)
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
