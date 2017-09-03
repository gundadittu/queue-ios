//
//  SearchNavigationController.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework

class SearchNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = FlatPurpleDark()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatWhite()]
        self.navigationBar.tintColor = FlatWhite()
    }
}
