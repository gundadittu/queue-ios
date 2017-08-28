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
    
    func uploadAMData(completionHandler: @escaping (Error?)->Void){
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        self.uploadAMUserAllSavedTracks{ (error) in
            dispatchGroup.leave()
            if error != nil {
                completionHandler(error) //real error
                return
            }
        }
        
        dispatchGroup.wait()
        dispatchGroup.enter()
        self.uploadAMUserPlaylists { (error) in
            dispatchGroup.leave()
            if error != nil {
                completionHandler(error) // real error
                return
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(nil)
        }
    }
    
    func uploadAMUserAllSavedTracks(completion: @escaping (Error?)->Void){
        let dispatchGroup = DispatchGroup()
        let songQuery = MPMediaQuery.songs()
        let songs = songQuery.items!
        for song in songs {
            dispatchGroup.wait()
            dispatchGroup.enter()
            var songUpload = [String:Any]()
            if song.mediaType.rawValue == 1 {
                if let title = song.title as? String{
                    songUpload[songNameKey] = title
                }
                if let songID = song.persistentID as? UInt64{
                    songUpload[songSourceIDKey] = songID
                }
               // song.playbackStoreID
                /*
                songUpload[songGenreKey] = song.genre
                songUpload[artistNameKey] = song.artist
                songUpload[albumNameKey] = song.albumTitle
                songUpload[albumAMIDKey] = song.albumPersistentID
                //songUpload[imageURLKey] = song.artwork
                songUpload[artistAMIDKey] = song.artistPersistentID
                songUpload[imageURLKey] = song.artwork
                songUpload[songDurationKey] = song.playbackDuration
                songUpload[addedTimestampKey] = song.dateAdded
                songUpload[songSourceKey] = "apple_music"
                let ownerID = AuthService.instance.current_uid
                songUpload[songOwnerUserIDKey] = ownerID
                ///rating, release date, skip count????
                //for spotify - genre, release date, rating
 */
                let ownerID = AuthService.instance.current_uid

                DataService.instance.createExternalAMSong(user_id: ownerID, songData: songUpload, completionHandler: { (key) in
                    dispatchGroup.leave()
                    if key == nil {
                        completion(NSError()) //real error
                        return
                    }
                })
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(nil)
        }
    }
    
    func uploadAMUserPlaylists(completion: @escaping (Error?)->Void){
        let dispatchGroup = DispatchGroup()
        let myPlaylistQuery = MPMediaQuery.playlists()
        let playlists = myPlaylistQuery.collections
        for playlist in playlists! {
            dispatchGroup.wait()
            dispatchGroup.enter()
            var playlistData = [String:Any]()
            
            if let title = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String {
                playlistData[playlistNameKey] = title 
            }
            if let playID = playlist.persistentID as? UInt64 {
                playlistData[playlistSourceIDKey] = playID
            }
            playlistData[sourceKey] = "apple_music"
            //playlistData[imageURLKey] =
            //playlistData[] = am owner ID
             //playlistData[playlistCountKey] = playlist.count
            
            //playlistData["description"] = playlist.description
            //playlistData["author"] = playlist.authorDisplayName
            ///playlistData["timestamp"] = timestamp
            let ownerID = AuthService.instance.current_uid
            let songs = playlist.items
            var songArray = [[String:Any]]()
            for song in songs {
                var songUpload = [String:Any]()
                if let title = song.title as? String{
                    songUpload[songNameKey] = title
                }
                if let songID = song.persistentID as? UInt64{
                    songUpload[songSourceIDKey] =  songID
                }
                //songUpload["am_playback_id"] song.playbackStoreID
                //songUpload[songGenreKey] = song.genre
               // songUpload[artistNameKey] = song.artist
                //songUpload[albumNameKey] = song.albumTitle
                ///songUpload[albumAMIDKey] = song.albumPersistentID
                //songUpload[imageURLKey] = song.artwork
                //songUpload[artistAMIDKey] = song.artistPersistentID
               // songUpload[imageURLKey] = song.artwork
                //songUpload[songDurationKey] = song.playbackDuration
                //songUpload[addedTimestampKey] = song.dateAdded
                songUpload[songSourceKey] = "apple_music"
                songArray.append(songUpload)
            }
             playlistData[playlistTracksKey] = songArray
            //upload to database
            DataService.instance.createExternalAMPlaylist(ownerID, playlistData, completionHandler: {(key) in
                dispatchGroup.leave()
                if key == nil{
                    completion(NSError()) //real error 
                    return
                }
            })
        }//end of playlist for loop
        
        dispatchGroup.notify(queue: .main) {
            completion(nil)
        }
    }
}

