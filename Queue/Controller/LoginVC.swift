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
import FBSDKLoginKit
import FacebookLogin
import FacebookCore

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    let failedLoginAlert = MessageView.viewFromNib(layout: .CardView)
    
    @IBOutlet weak var facebookBtn: FBSDKLoginButton!
    
    
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult { //facebook sign up request result
            case LoginResult.failed(let error): //facebook sign up request failed
                print(error)
                self.failedLoginAlert.configureTheme(.error)
                self.failedLoginAlert.button?.isHidden = true
                self.failedLoginAlert.configureContent(title: "Sorry!", body: "Your sign up failed. We reccomend you try signing up again.", iconText: iconText)
                SwiftMessages.show(view: self.failedLoginAlert)
            case LoginResult.cancelled: //facebook sign up request cancelled
                return
            case LoginResult.success(let _, let _, let _):
                //successfully authenticated with facebook
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                AuthService.instance.facebookLogin(withCredential: credential, userLoginComplete: { (success, error) in
                    if success == false && error != nil {   // error with firebase authenticate request or graph api
                                // error with firebase authenticate request
                                let errCode =  error!._code
                                self.failedLoginAlert.configureTheme(.error)
                                self.failedLoginAlert.button?.isHidden = true
                                switch errCode {
                                case 17008: //invalid email
                                    self.failedLoginAlert.configureContent(title: "Woops!", body: "Check to see if you entered a valid email address.", iconText: iconText)
                                case 17009: //wrong or invalid password
                                    self.failedLoginAlert.configureContent(title: "Woops!", body: "Check to see if you entered the right password.", iconText: iconText)
                                case 17011: //no user found
                                    self.failedLoginAlert.configureContent(title: "Woops!", body: "We couldn't find an account with that email address.", iconText: iconText)
                                case 17999: //internal error
                                    self.failedLoginAlert.configureContent(title: "Sorry!", body: "Something went wrong on our end. Try logging in again.")
                                case 17007: //email already in use
                                    self.failedLoginAlert.button?.isHidden = false
                                    self.failedLoginAlert.button?.setTitle("Log In", for: .normal)
                                    self.failedLoginAlert.buttonTapHandler = { _ in self.performSegue(withIdentifier: "signuptologin", sender: nil)}
                                    self.failedLoginAlert.configureContent(title: "Woops!", body: "An account with this email address already exists.",iconText: iconText)
                                default:
                                    self.failedLoginAlert.configureContent(title: "Sorry!", body: "Your login failed. We reccomend you try logging in again.", iconText: iconText)
                                }
                                //show alert
                                SwiftMessages.show(view: self.failedLoginAlert)
                        } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
            
    @IBAction func logInBtnPressed(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
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
                    case 17011: //no user found
                        self.failedLoginAlert.configureContent(title: "Woops!", body: "We couldn't find an account with that email address.", iconText: iconText)
                    case 17999: //internal error
                        self.failedLoginAlert.configureContent(title: "Sorry!", body: "Something went wrong on our end. Try logging in again.")
                    default:
                        print(errCode)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        emailField.tag = 0
        passwordField.delegate = self
        passwordField.tag = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}
