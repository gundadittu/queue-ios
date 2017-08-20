//
//  ForgotPasswordVC.swift
//  Queue
//
//  Created by Aditya Gunda on 8/18/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects
import SwiftMessages
import NVActivityIndicatorView

class ForgotPasswordVC: UIViewController {
    let failedAlert = MessageView.viewFromNib(layout: .CardView)
    let successAlert = MessageView.viewFromNib(layout: .CardView)
    @IBOutlet weak var emailAddBtn: HoshiTextField!

    @IBAction func resetPasswordBtnPressed(_ sender: Any) {
        
        if emailAddBtn!.text != "" {
            //start loading indicator
            let activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType(rawValue: loadingTypeNo)!, padding: 150)
            self.view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            
            //password reset request
            Auth.auth().sendPasswordReset(withEmail: emailAddBtn!.text!) { (error) in
                activityIndicatorView.stopAnimating()
                
                //error with password reset request
                if error != nil{
                    let errCode = error!._code
                    self.failedAlert.configureTheme(.error)
                    self.failedAlert.button?.isHidden = true
                    switch errCode {
                    case 17008: //invalid email
                        self.failedAlert.configureContent(title: "Woops!", body: "Check to see if you entered a valid email address.", iconText: iconText)
                    case 17011: //no user found
                        self.failedAlert.configureContent(title: "Woops!", body: "We couldn't find an account with that email address.", iconText: iconText)
                    case 17999: //internal error
                        self.failedAlert.configureContent(title: "Sorry!", body: "Something went wrong on our end. Try logging in again.")
                    default:
                        self.failedAlert.configureContent(title: "Sorry!", body: "Your password reset failed. Try again!", iconText: iconText)
                    }
                    //show alert
                    SwiftMessages.show(view: self.failedAlert)
                } else {
                    // successful password reset request case
                    self.successAlert.configureTheme(.success)
                    self.successAlert.button?.isHidden = false
                    self.successAlert.button?.setTitle("Log In", for: .normal)
                    self.successAlert.buttonTapHandler = { _ in self.navigationController?.popViewController(animated: true) }
                    self.successAlert.configureContent(title: "Success!", body: "Check your email for a link to reset your password.", iconText: iconText_success!)
                    SwiftMessages.show(view: self.successAlert)
                }
            }
        } else {
            //required fields left unfilled case
            self.failedAlert.configureTheme(.error)
            self.failedAlert.button?.isHidden = true
            self.failedAlert.configureContent(title: "Oh no!", body: "It looks like you forgot to enter your email!", iconText: iconText)
            //show alert
            SwiftMessages.show(view: self.failedAlert)
        }
   }
}
