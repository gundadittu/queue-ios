//
//  SPExternalPlaylistTrackCell.swift
//  Queue
//
//  Created by Aditya Gunda on 9/4/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import SwipeCellKit
import Kingfisher

class SPExternalPlaylistTrackCell: SwipeTableViewCell {
    
    //var imageURL: String?

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var recentlyAddedLabel: UILabel!
    @IBOutlet weak var newReleaseLabel: UILabel!
    @IBOutlet weak var trackImageView: roundTrackImage!
    
    var songDuration: Double?
        var songSourceID: Int?
        var source: String?
        var albumName: String?
        var albumType: String?
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            //let imageModifiedURL = URL(string: self.imageURL!)
            //self.trackImageView.kf.setImage(with: imageModifiedURL)
            self.trackImageView.layer.masksToBounds = true
            self.trackImageView.layer.cornerRadius  = 5
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
}

