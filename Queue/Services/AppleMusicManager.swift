//
//  AppleMusicManager.swift
//  Queue
//
//  Created by Aditya Gunda on 8/27/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation
import Alamofire
import MediaPlayer
import SwiftyJSON

class AppleMusicManager {
    
    static let instance = AppleMusicManager()

    func uploadAMData(completionHandler: @escaping (Error?)->Void)  {
        let dispatchGroup = DispatchGroup()
        let userid = AuthService.instance.current_uid
        var errorThrown: Bool = false
        
        dispatchGroup.enter()
        self.parseAMUserAllSavedTracks{ list in
            dispatchGroup.leave()
            ///write to database
            for item in list {
                do {
                    try DataService.instance.createExternalAMSong(userid, item)
                } catch {
                    errorThrown = true
                    completionHandler(DataError.uploadingSong)
                    return
                }
            }
        }
        
        dispatchGroup.wait()
        if errorThrown == false {
            dispatchGroup.enter()
            self.parseAMUserPlaylists  { list in
                dispatchGroup.leave()
                //write to database
                for item in list {
                    do {
                        try DataService.instance.createExternalAMPlaylist(userid, item)
                    } catch {
                        errorThrown = true
                        completionHandler(DataError.uploadingPlaylist)
                        return
                    }
                }
            }
//        }
        dispatchGroup.notify(queue: .main, execute: {
            if errorThrown == false {
                completionHandler(nil)
            }
        })
    }
    }
    
    func parseAMUserAllSavedTracks(completion: @escaping ([[String:Any]]) -> Void)  -> Void {
        var songList = [[String:Any]]()
        let songQuery = MPMediaQuery.songs()
        let songs = songQuery.items!
        for song in songs {
            if song.mediaType.rawValue == 1 {
                //if let timestamp = song.value(forKey: MPMediaItemPropertyDateAdded) as? String {
                //    songUpload[addedTimestampKey] = timestamp
                //}
                //songUpload[imageURLKey] = String(describing: song.artwork)
                //let ownerID = AuthService.instance.current_uid
                
                let songUpload = parseAMsong(song)
                songList.append(songUpload)
            }
        }
        completion(songList)
    }
    
    func parseAMUserPlaylists(completion: @escaping ([[String:Any]])  -> Void) -> Void{
        var playlistList = [[String:Any]]()
        let myPlaylistQuery = MPMediaQuery.playlists()
        let playlists = myPlaylistQuery.collections
        for playlist in playlists! {
            var playlistData = [String:Any]()
            let id = playlist.value(forProperty: MPMediaPlaylistPropertyPersistentID) as! UInt64
            playlistData[playlistSourceIDKey] = id
            let name = playlist.value(forProperty: MPMediaPlaylistPropertyName)
            playlistData[playlistNameKey] = name!
            playlistData[sourceKey] = "apple_music"
            let songs = playlist.items
            playlistData["track_count"] = songs.count
            //image
            //let author = playlist.value(forProperty: MPMediaPlaylistPropertyAuthorDisplayName) as! String
            //playlistData["owner_display_name"] = author
            //playlistData["description"] = String(describing: playlist.value(forProperty: MPMediaPlaylistPropertyDescriptionText)!)
            
            var songList = [[String:Any]]()
            for song in songs{
                if song.mediaType.rawValue == 1 {
                    let songUpload = parseAMsong(song)
                    songList.append(songUpload)
                }
            }
            playlistData["track_list"] = songList
            playlistList.append(playlistData)
        }
        completion(playlistList)
    }
    
    func parseAMsong(_ song: MPMediaItem) -> [String:Any] {
        var songUpload = [String:Any]()
        
        let title = song.value(forProperty: MPMediaItemPropertyTitle) as! String
        songUpload[songNameKey] = title
    
        let playID = song.value(forKey: MPMediaItemPropertyPlaybackStoreID) as! String
        songUpload["playback_id"] = playID
        
        let id = song.value(forProperty: MPMediaItemPropertyPersistentID) as! Int
        songUpload[songSourceIDKey] = id 
       
        if let genre  = song.value(forKey: MPMediaItemPropertyGenre) as? String {
             songUpload[songGenreKey] = genre
        }
         if let artist = song.value(forKey: MPMediaItemPropertyArtist) as? String  {
            songUpload[artistNameKey] = artist
         }
         if let albumName = song.value(forKey: MPMediaItemPropertyAlbumTitle) as? String {
            songUpload[albumNameKey] = albumName
         }
         let duration = song.value(forKey: MPMediaItemPropertyPlaybackDuration) as! Double
         songUpload[songDurationKey] = duration
        songUpload[songSourceKey] = "apple_music"
        
        //let artistID = song.value(forKey: MPMediaItemPropertyArtistPersistentID) as! NSNumber
        //songUpload[artistAMIDKey] = artistID
        
        //let albumID = song.value(forKey: MPMediaItemPropertyAlbumPersistentID) as! Int
        //    songUpload[albumAMIDKey] = albumID
        
        //songUpload[imageURLKey] = String(describing: song.artwork)
        ///rating, release date, skip count???? image??
        
        return songUpload
    }
}

