//
//  LibraryNavigationController.swift
//  Queue
//
//  Created by Aditya Gunda on 8/30/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework

class LibraryNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatBlack()]
        self.navigationBar.tintColor = FlatPurpleDark()
        self.hidesNavigationBarHairline = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
