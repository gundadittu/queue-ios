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
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            IQKeyboardManager.sharedManager().enable = true
            IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Done"
            IQKeyboardManager.sharedManager().enableAutoToolbar = false 
           // IQKeyboardManager.sharedManager().toolbarTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            //IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
            //IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysShow
        
            if Auth.auth().currentUser == nil{
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
                playlistFeatures.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 40)
                playlistFeatures.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
                let groupPlaylists = OnboardingContentViewController(title: "Group Playlists", body: "Page body goes here.", image: nil, buttonText: nil) { () -> Void in return }
                groupPlaylists.topPadding = 0
                groupPlaylists.underIconPadding = 0
                groupPlaylists.titleLabel.textAlignment = .left
                groupPlaylists.bodyLabel.textAlignment = .left
                groupPlaylists.bodyLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
                let eventPlaylists = OnboardingContentViewController(title: "Event Playlists", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: nil) { () -> Void in return }
                eventPlaylists.topPadding = 0
                eventPlaylists.underIconPadding = 0
                eventPlaylists.titleLabel.textAlignment = .left
                eventPlaylists.bodyLabel.textAlignment = .left
                eventPlaylists.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 40)
                eventPlaylists.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
                let socialFeatures = OnboardingContentViewController(title: "Never Miss a Beat", body: "Page body goes here.", image: nil, buttonText: nil) { () -> Void in }
                socialFeatures.topPadding = 0
                socialFeatures.underIconPadding = 0
                socialFeatures.titleLabel.textAlignment = .left
                socialFeatures.bodyLabel.textAlignment = .left
                socialFeatures.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 40)
                socialFeatures.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
                
                let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "background"), contents: [logoPage,playlistFeatures, groupPlaylists, eventPlaylists, socialFeatures]) //change background to proper video or individual images
                onboardingVC?.shouldMaskBackground = false //change later?
                onboardingVC?.allowSkipping = true
                onboardingVC?.skipButton.setTitle("Get Started", for: UIControlState.normal )
                onboardingVC?.skipButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
                onboardingVC?.skipButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 20)
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
        
            //spotify auth
            auth.redirectURL  = URL(string: "Queue://returnAfterLogin")
            auth.sessionUserDefaultsKey = "current session"
        
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

}

