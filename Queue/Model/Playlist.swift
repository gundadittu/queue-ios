//
//  Playlist.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation

class playlist {

    static let moodData = ["Party","Focus","Chill","Shower","Sleep","Gaming","Travel","Dinner","Sad","Workout","Romance","Family"]
    
    private var _playlistKey: String
    private var _title: String

    /*
    private var _owner_id: String
    private var _playlistType: playlistType
    private var _trackList: [track]
    private var _participants: [playlistUser]
    private var _invitations: [playlistInvitation]
    private var _mood: playlistMood
    //private var suggestions: [playlistSuggestion]
    //private var image: Image
    private var _playlistPrivacyStatus: accessType
    */
    //add getters and setters
    
    var playlistKey: String {
        return _playlistKey
    }
    
    var title: String {
        get {
            return _title
        }
        set (newTitle) {
            _title = newTitle
        }
    }
    
    init(playlistKey: String, title: String)
    {
        self._playlistKey = playlistKey
        self._title = title
    }
    
    /*
    //invitation, participants, status, authordisplayname
    init(title: String, type: playlistType, playlistKey: String, owner_id: String, trackList: [track], playlistPrivacyStatus: accessType, mood: playlistMood, invitations: [playlistInvitation], participants: [playlistUser], genres: [playlistGenre]){
        
        self._playlistType = type
   
        self._owner_id = owner_id
    
        self._trackList = trackList
        
        self._playlistPrivacyStatus = playlistPrivacyStatus
        
        self._title = title
        
        self._playlistKey = playlistKey
        
        self._invitations = invitations
        
        self._participants = participants
        
        self._mood = mood
        
        //self._genre = genres
    }
 */
    
}
