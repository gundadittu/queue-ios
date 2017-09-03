//
//  CreateGroupVC.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ChameleonFramework
import TextFieldEffects
import SwiftMessages

class CreateGroupVC: UIViewController, IndicatorInfoProvider, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let moodData = ["Party","Focus","Chill","Shower","Sleep","Gaming","Travel","Dinner","Sad","Workout","Romance","Family"]
    var chosenMood: String?
    var playlistTypeTag = playlistType.group
    var participants = [playlistUser]()
    var owner_id = AuthService.instance.current_uid
    var chosenGenres = [trackGenre]()
    var trackList = [track]()
    var playlistPrivacyStatus = accessType.publicAccess
    var invitations = [playlistInvitation]()

    @IBOutlet weak var playlistNameTextField: HoshiTextField!
    @IBOutlet weak var moodPickerTextField: HoshiTextField!
    var moodPicker: UIPickerView!
    
    let failedLoginAlert = MessageView.viewFromNib(layout: .CardView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  GradientColor(.topToBottom, frame: view.frame, colors: backgroundGradientColors)
        playlistNameTextField.delegate = self
        playlistNameTextField.tag = 0
        
        self.moodPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.moodPicker.dataSource = self
        self.moodPicker.delegate = self
        moodPickerTextField.delegate = self
        moodPickerTextField.tag = 1
        moodPickerTextField.inputView = self.moodPicker
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.tintColor = FlatPurple()
        toolBar.barTintColor = FlatWhite()
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        moodPickerTextField.inputAccessoryView = toolBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Live Playlist")
    }
    
    
    @IBAction func pickerBtnPressed(_ sender: Any) {
        moodPicker.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moodData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return moodData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.chosenMood = moodData[row]
        self.moodPickerTextField.text = moodData[row]
    }
    
    func doneClick() {
        moodPickerTextField.resignFirstResponder()
    }
    func cancelClick() {
        moodPickerTextField.resignFirstResponder()
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        if self.moodPickerTextField.text != "" && self.playlistNameTextField.text != "" {
            print("success")
            //show loading indicator?
            //create live playlist -> database, etc.
            //segue to playlist screen
        } else {
            self.failedLoginAlert.configureTheme(.error)
            self.failedLoginAlert.button?.isHidden = true
            self.failedLoginAlert.configureContent(title: "Something's blank!", body: "Make sure you gave your playlist a name and mood.", iconText: iconText)
            SwiftMessages.show(view: self.failedLoginAlert)
        }
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

