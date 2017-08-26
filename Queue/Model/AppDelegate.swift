//
//  AppDelegate.swift
//  Queue
//
//  Created by Aditya Gunda on 8/3/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import Firebase
import Onboard
import FBSDKCoreKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var auth = SPTAuth()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
        
            if Auth.auth().currentUser == nil{
                self.welcomeScreens()
            }
        
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
            IQKeyboardManager.sharedManager().enable = true
            IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Done"
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
            //spotify auth
            auth.redirectURL  = URL(string: "Queue://returnAfterLogin")
            auth.sessionUserDefaultsKey = "current session"
            auth.tokenSwapURL = URL(string: SPtokenSwap_URL)
            auth.tokenRefreshURL =  URL(string: SPtokenRefresh_URL)
        
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if Auth.auth().currentUser == nil{
                    self.welcomeScreens()
                }
            }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //spotify auth
        if auth.canHandle(auth.redirectURL) {
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
                if error != nil {
                    print("error!")
                }
                let userDefaults = UserDefaults.standard // change?
                let sessionData = NSKeyedArchiver.archivedData(withRootObject: session as Any)
                userDefaults.set(sessionData, forKey: "SpotifySession")
                userDefaults.synchronize()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
            })
            return true
        } else {
            return false
        }
        
        //facebook auth
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }

    func welcomeScreens(){
            //update bodies of all these VC's
            let logoPage: OnboardingContentViewController = OnboardingContentViewController(title: "Discover music together through intelligent playlists.", body: nil, image: nil, buttonText: nil) { () -> Void in return } //add logo to top
            logoPage.titleLabel.textAlignment = .left
            logoPage.bodyLabel.textAlignment = .left
            logoPage.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 40)
            logoPage.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
            let playlistFeatures = OnboardingContentViewController(title: "A Playlist Everyone Can Play With", body: "Page body goes here.", image: nil, buttonText: nil) { () -> Void in return }
            playlistFeatures.topPadding = 0
            playlistFeatures.underIconPadding = 0
            playlistFeatures.titleLabel.textAlignment = .left
            playlistFeatures.bodyLabel.textAlignment = .left
            playlistFeatures.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 30)
            playlistFeatures.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
            let groupPlaylists = OnboardingContentViewController(title: "Group Playlists", body: "Page body goes here.", image: nil, buttonText: nil) { () -> Void in return }
            groupPlaylists.topPadding = 0
            groupPlaylists.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 30)
            groupPlaylists.underIconPadding = 0
            groupPlaylists.titleLabel.textAlignment = .left
            groupPlaylists.bodyLabel.textAlignment = .left
            groupPlaylists.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
            let livePlaylists = OnboardingContentViewController(title: "Go Live", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: nil) { () -> Void in return }
            livePlaylists.topPadding = 0
            livePlaylists.underIconPadding = 0
            livePlaylists.titleLabel.textAlignment = .left
            livePlaylists.bodyLabel.textAlignment = .left
            livePlaylists.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 30)
            livePlaylists.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
            let socialFeatures = OnboardingContentViewController(title: "Never Miss a Beat", body: "Page body goes here.", image: nil, buttonText: nil) { () -> Void in }
            socialFeatures.topPadding = 0
            socialFeatures.underIconPadding = 0
            socialFeatures.titleLabel.textAlignment = .left
            socialFeatures.bodyLabel.textAlignment = .left
            socialFeatures.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 30)
            socialFeatures.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
            
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "background"), contents: [logoPage,playlistFeatures, groupPlaylists, livePlaylists, socialFeatures]) //change background to proper video or individual images
            onboardingVC?.shouldMaskBackground = false //change later?
            onboardingVC?.allowSkipping = true
            let skipButton = onboardingVC?.skipButton
            skipButton!.setTitle("Get Started", for: UIControlState.normal )
            skipButton!.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
            skipButton!.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 20)
            skipButton!.titleLabel?.adjustsFontSizeToFitWidth = true
            onboardingVC?.skipHandler = {
                onboardingVC?.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let getstartedVC = storyboard.instantiateViewController(withIdentifier: "gsnav")
                self.window?.makeKeyAndVisible()
                self.window?.rootViewController?.present(getstartedVC, animated: true, completion: nil) //different way to do this?
            }
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(onboardingVC!, animated: true, completion: nil)
    }

}

