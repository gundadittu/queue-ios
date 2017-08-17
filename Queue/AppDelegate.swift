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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if Auth.auth().currentUser == nil{
          
            //update bodies of all these VC's
            let logoPage = OnboardingContentViewController(title: "Discover music together through intelligent playlists.", body: "Scroll through to learn more.", image: nil, buttonText: nil) { () -> Void in return } //add logo to top
            //logoPage.topPadding = 0
            //logoPage.underIconPadding = 0
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
            groupPlaylists.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 40)
            groupPlaylists.bodyLabel.font = UIFont(name: "Avenir-Thin", size: 20)
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
            
            let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "Feed"), contents: [logoPage,playlistFeatures, groupPlaylists, eventPlaylists, socialFeatures]) //change background to proper video or individual images
            onboardingVC?.allowSkipping = true
            onboardingVC?.skipButton.setTitle("Get Started", for: UIControlState.normal )
            onboardingVC?.skipButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
            onboardingVC?.skipHandler = {
                onboardingVC?.dismiss(animated: true, completion: nil)
                //present login screen
            }
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(onboardingVC!, animated: true, completion: nil)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

