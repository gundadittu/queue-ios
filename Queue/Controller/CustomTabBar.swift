//
//  CustomTabBar.swift
//  Queue
//
//  Created by Aditya Gunda on 8/30/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework

class CustomTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNavController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as! HomeNavigationController
        homeNavController.tabBarItem.title = "Home"
        homeNavController.tabBarItem.image = UIImage(named: "home_icon")
        homeNavController.tabBarItem.selectedImage = UIImage(named: "home_icon")?.withRenderingMode(.alwaysOriginal)
        homeNavController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: FlatPurple()], for: .selected)
        
        let searchNavController = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "searchnavcontroller") as! SearchNavigationController
        searchNavController.tabBarItem.title = "Search"
        searchNavController.tabBarItem.image = UIImage(named: "search_icon")
        searchNavController.tabBarItem.selectedImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        searchNavController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: FlatPurple()], for: .selected)

        let createNavController = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "CreatePlaylistNavigationController") as! CreatePlaylistNavigationController
        let createImageFilled = UIImage(named: "add_icon")?.withRenderingMode(.alwaysOriginal)
        let createImage = UIImage(named: "add_icon_notfilled")?.withRenderingMode(.alwaysOriginal)
        createNavController.tabBarItem.image = createImageFilled
        createNavController.tabBarItem.selectedImage = createImage
        createNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        createNavController.tabBarController?.modalPresentationStyle = .overFullScreen
        createNavController.tabBarItem.title = nil
        
        let notificationsNavController = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notificationsnavcontroller") as! NotificationsNavController
        notificationsNavController.tabBarItem.title = "Alerts"
        notificationsNavController.tabBarItem.image = UIImage(named: "notification_icon")
        notificationsNavController.tabBarItem.selectedImage = UIImage(named: "notification_icon")?.withRenderingMode(.alwaysOriginal)
        notificationsNavController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: FlatPurple()], for: .selected)
        
        let libraryNavController =  UIStoryboard(name: "Library", bundle: nil).instantiateViewController(withIdentifier: "LibraryNavigationController") as! LibraryNavigationController
        libraryNavController.title = "Library"
        libraryNavController.tabBarItem.image = UIImage(named: "library_icon")
        libraryNavController.tabBarItem.selectedImage = UIImage(named: "library_icon")?.withRenderingMode(.alwaysOriginal)
        libraryNavController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: FlatPurple()], for: .selected)

        viewControllers = [homeNavController, searchNavController, createNavController, notificationsNavController, libraryNavController]
        
        self.tabBar.barTintColor = UIColor.white
    }

}
