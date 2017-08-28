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
import NVActivityIndicatorView

class MusicPermissionsVC: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate, SFSafariViewControllerDelegate {
    
    var loginUrl: URL?
    var spotifyAuthVC: SFSafariViewController?
    let failedAlert = MessageView.viewFromNib(layout: .CardView)
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(), type: NVActivityIndicatorType(rawValue: loadingTypeNo)!, padding: 150) // dummy data until viewDidLoad initializes with self.view.frame

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize loading indicator view
        activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType(rawValue: loadingTypeNo)!, padding: 150)
        self.view.addSubview(activityIndicatorView)
        
        //initialize music provider data under user in data base
        DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyProviderKey, data: "false")
        DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyPremiumProviderKey, data: "false")
        DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: appleMusicProviderKey, data: "false")

        //handle spotify auth notifications sent from app delegate
        SP_setup()
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPermissionsVC.sp_updateAfterFirstLogin), name: Notification.Name(rawValue: "loginSuccessfull") ,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPermissionsVC.closeSpotifyAuthVCOnSuccessfulAuth), name: Notification.Name(rawValue: "loginSuccessfull") ,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPermissionsVC.closeSpotifyAuthVCOnFailedAuth), name: Notification.Name(rawValue: "loginNotSuccessfull") ,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPermissionsVC.closeSpotifyAuthVCOnDeniedAuth), name: Notification.Name(rawValue: "loginDenied") ,object: nil)
    }
    
    func SP_setup() {
        //setup spotify auth information
        SpotifyAuth.instance.sp_auth.clientID =  SpotifyAuth.instance.SPclient_ID
         SpotifyAuth.instance.sp_auth.redirectURL = URL(string:  SpotifyAuth.instance.SPredirect_URL)
         SpotifyAuth.instance.sp_auth.requestedScopes =  SpotifyAuth.instance.SPrequested_scopes
        loginUrl =  SpotifyAuth.instance.sp_auth.spotifyWebAuthenticationURL()
    }
    
    func sp_updateAfterFirstLogin () {
        //load session data from user defaults
        let userDefaults = UserDefaults.standard
        if let sessionObj: AnyObject = userDefaults.object(forKey:  SpotifyAuth.instance.SPSession_UserDefaults_Key) as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
             SpotifyAuth.instance.sp_session = firstTimeSession
            
            //write spotify token values to database
            DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyAccessTokenKey, data:  SpotifyAuth.instance.sp_session.accessToken)
        }
    }
    
    func closeSpotifyAuthVCOnSuccessfulAuth(){
        spotifyAuthVC?.dismiss(animated: true, completion: nil)
        self.activityIndicatorView.startAnimating()
        //update user's music provider in database - spotify
        DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyProviderKey, data: "true")
        
        //upload user's music data from spotify
        SpotifyMusicManager.instance.uploadSpotifyData(completionHandlerMain: { (error) in
            //self.activityIndicatorView.stopAnimating()
            if error != nil {
                //error handling from trying to upload Spotify Data 
                self.failedAlert.configureTheme(.error)
                self.failedAlert.button?.isHidden = true
                self.failedAlert.configureContent(title: "Woops!", body: "error", iconText: iconText)
                SwiftMessages.show(view: self.failedAlert)
            } else {
                self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
            }
        })
    }
    
    func closeSpotifyAuthVCOnFailedAuth(){
        spotifyAuthVC?.dismiss(animated: true, completion: nil)
        self.failedAlert.configureTheme(.error)
        self.failedAlert.button?.isHidden = true
        self.failedAlert.configureContent(title: "Woops!", body: "It looks like something went wrong with trying to connect your Spotify account. Make sure your account is valid and try again.", iconText: iconText)
        SwiftMessages.show(view: self.failedAlert)
    }
    
    func closeSpotifyAuthVCOnDeniedAuth(){
        spotifyAuthVC?.dismiss(animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        spotifyAuthVC?.dismiss(animated: true, completion: nil)
    }

    @IBAction func spotifyBtnPressed(_ sender: Any) {
         spotifyAuthVC = SFSafariViewController(url: loginUrl!)
         spotifyAuthVC?.modalPresentationStyle = UIModalPresentationStyle.popover
         present(spotifyAuthVC!, animated: true, completion: nil)
    }
    
    @IBAction func applemusicBtnPressed(_ sender: Any) {
        self.activityIndicatorView.startAnimating()
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
                //stop loading indicator
                self.activityIndicatorView.stopAnimating()
                //show alert of failed request
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
                //update user's music provider in data base
                DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: appleMusicProviderKey, data: "true")
                
                //upload user's music data from apple music
               AppleMusicManager.instance.uploadAMData { (error) in
                    //self.activityIndicatorView.stopAnimating()
                    if error != nil {
                        //error handling from trying to upload Spotify Data
                        self.failedAlert.configureTheme(.error)
                        self.failedAlert.button?.isHidden = true
                        self.failedAlert.configureContent(title: "Woops!", body: "error" , iconText: iconText)
                        SwiftMessages.show(view: self.failedAlert)
                        return
                    } else {
                        self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
                    }
                }
            case .denied:
                //stop loading indicator
                self.activityIndicatorView.stopAnimating()
                //show failed alert
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

    @IBAction func skipBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
    }
}
