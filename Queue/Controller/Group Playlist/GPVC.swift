//
//  GroupPlaylistVC.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import SSBouncyButton
import ChameleonFramework
import VBFPopFlatButton
import XLPagerTabStrip
import ButtonBackgroundColor
import Colours
import PureLayout
import UIEmptyState

class GroupPlaylistVC: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider, UIEmptyStateDelegate, UIEmptyStateDataSource{
    
    var playlistName: String!
    //var trackList = [PlaylistTrack]()
    //var participants = [PlaylistUser]
    //var authorDisplayName: String!
    //var lastUpdated: String!
    //playlistImage: UIImage!
    //userStatusText: String!
    
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var createdByBtn: UIButton!
    @IBOutlet weak var lastUpdatedLbl: UILabel!
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var joinBtn: roundButton!
    @IBOutlet weak var saveLibraryBtn: roundButton!
    @IBOutlet weak var joinSaveStackView: UIStackView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var shuffleBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playlistInfoStackView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.title = "Playlist Name" //self.playlistName
        self.view.backgroundColor = UIColor.ghostWhite()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor =  UIColor.ghostWhite()

        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        self.reloadEmptyStateForTableView(self.tableView)

        self.playBtn.backgroundColorForStates(normal: FlatWhite(), highlighted: FlatWhiteDark())
        self.shuffleBtn.backgroundColorForStates(normal: FlatWhite(), highlighted: FlatWhiteDark())
        self.joinBtn.backgroundColorForStates(normal: FlatPurpleDark(), highlighted: FlatPurple())
        self.saveLibraryBtn.backgroundColorForStates(normal: FlatPurpleDark(), highlighted: FlatPurple())
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        let button = (self.emptyStateView as? UIEmptyStateView)?.button
        button?.layer.cornerRadius = 5
        button?.backgroundColorForStates(normal: FlatPurpleDark(), highlighted: FlatPurple())
        
        self.emptyStateView?.frame.origin.y = 600
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return trackList.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gpTrack") as! GroupPlaylistTrackCell
        cell.nameLabel.text = "Star Boy"
        cell.artistLabel.text = "Weeknd"
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PLAYLIST")
    }
    
    var emptyStateTitle: NSAttributedString {
        let attrs = [NSForegroundColorAttributeName: FlatWhiteDark(), NSFontAttributeName:  UIFont(name: "HelveticaNeue-Medium", size: CGFloat(15))]
        return NSAttributedString(string: "There are no songs in this playlist. \(iconText_sad)", attributes: attrs)
    }
    
    
    var emptyStateButtonTitle: NSAttributedString? {
       
        let attrs = [NSForegroundColorAttributeName: FlatWhite(), NSFontAttributeName:  UIFont(name: "HelveticaNeue-Medium", size: CGFloat(15))]
        return NSAttributedString(string: "Browse Suggestions", attributes: attrs)
    }
    
    var emptyStateButtonSize: CGSize? {
        return CGSize(width: 300, height: 50)
    }
    
    func emptyStatebuttonWasTapped(button: UIButton) {
        return
    }
 

}
