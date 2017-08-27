//
//  musicData.swift
//  Queue
//
//  Created by Aditya Gunda on 8/25/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation
import Alamofire
import MediaPlayer
import SwiftyJSON

class SpotifyMusicManager {
    
    static let instance = SpotifyMusicManager()
    
    //API LINK - find a way to remove hardcode from app
    let spotifyUsersSavedTracksAPIURL = "https://api.spotify.com/v1/me/tracks" 
    let spotifyUserPlaylistListAPIURL = "https://api.spotify.com/v1/me/playlists"
    let spotifyPlaylistTracksAPIURL = "https://api.spotify.com/v1/users/{user_id}/playlists/{playlist_id}/tracks"
    
    func uploadSpotifyData(completionHandler: @escaping (Error?) -> Void ){
        ///all saved tracks
        self.uploadSpotifyUserAllSavedTracks { (error) in
            if error != nil {
                completionHandler(error)
                return
            }
        }
        
        //all playlists
        self.uploadSpotifyUserPlaylists(completionHandler: { (error) in
            if error != nil{
                completionHandler(error)
                return
            }
        })
        completionHandler(nil)
    }
    
    func uploadSpotifyUserPlaylists(completionHandler: @escaping (Error?) -> Void) {
        var totalCount = 28 //fix - get correct total
        
        let dispatchGroup = DispatchGroup()
        
        var requestCount = 0
        var remainder = 0
        var count = 0
        
        if totalCount < 50 {
            requestCount = 0
            remainder = totalCount
        } else {
            requestCount = totalCount/50
            remainder = totalCount%50
        }
        
        let header = ["Authorization": "Bearer \(sp_session.accessToken!)"]
        while count < requestCount {
            dispatchGroup.enter()
            let parameters1 = ["limit": 50 , "offset": 50*count]
            self.uploadSpotifyPlaylists(parameters1, header, completion: { (error) in //replace
                if error != nil {
                    completionHandler(error)
                    return
                }
                dispatchGroup.leave()
            })
            count+=1
        }

        if remainder > 0 {
            dispatchGroup.wait()
            dispatchGroup.enter()
            let header2 = ["Authorization": "Bearer \(sp_session.accessToken!)"]
            let parameters2 = ["limit": remainder, "offset": 50*requestCount]
            
            self.uploadSpotifyPlaylists(parameters2, header2, completion: { (error) in //replace
                if error != nil {
                    completionHandler(error)
                    return
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(nil)
        }
    }
    
    func uploadSpotifyPlaylists(_ parameters: [String:Int],_ header: [String: String], completion: @escaping (Error?) -> Void) {
        Alamofire.request(spotifyUserPlaylistListAPIURL, parameters: parameters, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                let value = response.result.value
                let json = JSON(value).dictionaryObject!
                if let items = json["items"] as? [[String:Any]]{
                    for item in items{
                        var playlistData = [String:Any]()
                        
                        if let name = item["name"] as? String{
                             playlistData["name"] = name
                        }
                        
                        if let publicStatus = item["public"] as? Bool{
                            playlistData["public_status"] = publicStatus
                        }
                        playlistData["playlist_source"] = "spotify"
                        
                        if let playlistID = item["id"] as? String {
                            playlistData["playlist_spotify_id"] = playlistID
                        }
                        /*
                        if let images = item["images"] as? [[String:Any]] {
                            if let image = images[0] as? [String:Any]{
                                if let imageURL = image[""] as? String{ //right key
                                    playlistData["imageURL"] = imageURL
                                }
                            }
                        }
                        */
                        if let owner = item["owner"] as? [String:Any] {
                            if let ownerID = owner["id"] as? String {
                                playlistData["spotify_owner_id"] = ownerID
                            }
                        }
                        
                        if let collaborativeStatus = item["collaborative"] as? Bool {
                            playlistData["collaborative_status"] = collaborativeStatus
                        }
                        
                        if let playlistURL = item["external_urls"] as? [String:Any] {
                            if let spotifyURL = playlistURL["spotify"] as? String {
                                playlistData["spotify_url"] = spotifyURL
                            }
                        }
                        
                        if let playlistAPIURL = item["href"] as? String {
                            playlistData["spotify_api_url"] = playlistAPIURL
                        }
                        
                        if let tracks = item["tracks"] as? [String:Any] {
                            if let tracksTotal = tracks["total"] as? Int{
                                playlistData["total_tracks"] = tracksTotal
                            }
                            if let tracksAPIURL = tracks["href"] as? String {
                                playlistData["tracks_api_url"] = tracksAPIURL
                                Alamofire.request(tracksAPIURL, headers: header).responseJSON { (response) in
                                    switch response.result {
                                    case .success(let value):
                                        let json = JSON(value).dictionaryObject!
                                        if let trackItems = json["items"] as? [[String:Any]]
                                        {
                                            playlistData["tracks"] = trackItems //parse better
                                            //print(trackItems)
                                            //upload playlistData to database
                                            DataService.instance.createExternalSpotifyPlaylist(AuthService.instance.current_uid, playlistData)
                                        }
                                    case .failure(let error):
                                        completion(error)
                                        return
                                    }
                                }// end Alamofire request
                            }
                        }
                    } //end for loop
                }// end if statement
               
            case .failure(let error):
                completion(error)
                return
            }
        }/// end first Alamofire request
    }
    
    func uploadSpotifyUserAllSavedTracks(completionHandler: @escaping (Error?) -> Void ){
    
        var totalCount = 145 //fix - get correct total 
    
        var requestCount = 0
        var remainder = 0
        var count = 0

        if totalCount < 50 {
            requestCount = 0
            remainder = totalCount
        } else {
            requestCount = totalCount/50
            remainder = totalCount%50
        }
        
        let header = ["Authorization": "Bearer \(sp_session.accessToken!)"]
        while count < requestCount {
                let parameters1 = ["limit": 50 , "offset": 50*count]
                self.requestSpotifyUserSavedTracks(parameters1, header, completion: { (error) in
                    if error != nil {
                        completionHandler(error)
                        return
                    }
                })
            count+=1
        }
        
        if remainder > 0 {
            let header2 = ["Authorization": "Bearer \(sp_session.accessToken!)"]
            let parameters2 = ["limit": remainder, "offset": 50*requestCount]
          
            self.requestSpotifyUserSavedTracks(parameters2, header2, completion: { (error) in
                if error != nil {
                    completionHandler(error)
                    return
                }
                completionHandler(nil)
            })
        } else {
            completionHandler(nil)
        }
    }
    
    func requestSpotifyUserPlaylist(){
        return
    }
    
    func requestSpotifyUserSavedTracks(_ param: [String:Any], _ header: [String:String], completion: @escaping ( Error?) -> Void ){
        Alamofire.request(self.spotifyUsersSavedTracksAPIURL, parameters: param, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                let value = response.result.value as Any
                let json = JSON(value).dictionaryObject
                
                if let items = json!["items"] as? [[String:Any]]{
                
                //iterate over each song in results data
                for item in items {

                   if let track = item["track"] as? [String:Any]{
                    
                    var uploadSong = [String: Any]()
                    
                    //image data
                    if let album = track["album"] as? [String:AnyObject]{
                        if let images = album["images"] as? [[String:AnyObject]] {
                            if let image = images[1] as? [String:AnyObject]{
                                let imageURL = image["url"] as? String
                                uploadSong[imageURLKey] = imageURL
                            }
                        }
                    }
                    
                    //isrc number
                    if let externalID = track["external_ids"] as? [String:String]{
                        if let isrcCode = externalID["isrc"] as? String {
                            uploadSong[isrcCodeKey] = isrcCode
                        }
                    }
                    
                    //artist data
                    if let artists = track["artists"] as? [[String:AnyObject]] {
                        var artistsArr = [[String:Any]]()
                        for artist in artists {
                            let artistName = artist["name"] as! String
                            let artistSpotifyID = artist["id"] as! String
                            artistsArr.append([artistNameKey : artistName, artistSpotifyIDKey : artistSpotifyID])
                        }
                        uploadSong[artistsKey] = artistsArr
                    }
                    
                    //album data
                    if let album = track["album"] as? [String:AnyObject] {
                        let albumType = album["type"] as! String
                        let albumName = album["name"] as! String
                        let albumhref = album["href"] as! String
                        let albumID = album["id"] as! String
                        uploadSong[albumTypeKey] = albumType
                        uploadSong[albumNameKey] = albumName
                        uploadSong[albumLinkKey] = albumhref
                        uploadSong[albumSpotifyIDKey] = albumID
                    }
                    
                    //all song data
                    if let songName = track["name"] as? String {
                        uploadSong[songNameKey] = songName
                    }
                    
                    let songSource = "spotify"
                    uploadSong[songSourceKey] = songSource
                    
                    
                    if let songId = track["id"] as? String {
                        uploadSong[songSpotifyIDKey] = songId
                    }
                    
                    if let songPreviewURL = track["preview_url"] as? String {
                        uploadSong[songSpotifyPreviewURLKey] = songPreviewURL
                    }
                    
                    if let addedAt = item["added_at"] as? String {
                        uploadSong[addedTimestampKey] = addedAt
                    }
                    
                    if let durationMs = track["duration_ms"] as? String {
                        uploadSong[songDurationKey] = durationMs
                    }
                    
                    if let href = track["href"] as? String {
                        uploadSong[songSpotifyLinkKey] = href
                    }
                    
                    if let explicit = track["explicit"] as? Bool {
                        uploadSong[songExplicitBoolKey] = explicit
                    }
                    
                    let userID = AuthService.instance.current_uid
                    uploadSong[songOwnerUserIDKey] = userID
        
                    //push data to database
                    let _ = DataService.instance.createExternalSpotifySong(user_id: userID, songData: uploadSong)
                    }// end for loop
                }
            }
            case .failure(let error):
                completion(error)
                return
            }
        }
        completion(nil)
    }
}

