//
//  GroupPlaylistTrack.swift
//  Queue
//
//  Created by Aditya Gunda on 9/2/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit

class GroupPlaylistTrackCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
