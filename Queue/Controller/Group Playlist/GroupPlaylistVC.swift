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

class GroupPlaylistVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var playlistName: String?
    var trackList = [track]()
    
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlistNameLabel.text = playlistName
        self.navigationItem.title = "Group Playlist"
        tableView.dataSource = self
        tableView.delegate = self


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("GroupPlaylistTrack", owner: self, options: nil)?.first as! GroupPlaylistTrack
        //cell.title
        //cell.image
        return cell 
    }
    

}
