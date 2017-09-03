//
//  GetStarted.swift
//  Queue
//
//  Created by Aditya Gunda on 8/17/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework

class GetStartedVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  GradientColor(.topToBottom, frame: view.frame, colors: backgroundGradientColors)
    }
}
