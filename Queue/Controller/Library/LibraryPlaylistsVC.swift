//
//  LibraryVC.swift
//  Queue
//
//  Created by Aditya Gunda on 8/31/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework
import XLPagerTabStrip
import Kingfisher

class LibraryPlaylistsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    var playlists = [Playlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Library"
        self.view.backgroundColor = FlatWhite()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        DataService.instance.getUserExternalPlaylistData(userID: AuthService.instance.current_uid, completionHandler: { array in
            self.playlists = array
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistObj = playlists[indexPath.row]
        switch playlistObj.type {
        case .externalAppleMusic:
            self.performSegue(withIdentifier: "toAMExternalPlaylist", sender: playlistObj)
        case .externalSpotify:
              self.performSegue(withIdentifier: "toSPExternalPlaylist", sender: playlistObj)
        case .live:
            return
        case .liveInactive:
            return
        case .group:
            return
        case .groupInactive:
            return 
        }
     }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlistObj = playlists[indexPath.row] as! Playlist
        let playlistType = playlistObj.type
        switch playlistType {
            case .externalAppleMusic:
                let cell = tableView.dequeueReusableCell(withIdentifier: "externalPlaylist") as! ExternalPlaylistCell
                let playlist = playlists[indexPath.row] as! AMExternalPlaylist
                cell.playlistNameLabel.text = playlist.name
                //cell.playlistTypeLabel.text = "Apple Music"
               /// cell.playlistImage.kf.setImage(with: playlist.imageURL)
                return cell
            case .externalSpotify:
                let cell = tableView.dequeueReusableCell(withIdentifier: "externalPlaylist") as! ExternalPlaylistCell
                let playlist = playlists[indexPath.row] as! SPExternalPlaylist
                cell.playlistNameLabel.text = playlist.name
                //cell.playlistTypeLabel.text = "Spotify"
                let imageURL = URL(string: playlist.imageURL)
                cell.playlistImage.kf.setImage(with: imageURL)
                return cell
            case .group:
                return UITableViewCell()
            case .groupInactive:
                return UITableViewCell()
            case .live:
                return UITableViewCell()
            case .liveInactive:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAMExternalPlaylist" {
            let playlistObj = sender as! AMExternalPlaylist
            let destination = segue.destination as! ExternalPlaylistVC
            destination.playlistName = playlistObj.name
            destination.trackList = playlistObj.trackList
            destination.playlistSource = playlistObj.source
        } else if segue.identifier == "toSPExternalPlaylist" {
            let playlistObj = sender as! SPExternalPlaylist
            let destination = segue.destination as! ExternalPlaylistVC
            destination.playlistName = playlistObj.name
            destination.trackList = playlistObj.trackList
            destination.playlistSource = playlistObj.source
            destination.imageURL = playlistObj.imageURL
            //let imageURL = URL(string: playlistObj.imageURL)
            //destination.playlistImage?.kf.setImage(with: imageURL)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PLAYLISTS")
    }

}
