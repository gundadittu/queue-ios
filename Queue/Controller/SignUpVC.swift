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
import FBSDKLoginKit
import FacebookCore
import FacebookLogin

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameLbl: HoshiTextField!
    @IBOutlet weak var lastNameLbl: HoshiTextField!
    @IBOutlet weak var passwordLbl: HoshiTextField!
    @IBOutlet weak var facebookBtn: FBSDKLoginButton!
    
    @IBOutlet weak var emailAddLbl: HoshiTextField!
    let failedLoginAlert = MessageView.viewFromNib(layout: .CardView)

    @IBAction func facebookBtnPressed(_ sender: Any) {
        //start loading indicator
        let activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType(rawValue: loadingTypeNo)!, padding: 150)
        self.view.addSubview(activityIndicatorView)
        
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
                print("User cancelled login.")
            case LoginResult.success(let _, let _, let _):
                //print("Logged in!")
                //successfully authenticated with facebook
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //start loading indicator
                activityIndicatorView.startAnimating()
                AuthService.instance.facebookAuth(withCredential: credential, userAuthComplete: { success, error,
                    errorSource in
                    //stop loading indicator after registration request and login request done
                    activityIndicatorView.stopAnimating()
                    
                    if success == false && error != nil {   // error with firebase authenticate request or graph api
                        if let eSource = errorSource {
                            if eSource == "firebase"{ //error with firebase
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
                                    self.failedLoginAlert.configureContent(title: "Sorry!", body: "Your sign up failed. We reccomend you try logging in again.", iconText: iconText)
                                }
                                //show alert
                                SwiftMessages.show(view: self.failedLoginAlert)
                            } else if eSource == "graph_api" { // error with graph api
                                self.failedLoginAlert.configureTheme(.error)
                                self.failedLoginAlert.button?.isHidden = true
                                self.failedLoginAlert.configureContent(title: "Sorry!", body: "Your sign up failed. We reccomend you try signing up again.", iconText: iconText)
                                return
                            }
                        }
                    } else {
                        self.performSegue(withIdentifier: "musicpermissions", sender: nil)
                    }
                    
                })
            }
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        if emailAddLbl.text != "" && passwordLbl.text != "" && firstNameLbl.text != "" && lastNameLbl.text != "" {
            //start loading indicator
            let activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType(rawValue: loadingTypeNo)!, padding: 150)
            self.view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            
            //register user request
            AuthService.instance.registerUser(withEmail: self.emailAddLbl.text!, andPassword: self.passwordLbl.text!, firstName: self.firstNameLbl.text!, lastName: self.lastNameLbl.text!, userCreationComplete: { (success, error) in
                
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
                            self.failedLoginAlert.configureContent(title: "Sorry!", body: "Your login failed. Try logging in again.", iconText: iconText)
                        }
                    })
                } else {
                    //stop loading indicator after registration request and login request done
                    activityIndicatorView.stopAnimating()
                    //error with signing up request
                    let errCode = error!._code
                    self.failedLoginAlert.configureTheme(.error)
                    self.failedLoginAlert.button?.isHidden = true
                    switch errCode {
                    case 17008: //invalid email
                        self.failedLoginAlert.configureContent(title: "Woops!", body: "Check to see if you entered a valid email address.", iconText: iconText)
                    case 17007: //email already in use
                        self.failedLoginAlert.button?.isHidden = false
                        self.failedLoginAlert.button?.setTitle("Log In", for: .normal)
                        self.failedLoginAlert.buttonTapHandler = { _ in self.performSegue(withIdentifier: "signuptologin", sender: nil)}
                        self.failedLoginAlert.configureContent(title: "Woops!", body: "An account with this email address already exists.",iconText: iconText)
                    case 17999: //internal error
                        self.failedLoginAlert.configureTheme(.error)
                        self.failedLoginAlert.button?.isHidden = true
                        self.failedLoginAlert.configureContent(title: "Sorry!", body: "Something went wrong on our end. Try logging in again.")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLbl.delegate = self
        firstNameLbl.tag = 0
        lastNameLbl.delegate = self
        lastNameLbl.tag = 1
        emailAddLbl.delegate = self
        emailAddLbl.tag = 2
        passwordLbl.delegate = self
        passwordLbl.tag = 3
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
