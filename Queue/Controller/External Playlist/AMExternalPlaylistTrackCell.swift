//
//  epTrackCell.swift
//  Queue
//
//  Created by Aditya Gunda on 9/3/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import Colours
import SwipeCellKit

class AMExternalPlaylistTrackCell: SwipeTableViewCell {

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var recentlyAddedLabel: UILabel!
    @IBOutlet weak var newReleaseLabel: UILabel!
    @IBOutlet weak var trackImageView: roundTrackImage!
    
    var playbackID: String?
    var songDuration: Double?
    var songSourceID: Int?
    var source: String?
    var albumName: String?
    var albumType: String? 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.trackImageView.layer.masksToBounds = true
        self.trackImageView.layer.cornerRadius  = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

