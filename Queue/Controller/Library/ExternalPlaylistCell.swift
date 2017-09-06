//
//  externalPlaylistCell.swift
//  Queue
//
//  Created by Aditya Gunda on 9/3/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit

class ExternalPlaylistCell: UITableViewCell {

    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newSongsLabel: UILabel!
    
    //var playlistObj: Playlist!
    //var playlistSource: String?
    
    //author display name, new songs Label, image, playlist type 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.playlistImage.layer.masksToBounds = true
        self.playlistImage.layer.cornerRadius  = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
