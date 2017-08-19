//
//  LoginVCViewController.swift
//  Queue
//
//  Created by Aditya Gunda on 8/17/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase
import SwiftMessages
import NVActivityIndicatorView

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    let failedLoginAlert = MessageView.viewFromNib(layout: .CardView)
    
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            //start loading indicator
            let activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType(rawValue: loadingTypeNo)!, padding: 150)
            self.view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete: { (success, error) in
                //stop loading indicatior
                activityIndicatorView.stopAnimating()
                
                if success {
                    //print("successful  login")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // error with login request
                    let errCode =  error!._code
                    self.failedLoginAlert.configureTheme(.error)
                    self.failedLoginAlert.button?.isHidden = true
                    switch errCode {
                    case 17008: //invalid email
                        self.failedLoginAlert.configureContent(title: "Woops!", body: "Check to see if you entered a valid email address.", iconText: iconText)
                    case 17009: //wrong or invalid password
                        self.failedLoginAlert.configureContent(title: "Woops!", body: "Check to see if you entered the right password.", iconText: iconText)
                    default:
                        self.failedLoginAlert.configureContent(title: "Sorry!", body: "Your login failed. We reccomend you try logging in again.", iconText: iconText)
                    }
                    //shows alert
                    SwiftMessages.show(view: self.failedLoginAlert)
                }
            })
        } else {
            //if any required field is nil
            self.failedLoginAlert.configureTheme(.error)
            self.failedLoginAlert.button?.isHidden = true
            self.failedLoginAlert.configureContent(title: "Oh no!", body: "It looks like you left something blank!", iconText: iconText)
            //shows alert
            SwiftMessages.show(view: self.failedLoginAlert)
        }
    }
}
