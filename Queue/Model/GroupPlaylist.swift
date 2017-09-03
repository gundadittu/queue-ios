//
//  GroupPlaylist.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GroupPlaylist : playlist {
    
    override init (playlistKey: String, title: String){
        let ref = DataService.instance.REF_EXTERNALPLAYLISTS_PLAYLISTS.child("\(playlistKey)")
        
        super.init(playlistKey: playlistKey, title: title)

        /*
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let title = value?["name"] as? String ?? ""
            super.init(playlistKey: playlistKey, title: title)
        })
     */
        
      
    }
    
    /*
    init(title: String, type: playlistType, playlistKey: String, owner_id: String, mood: playlistMood, genres: [playlistGenre], trackList: [track], playlistPrivacyStatus: accessType, invitations: [playlistInvitation], participants: [playlistUser]){
        super.init(title: title, type: type, playlistKey: playlistKey, owner_id: owner_id, trackList: trackList, playlistPrivacyStatus: playlistPrivacyStatus, mood: mood, invitations: invitations, participants: participants, genres: genres)
    }
     */
    
}
