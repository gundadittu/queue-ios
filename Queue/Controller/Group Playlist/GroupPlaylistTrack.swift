//
//  GroupPlaylistTrack.swift
//  Queue
//
//  Created by Aditya Gunda on 9/2/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit

class GroupPlaylistTrack: UITableViewCell {

    //track class 
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var downvoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //update info from class
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
    }
    @IBAction func downvotePressed(_ sender: Any) {
    }
    @IBAction func moreOptionsPressed(_ sender: Any) {
    }
    
}
