//
//  musicData.swift
//  Queue
//
//  Created by Aditya Gunda on 8/25/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SpotifyMusicManager {
    
    static let instance = SpotifyMusicManager()
    
    //API LINK - find a way to remove hardcode from app
    let spotifyUsersSavedTracksAPIURL = "https://api.spotify.com/v1/me/tracks" 
    let spotifyUserPlaylistListAPIURL = "https://api.spotify.com/v1/me/playlists"
    let spotifyPlaylistTracksAPIURL = "https://api.spotify.com/v1/users/{user_id}/playlists/{playlist_id}/tracks"
    
    func uploadSpotifyData(completionHandlerMain: @escaping (Error?) -> Void ){
        ///all saved tracks
        let dispatchGroup = DispatchGroup()
        
        var totalSongs = 0
        var totalPlaylists = 0
        let header = ["Authorization": "Bearer \( SpotifyAuth.instance.sp_session.accessToken!)"]
        let parameters = ["limit": 1]
        
        dispatchGroup.enter()
        Alamofire.request(spotifyUserPlaylistListAPIURL, parameters: parameters, headers: header).responseJSON { (response) in
            dispatchGroup.leave()
            switch response.result {
            case .success(let value):
                let json = JSON(value).dictionaryObject!
                totalPlaylists = json["total"] as! Int
            case .failure(let error):
                completionHandlerMain(error)
                return
            }
        }
        
        dispatchGroup.wait()
        dispatchGroup.enter()
        Alamofire.request(spotifyUsersSavedTracksAPIURL, parameters: parameters, headers: header).responseJSON { (response) in
            dispatchGroup.leave()
            switch response.result {
            case .success(let value):
                let json = JSON(value).dictionaryObject!
                totalSongs = json["total"] as! Int
            case .failure(let error):
                completionHandlerMain(error)
                return
            }
        }
        
        dispatchGroup.wait()
        dispatchGroup.enter()
        self.uploadSpotifyUserAllSavedTracks (totalSongs){ (error) in
            dispatchGroup.leave()
            if error != nil {
                completionHandlerMain(error)
                return
            }
        }
        
        dispatchGroup.wait()
        dispatchGroup.enter()
        //all playlists
        self.uploadSpotifyUserPlaylists(totalPlaylists, completionHandler: { (error) in
            dispatchGroup.leave()
            if error != nil{
                completionHandlerMain(error)
                return
            }
        })
        
        dispatchGroup.notify(queue: .main) {
            completionHandlerMain(nil)
        }
    }
    
    func uploadSpotifyUserPlaylists(_ playlistCount: Int, completionHandler: @escaping (Error?) -> Void) {
        var totalCount = playlistCount //fix - get correct total
        
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
        
        let header = ["Authorization": "Bearer \( SpotifyAuth.instance.sp_session.accessToken!)"]
        while count < requestCount {
            dispatchGroup.wait()
            dispatchGroup.enter()
            let parameters1 = ["limit": 50 , "offset": 50*count]
            self.uploadSpotifyPlaylists(parameters1, header, completion: { (error) in //replace
                dispatchGroup.leave()
                if error != nil {
                    completionHandler(error)
                    return
                }
            })
            count+=1
        }
        
        dispatchGroup.wait()
        if remainder > 0 {
            dispatchGroup.enter()
            let header2 = ["Authorization": "Bearer \( SpotifyAuth.instance.sp_session.accessToken!)"]
            let parameters2 = ["limit": remainder, "offset": 50*requestCount]
            
            self.uploadSpotifyPlaylists(parameters2, header2, completion: { (error) in //replace
                dispatchGroup.leave()
                if error != nil {
                    completionHandler(error)
                    return
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(nil)
        }
    }
    
    func uploadSpotifyPlaylists(_ parameters: [String:Int],_ header: [String: String], completion: @escaping (Error?) -> Void) {
       // let dispatchGroup = DispatchGroup()
        Alamofire.request(spotifyUserPlaylistListAPIURL, parameters: parameters, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                let value = response.result.value
                let json = JSON(value).dictionaryObject!
                if let items = json["items"] as? [[String:Any]]{
                    for item in items {
                        //dispatchGroup.wait()
                       // dispatchGroup.enter()
                        var playlistData = [String:Any]()
                        
                        //for spotify - description text, author display name
                        
                        if let name = item["name"] as? String{
                             playlistData[playlistNameKey] = name
                        }
                        
                        if let publicStatus = item["public"] as? Bool{
                            playlistData[publicStatusKey] = publicStatus
                        }
                        
                        playlistData[sourceKey] = "spotify"
                        
                        if let playlistID = item["id"] as? String {
                            playlistData[playlistSourceIDKey] = playlistID
                        } else {
                            completion(NSError()) ///real error handling
                            return
                        }
                        
                        if let images = item["images"] as? [[String:Any]] {
                            if images.count > 0{
                                if let image = images[0] as? [String:Any]{
                                    if let imageURL = image["url"] as? String{ //right key
                                        playlistData[imageURLKey] = imageURL
                                    }
                                }
                            }
                        }
                        
                        if let owner = item["owner"] as? [String:Any] {
                            if let ownerID = owner["id"] as? String {
                                playlistData[spotifyOwnerIDKey] = ownerID
                            }
                        }
                        
                        if let collaborativeStatus = item["collaborative"] as? Bool {
                            playlistData[collaborativeStatusKey] = collaborativeStatus
                        }
                        
                        if let playlistURL = item["external_urls"] as? [String:Any] {
                            if let spotifyURL = playlistURL["spotify"] as? String {
                                playlistData[playlistSpotifyLinkKey] = spotifyURL
                            }
                        }
                        
                        if let playlistAPIURL = item["href"] as? String {
                            playlistData[spotifyHrefKey] = playlistAPIURL
                        }
                        
                        if let  tracks = item["tracks"] as? [String:Any]{
                            if let trackCount = tracks["total"] as? Int{
                                playlistData[playlistCountKey] = trackCount
                            if let trackAPIURL = tracks["href"] as? String{
                            
                             self.parseSpotifyPlaylistTracks(trackCount,trackAPIURL, completion: { (trackData, error) in
                                    if error != nil {
                                        completion(NSError()) // do real error handling
                                        return
                                    }
                                if trackData == nil {
                                    print("track data is nil")
                                } else {
                                    playlistData["track_list"] = trackData!
                                }
                                
                                    let userID = AuthService.instance.current_uid
                                    DataService.instance.createExternalSPPlaylist(userID, playlistData, completionHandler: { (key) in
                                        if key == nil{
                                            completion(NSError()) // do real error handling
                                            return
                                        }
                                    })
                                })
                            }
                          }
                        }
                    } //end for loop
                }
                completion(nil)
                return
            case .failure(let error):
                completion(error)
                return
            }
        }/// end first Alamofire request
    }
    
    func parseSpotifyPlaylistTracks(_ totalTracks: Int,_ apiURL: String, completion: @escaping ([[String:Any]]?, Error?)->Void){
        var songArray = [[String:Any]]()
        var remainder = 0
        var requestCount = 0
        var count = 0

        if totalTracks < 100 {
            remainder = totalTracks
        } else {
            requestCount = totalTracks/100
            remainder = totalTracks%100
        }
        while count < requestCount {
            let header = ["Authorization": "Bearer \( SpotifyAuth.instance.sp_session.accessToken!)"]
            let parameters = ["limit": 100, "offset": 50*count]
            Alamofire.request(apiURL, parameters: parameters, headers: header).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value).dictionaryObject!
                    if let items = json["items"] as? [[String:Any]]{
                        for item in items{
                            let song = self.parseSingleSpotifyTrack(item)!
                            songArray.append(song)
                        }
                    }
                case .failure(let error):
                    completion(nil,error)
                    return
                }
            })
            count+=1
        }
        
        if remainder > 0 {
            let header = ["Authorization": "Bearer \( SpotifyAuth.instance.sp_session.accessToken!)"]
            let parameters = ["limit": remainder, "offset": 50*requestCount]
            Alamofire.request(apiURL, parameters: parameters, headers: header).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value).dictionaryObject!
                    if let items = json["items"] as? [[String:Any]]{
                        for item in items{
                            let song = self.parseSingleSpotifyTrack(item)!
                            songArray.append(song)
                        }
                    }
                    completion(songArray, nil)
                case .failure(let error):
                    completion(nil,error)
                    return
                }
            })
        }
    }
    
    
    
    func uploadSpotifyUserAllSavedTracks(_ songsCount: Int, completionHandler: @escaping (Error?) -> Void ){
    
        var totalCount = songsCount //fix - get correct total 
    
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
        
        let header = ["Authorization": "Bearer \( SpotifyAuth.instance.sp_session.accessToken!)"]
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
            let header2 = ["Authorization": "Bearer \( SpotifyAuth.instance.sp_session.accessToken!)"]
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
    
    
    func requestSpotifyUserSavedTracks(_ param: [String:Any], _ header: [String:String], completion: @escaping ( Error?) -> Void ){
        Alamofire.request(self.spotifyUsersSavedTracksAPIURL, parameters: param, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                let value = response.result.value as Any
                let json = JSON(value).dictionaryObject
                
                if let items = json!["items"] as? [[String:Any]]{
                
                //iterate over each song in results data
                for item in items {
                    if let uploadSong = self.parseSingleSpotifyTrack(item) as? [String:Any] {
                        //uploadSong[songOwnerUserIDKey] = AuthService.instance.current_uid
                        let userID = AuthService.instance.current_uid
                        //push data to database
                        DataService.instance.createExternalSPSong(user_id: userID, songData: uploadSong, completionHandler: { key in
                            if key == nil{
                                completion(NSError()) //put real error
                            }
                        })
                    }
                }// end for loop
            }
            case .failure(let error):
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func parseSingleSpotifyTrack(_ item: [String:Any]) -> [String:Any]?{
        var uploadSong = [String:Any]()
        if let track = item["track"] as? [String:Any]{
            //image data
            if let album = track["album"] as? [String:AnyObject]{
                if let images = album["images"] as? [[String:AnyObject]] {
                    if images.count > 0{
                        if let image = images[0] as? [String:AnyObject]{
                            let imageURL = image["url"] as? String
                            uploadSong[imageURLKey] = imageURL
                        }
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
                    if let artistName = artist["name"] as? String{
                        if let artistSpotifyID = artist["id"] as? String{
                            artistsArr.append([artistNameKey : artistName, artistSpotifyIDKey : artistSpotifyID])
                        }
                        
                    }
                }
                uploadSong[artistsKey] = artistsArr
            }
            
            //album data
            if let album = track["album"] as? [String:AnyObject] {
                if let albumType = album["type"] as? String {
                    uploadSong[albumTypeKey] = albumType
                }
                if let albumName = album["name"] as? String {
                    uploadSong[albumNameKey] = albumName
                }
                if let albumhref = album["href"] as? String{
                    uploadSong[albumLinkKey] = albumhref
                }
                if let albumID = album["id"] as? String {
                    uploadSong[albumSpotifyIDKey] = albumID
                }
            }
            
            //all song data
            if let songName = track["name"] as? String {
                uploadSong[songNameKey] = songName
            }
            
            let songSource = "spotify"
            uploadSong[songSourceKey] = songSource
            
            
            if let songId = track["id"] as? String {
                uploadSong[songSourceIDKey] = songId
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
            return uploadSong
        }
        return nil
    }
}

