//
//  Playlist.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MediaPlayer

class Playlist {

    static let moodData = ["Party","Focus","Chill","Shower","Sleep","Gaming","Travel","Dinner","Sad","Workout","Romance","Family"]
    
    enum PlaylistType: String{
        case externalSpotify = "Spotify"
        case externalAppleMusic = "Apple Music"
        case live = "Live"
        case liveInactive = "Saved Live"
        case group = "Group"
        case groupInactive = "Inactive Group"
    }
    
    //fileprivate var _playlistKey: String
    fileprivate var _name: String!
    fileprivate var _trackCount: Int!
    fileprivate var _type: PlaylistType!
    
    /*
    var playlistkey: String {
        return _playlistKey
    }
 */
    
    var type: PlaylistType {
        return _type
    }
    
    var name: String {
        return _name
    }
 
    var trackCount: Int {
        return _trackCount
    }
  

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
    
    
    init(snapshot: DataSnapshot, type: PlaylistType)
    {
        let dict = snapshot.value as! [String:Any]
        let playlistName = dict[playlistNameKey] as! String
       // let playlistKey = dict[playlistKeyKey] as! Int
        let trackCount = dict[playlistTrackCountKey] as! Int
        self._name = playlistName
        self._trackCount = trackCount
        self._type = type
       // self._playlistKey = playlistKey
    }
}


 class ExternalPlaylist : Playlist {
   
    fileprivate var _sourceID: String!
    fileprivate var _source: String
    
    var sourceID: String {
        return _sourceID
    }
    var source: String {
        return _source
    }
 
    override init(snapshot: DataSnapshot, type: PlaylistType){
        let dict = snapshot.value as! [String:Any]
        let playlistSourceID = dict[playlistSourceIDKey] as! String
        let source = dict[sourceKey] as! String
        self._sourceID = playlistSourceID
        self._source = source
        super.init(snapshot: snapshot, type: type)
     }
}

class AMExternalPlaylist : ExternalPlaylist {
    
    fileprivate var _trackList = [PlaylistTrack]()
    
    var trackList: [PlaylistTrack] {
        return _trackList
    }
    
    
    
    override init(snapshot: DataSnapshot, type: PlaylistType) {
        let ref = DataService.instance.REF_EXTERNALPLAYLISTS_PLAYLISTS
        let trackListSnapshot = snapshot.childSnapshot(forPath: "\(playlistTracksKey)")
        var modifiedTrackList = [PlaylistTrack]()
        for track in trackListSnapshot.children {
            let modifiedTrack = AMPlaylistTrack(snapshot: (track as! DataSnapshot))
            modifiedTrackList.append(modifiedTrack)
        }
        self._trackList = modifiedTrackList
        super.init(snapshot: snapshot, type: type)
    }
    
    func updatePlaylistData(){
        
    }
}


class SPExternalPlaylist : ExternalPlaylist {
    
    fileprivate var _imageURL: String!
    fileprivate var _trackList = [PlaylistTrack]()
    
    var trackList: [PlaylistTrack] {
        return _trackList
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    override init(snapshot: DataSnapshot, type: PlaylistType) {
        let trackListSnapshot = snapshot.childSnapshot(forPath: "\(playlistTracksKey)")
        var modifiedTrackList = [PlaylistTrack]()
        for track in trackListSnapshot.children {
            let modifiedTrack = SPPlaylistTrack(snapshot: (track as! DataSnapshot))
            modifiedTrackList.append(modifiedTrack)
        }
        self._trackList = modifiedTrackList
       
        let dict = snapshot.value as! [String:Any]
        let imageURL = dict[imageURLKey] as! String
        self._imageURL = imageURL
        super.init(snapshot: snapshot, type: type)
    }
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

 /*
 init(playlistName: String, sourceID: Int, source: String, trackCount: Int, trackList: [PlaylistTrack]) {
 self._name = playlistName
 self._sourceID = sourceID
 self._source = source
 self._trackCount = trackCount
 self._trackList = trackList
 }
 
 }
 */
