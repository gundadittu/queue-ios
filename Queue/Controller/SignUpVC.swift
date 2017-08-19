//
//  EmailSignUp.swift
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

class SignUpVC: UIViewController {

    @IBOutlet weak var firstNameLbl: HoshiTextField!
    @IBOutlet weak var lastNameLbl: HoshiTextField!
    @IBOutlet weak var passwordLbl: HoshiTextField!
    
    @IBOutlet weak var emailAddLbl: HoshiTextField!
    let failedLoginAlert = MessageView.viewFromNib(layout: .CardView)
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        if emailAddLbl.text != nil && passwordLbl.text != nil && firstNameLbl.text != nil && lastNameLbl.text != nil {
            //start loading indicator
            let activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType(rawValue: loadingTypeNo)!, padding: 150)
            self.view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            
            //register user request
            AuthService.instance.registerUser(withEmail: self.emailAddLbl.text!, andPassword: self.passwordLbl.text!, userCreationComplete: { (success, error) in
                
                if success {
                   //then log in user after successful sign up
                    AuthService.instance.loginUser(withEmail: self.emailAddLbl.text!, andPassword: self.passwordLbl.text!, loginComplete: { (success, nil) in
                        //stop loading indicator after registration request and login request done
                        activityIndicatorView.stopAnimating()
                        if success {
                            self.performSegue(withIdentifier: "musicpermissions", sender: nil)
                        } else {
                            //error with logging in request
                            self.failedLoginAlert.configureTheme(.error)
                            self.failedLoginAlert.button?.isHidden = true
                            self.failedLoginAlert.configureContent(title: "Sorry!", body: "Your login failed. Try logging in again.")
                        }
                    })
                } else {
                    //error with signing up request
                    let errCode = error!._code
                    self.failedLoginAlert.configureTheme(.error)
                    self.failedLoginAlert.button?.isHidden = true
                    switch errCode {
                    case 17008: //invalid email
                        self.failedLoginAlert.configureContent(title: "Woops!", body: "Check to see if you entered a valid email address.", iconText: iconText)
                    case 17007: //email already in use
                        self.failedLoginAlert.button?.setTitle("Log In", for: .normal)
                        //self.failedLoginAlert.buttonTapHandler - need to add action
                        var config = SwiftMessages.Config()
                        config.duration = .forever
                        self.failedLoginAlert.configureContent(title: "Woops!", body: "An account with this email address already exists. Go back and try logging in.",iconText: iconText)
                    default:
                        self.failedLoginAlert.configureContent(title: "Sorry!", body: "Your sign up failed. Try signing up again.", iconText: iconText)
                    }
                    //shows alert
                    SwiftMessages.show(view: self.failedLoginAlert)
                }
                })
        } else {
            //some required fields left unfilled
            self.failedLoginAlert.configureTheme(.error)
            self.failedLoginAlert.button?.isHidden = true
            self.failedLoginAlert.configureContent(title: "Oh no!", body: "It looks like you left something blank!", iconText: iconText)
            //shows alert
            SwiftMessages.show(view: self.failedLoginAlert)
        }
    }
}


