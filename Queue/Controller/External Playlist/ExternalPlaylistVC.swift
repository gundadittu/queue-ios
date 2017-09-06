//
//  ExternalPlaylistVC.swift
//  Queue
//
//  Created by Aditya Gunda on 9/3/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ButtonBackgroundColor
import ChameleonFramework
import Colours
import CRRefresh
import UIEmptyState
import SwipeCellKit
import RMActionController
import Kingfisher

class ExternalPlaylistVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIEmptyStateDelegate, UIEmptyStateDataSource, SwipeTableViewCellDelegate {
    
    
    var playlistName: String?
    var playlistSource: String?
    var imageURL: String?

    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var authorDisplayBtn: UIButton!
    @IBOutlet weak var spotifyLabel: roundLabel!
    @IBOutlet weak var appleMusicLabel: roundLabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var shuffleBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveToLibraryBtn: roundButton!
    
    var trackList = [PlaylistTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesNavigationBarHairline = true
        self.updateUI()
        
        self.view.layoutIfNeeded()
        self.playlistImage.layer.masksToBounds = true
        self.playlistImage.layer.cornerRadius  = 5
    
        self.shuffleBtn.backgroundColorForStates(normal: FlatWhite(), highlighted: FlatWhiteDark())
        self.shuffleBtn.layer.cornerRadius = CGFloat(5)
        self.playBtn.backgroundColorForStates(normal: FlatWhite(), highlighted: FlatWhiteDark())
        self.playBtn.layer.cornerRadius = CGFloat(5)
        self.saveToLibraryBtn.backgroundColorForStates(normal: FlatPurpleDark(), highlighted: FlatPurple())
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        /*
        self.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.updateUI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableView.cr.endHeaderRefresh()
            })
        }
         */
        //self.emptyStateDataSource = self
        //self.emptyStateDelegate = self
        //self.reloadEmptyStateForTableView(self.tableView)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if playlistSource == "apple_music" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AMTrack", for: indexPath) as! AMExternalPlaylistTrackCell
            cell.delegate = self
            let track = trackList[indexPath.row] as! AMPlaylistTrack
            cell.trackNameLabel.text = track.songName
            cell.artistNameLabel.text = track.artistName
            return cell
        } else if playlistSource == "spotify" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SPTrack", for: indexPath) as! SPExternalPlaylistTrackCell
            cell.delegate = self
            let track = trackList[indexPath.row] as! SPPlaylistTrack
            cell.trackNameLabel.text = track.songName
            cell.artistNameLabel.text = track.artistName
            let imageURL = URL(string: track.imageURL)
            cell.trackImageView?.kf.setImage(with: imageURL)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(55)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let moreAction = SwipeAction(style: .default, title: "More") { action, indexPath in
            self.openSongOptionActionController()
        }
        moreAction.image = UIImage(named: "delete")
        return [moreAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        return options
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func updateUI(){
        playlistNameLabel?.text = playlistName
        let imageModifiedURL = URL(string: self.imageURL!)
        playlistImage.kf.setImage(with: imageModifiedURL)
        if playlistSource == "apple_music"{
            self.appleMusicLabel?.isHidden = false
        } else if playlistSource == "spotify" {
            self.spotifyLabel?.isHidden = false
        }
        //update tracks
        //self.reloadEmptyStateForTableView(self.tableView)
        self.tableView.reloadData()
    }
    
    func openSongOptionActionController() {
        
        /*
        let selectAction = RMAction<UIView>(title: "Select", style: RMActionStyle.done) { controller in
            return
        }
         */
 
        let cancelAction = RMAction<UIView>(title: "Cancel", style: RMActionStyle.cancel) { _ in
            self.tabBarController?.tabBar.isHidden = false
        }
        
        let actionController = SongOptionsController(style: .white, title: "Song Options", message: nil, select: nil, andCancel: cancelAction)
        actionController?.addAction(RMAction<UIView>(title: "Add to Library", style: RMActionStyle.default) { _ in
            self.tabBarController?.tabBar.isHidden = false
            }!)
        
        //Now just present the action controller using the standard iOS presentation method
        self.tabBarController?.tabBar.isHidden = true
        present(actionController!, animated: true, completion: nil)
    }
    
}
