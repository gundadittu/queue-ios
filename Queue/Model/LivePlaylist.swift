//
//  LivePlaylist.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation

class livePlaylist : playlist {
   // private var _status: liveStatus
    
    enum liveStatus {
        case active
        case inactive
    }
    //location
    /*
    init(title: String, type: playlistType, playlistKey: String, owner_id: String, mood: playlistMood, genres: [trackGenre], trackList: [track], playlistPrivacyStatus: accessType, invitations: [playlistInvitation], participants: [playlistUser], status: liveStatus){
        self._status = status
        super.init(title: title, type: type, playlistKey: playlistKey, owner_id: owner_id, trackList: trackList, playlistPrivacyStatus: playlistPrivacyStatus, mood: mood, invitations: invitations, participants: participants, genres: genres)
    }
 */
}
