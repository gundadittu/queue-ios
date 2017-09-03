//
//  PermissionsVC.swift
//  Queue
//
//  Created by Aditya Gunda on 8/18/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import Sparrow
import ChameleonFramework

class PermissionsVC: UIViewController, SPRequestPermissionEventsDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  GradientColor(.topToBottom, frame: view.frame, colors: backgroundGradientColors)
    }

    @IBAction func btnPressed(_ sender: Any) {
        SPRequestPermission.native.present(with: [.notification, .locationAlways], delegate: self)
    }
    
    func didHide() {
      SPRequestPermission.native.present(with: [.notification, .locationAlways], delegate: self)
    }
    
    func didAllowPermission(permission: SPRequestPermissionType) {
        dismiss(animated: true, completion: nil)
    }
    
    func didDeniedPermission(permission: SPRequestPermissionType) {
        dismiss(animated: true, completion: nil)
    }
    
    func didSelectedPermission(permission: SPRequestPermissionType) {
        return
    }
    
}
