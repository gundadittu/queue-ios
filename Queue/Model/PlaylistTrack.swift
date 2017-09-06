//
//  playlistTrack.swift
//  Queue
//
//  Created by Aditya Gunda on 9/3/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation
import Firebase
import MediaPlayer

class PlaylistTrack {
    //replace string source with enum? 
    enum TrackSource: String {
        case spotify = "Spotify"
        case appleMusic = "Apple Music"
    }
    
    fileprivate var _songName: String!
    fileprivate var _source: String!
    
    //var _albumType: String?
    //var _albumName: String?
    //voteCount
    //suggestedBy
    //image
    //artist in spotify
    //song genres not available with current spotify data, availble with apple music

    var songName: String {
        if _songName == nil {
            return ""
        }
        return _songName
    }
    var source: String {
        return _source
    }
   
    init(snapshot: DataSnapshot){
        let dict = snapshot.value as! [String:Any]
        let songName = dict[songNameKey] as! String
        let source = dict[sourceKey] as! String
        /* let songGenre  = dict[songGenreKey] as? String */
        self._songName = songName
        self._source = source
    }
    
}

class AMPlaylistTrack : PlaylistTrack {
   
    // fileprivate var playbackID:
    fileprivate var _artistName: String!
    fileprivate var _songDuration: Double
    fileprivate var _image: UIImage!
    fileprivate var _songSourceID: Int!

    var artistName: String {
        return _artistName
    }
    var songDuration: Double {
        return _songDuration
    }
    
    var image: UIImage {
        return _image
    }
    
    var songSourceID: Int {
        return _songSourceID
    }
    

    override init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! [String:Any]
        let artistName = dict[artistNameKey] as! String
        let songDuration = dict[songDurationKey] as! Double
        let songSourceID = dict[songSourceIDKey] as! Int
        self._artistName = artistName
        self._songDuration = songDuration
        self._songSourceID = songSourceID
        
        /*only works if image is in user's library, need to use Apple Music API instead to get image URL
        let songName = dict[songNameKey] as! String
        let songNameFilter = MPMediaPropertyPredicate(value: songName, forProperty: MPMediaItemPropertyTitle, comparisonType: MPMediaPredicateComparison.equalTo)
        let filterSet: Set<MPMediaPropertyPredicate> = [songNameFilter]
        let myQuery = MPMediaQuery(filterPredicates: filterSet)
        let items = myQuery.items!
        let trackImage = items[0].artwork?.image(at: CGSize(width: 40, height: 40))
        self._image = trackImage
         */
        
        super.init(snapshot: snapshot)
    }
}

class SPPlaylistTrack : PlaylistTrack {
    
    // fileprivate var playbackID:
    fileprivate var _artistName: String!
    fileprivate var _imageURL: String!
    //fileprivate var _songDuration: Double
    fileprivate var _songSourceID: String!
    
    var artistName: String {
        return _artistName
    }
    
    var imageURL: String{
        return _imageURL 
    }
    
    var songSourceID: String {
        return _songSourceID
    }

    /*
    var songDuration: Double {
        return _songDuration
    }
 */
    
    override init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! [String:Any]
        
        let artists = dict[artistsKey] as! [[String:Any]]
        let artistCount = artists.count
        var artistName = ""
        for index in 0..<artistCount {
            guard let artistDict = artists[index] as? [String: Any] else {
                break
            }
            guard let appendArtist = artistDict[artistNameKey] as? String else {
                break
            }
            artistName += appendArtist
            if artistCount > 1 && index != artistCount-1 {
                artistName += ", "
            }
        }
        self._artistName = artistName

        let imageURL = dict[songSpotifyLinkKey] as? String
        self._imageURL = imageURL
        
        let songSourceID = dict[songSourceIDKey] as? String
        self._songSourceID = songSourceID
        
        //let songDuration = dict[songDurationKey] as! Double
        //self._songDuration = songDuration
        
        super.init(snapshot: snapshot)
    }
}

