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
    
    func uploadSpotifyData(completionHandler: @escaping (Error?) -> Void ){ 
        let header = ["Authorization": "Bearer \(sp_session.accessToken!)"]
        let parameters = ["limit": 50, "offset": 0]
        self.requestSpotifyUserSavedTracks(parameters, header, completion: { (error) in
            if error == nil {
                completionHandler(nil)
            } else {
                completionHandler(error)
            }
        })
    }
    
/*
        var total = 0
        let head = ["Authorization": "Bearer \(sp_session.accessToken!)"]
        let par = ["limit": 1, "offset": 0]
        Alamofire.request(spotifyUsersSavedTracksAPIURL, parameters: par, headers: head).responseJSON { (response) in
            switch response.result {
            case .success:
                let value = response.result.value as Any
                let json = JSON(value).dictionaryObject
                total = json!["total"] as! Int
            case .failure(let error):
                completion(error)
                return
            }
        }
        
        //do request for 50 songs (total/50) times
        var requestCount = 0
        var remainder = 0
        if total < 50  {
            requestCount = 0
            remainder = total
        } else {
            requestCount = total/50
            remainder = total%50
        }
        
        var count = 0
 
        let offset = 50*count
        let par1 = ["limit": 50, "offset": offset]
        requestSpotifyUserSavedTracks(par1, head, completion: { error in
            if error != nil {
                print(error)
                completion(error)
                return
            } else {
                count+=1
            }
        })
        
        //do request for remainder of total/50 songs
        if remainder > 0 {
            let offset = 50*requestCount
            let par1 = ["limit": remainder, "offset": offset]
            Alamofire.request(spotifyUsersSavedTracksAPIURL, parameters: par1, headers: head).responseJSON { (response) in
                switch response.result {
                case .success:
                    let value = response.result.value as Any
                    let json = JSON(value).dictionaryObject
                case .failure(let error):
                    // do some error handling
                    print(error)
                }
            }
        }
        completion()
 
    }
 */
    
    func requestSpotifyUserSavedTracks(_ par1: [String:Any], _ head: [String:String], completion: @escaping (Error?) -> Void ){
        Alamofire.request(self.spotifyUsersSavedTracksAPIURL, parameters: par1, headers: head).responseJSON { (response) in
            switch response.result {
            case .success:
                let value = response.result.value as Any
                let json = JSON(value).dictionaryObject
                let items = json!["items"] as! [[String:Any]]
                
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
                    let _ = DataService.instance.createExternalSong(user_id: userID, songData: uploadSong)
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

