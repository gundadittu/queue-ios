//
//  CreateLiveVC.swift
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
import TwicketSegmentedControl
import NVActivityIndicatorView
import ButtonBackgroundColor

//func for when switch value changes - changes privacy value

class CreatePlaylistVC: UIViewController, IndicatorInfoProvider, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, TwicketSegmentedControlDelegate {
    
    private let _moodData =  Playlist.moodData
    private var _chosenMood: String?
    private var _playlistType: playlistType = .live
    private var _playlistPrivacyStatus: accessType =  accessType.publicAccess
    
    private var _participants = [playlistUser]()
    private var _invitations = [playlistInvitation]()
    //private var _liveStatus = livePlaylist.liveStatus.active
    //private var _trackList = [track]()
    //private var _owner_id = AuthService.instance.current_uid

    @IBOutlet weak var privateSwitch: UISwitch!
    @IBOutlet weak var createBtn: roundButton!
    private var moodPicker: UIPickerView!
    @IBOutlet weak var playlistNameTextField: HoshiTextField!
    @IBOutlet weak var moodPickerTextField: HoshiTextField!
    @IBOutlet weak var twicketSegment: TwicketSegmentedControl!
    private let failedLoginAlert = MessageView.viewFromNib(layout: .CardView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create"
        
        let titles = ["Live Playlist","Group Playlist"]
        twicketSegment.setSegmentItems(titles)
        twicketSegment.delegate = self
        twicketSegment.defaultTextColor = FlatWhite() //unselected
        twicketSegment.highlightTextColor = FlatPurple() //selected
        twicketSegment.segmentsBackgroundColor = FlatWhiteDark() //unselected
        twicketSegment.sliderBackgroundColor = UIColor.white
        twicketSegment.isSliderShadowHidden = true
        twicketSegment.backgroundColor = FlatPurpleDark()
        twicketSegment.font = UIFont(name: "Helvetica Neue", size: CGFloat(15))!
        
        createBtn.titleLabel?.textAlignment = .center
        createBtn.backgroundColorForStates(normal: FlatWhite(), highlighted: FlatWhiteDark())
        
        self.view.backgroundColor = FlatPurpleDark() //GradientColor(.topToBottom, frame: view.frame, colors: backgroundGradientColors)
        
        
        
        playlistNameTextField.delegate = self
        playlistNameTextField.tag = 0
        
        self.moodPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.moodPicker.dataSource = self
        self.moodPicker.delegate = self
        moodPickerTextField.delegate = self
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
        return _moodData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _moodData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self._chosenMood = _moodData[row]
        self.moodPickerTextField.text = _moodData[row]
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
            let title = playlistNameTextField.text
            let trackList = [track]()
            let mood = playlistMood(rawValue: self._chosenMood!)
            let invitations = [playlistInvitation]()
            let participants = [playlistUser]()
            let playlistPrivacyStatus = self._playlistPrivacyStatus
            let type = _playlistType
            var ownerID = AuthService.instance.current_uid
            //owner ID, playlist type
            let activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType(rawValue: loadingTypeNo)!, padding: 150)
            self.view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            
            //create group playlist - in database and local object
            
            /*
            DataService.instance.createGroupPlaylist(title: title!, type: type , ownerID: ownerID, trackList: trackList, playlistPrivacyStatus: playlistPrivacyStatus, mood: mood!, invitations: invitations, participants: participants, completionHandler: { (error, playlist) in
                DispatchQueue.main.async {
                    activityIndicatorView.stopAnimating()
                }
                if error == nil {
                    self.performSegue(withIdentifier: "createToGroupPlaylist", sender: playlist)
                } else {
                    self.failedLoginAlert.configureTheme(.error)
                    self.failedLoginAlert.button?.isHidden = true
                    self.failedLoginAlert.configureContent(title: "Uh oh!", body: "Something went wrong on our end. Try creating your playlist again.", iconText: iconText)
                    SwiftMessages.show(view: self.failedLoginAlert)
                }
            })
 */
        } else {
            self.failedLoginAlert.configureTheme(.error)
            self.failedLoginAlert.button?.isHidden = true
            self.failedLoginAlert.configureContent(title: "Something's blank!", body: "Make sure you gave your playlist a name and mood.", iconText: iconText)
            SwiftMessages.show(view: self.failedLoginAlert)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0{
            _playlistType = playlistType.live
        } else if segmentIndex == 1{
            _playlistType = playlistType.group
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createToGroupPlaylist"{
            /*
            if let playlistObj = sender as? GroupPlaylist{
                let destination = segue.destination as! GroupPlaylistContainerVC
                //destination.playlistName = playlistObj.title
                //destination.navigationItem.hidesBackButton = true 
            }
            */
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
}
