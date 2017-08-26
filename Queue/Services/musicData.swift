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

class musicData {

    static let instance = musicData()
    
    /*
    func uploadMusicData(completion: @escaping ()-> ()){
        var hasAppleMusic: String = ""
        var hasSpotify: String = ""
        DataService.instance.readUserData(uid: AuthService.instance.current_uid, key: spotifyProviderKey, completion: { (response, error) in
            if error == false {
                hasSpotify = response as! String
            }
        })
        DataService.instance.readUserData(uid: AuthService.instance.current_uid, key: appleMusicProviderkey, completion: { (response, error) in
            if error == false {
                hasAppleMusic = response as! String
            }
        })
     
        if hasSpotify == "true" {
            uploadSpotifyData(completion: {
                completion()
            })
        }
        
        if hasAppleMusic == "true" {
            uploadAppleMusicData(completion: {
                completion()
            })
        }
    }
    */
    
    func uploadSpotifyData(completion: @escaping ()->()){
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
                // do some error handling
                print(error)
                return
            }
        }
        
        //do request for 50 songs for total songs/50 times
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
        while count < requestCount {
            let offset = 50*count
            let par1 = ["limit": 50, "offset": offset]
            Alamofire.request(spotifyUsersSavedTracksAPIURL, parameters: par1, headers: head).responseJSON { (response) in
                switch response.result {
                case .success:
                    let value = response.result.value as Any
                    let json = JSON(value).dictionaryObject
                    let items = json!["items"] as! [[String:Any]]
                    for item in items {
                        let songName = item["name"]
                        let songSource = "spotify"
                        let songId = item["id"]
                        //let songImage =
                        //let artists
                        //let album
                        let songPreviewURL = item["preview_url"]
                        let added_at = item["added_at"]
                        let duration_ms = item["duration_ms"]
                        let href = item["href"]
                        let explicit = item["explicit"]
                    //upload to database 
                    }
                case .failure(let error):
                    // do some error handling
                    print(error)
                    return
                }
            }
            count+=1
        }
        
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
                    return
                }
            }
        }
        
        completion()
    }
    
    func uploadAppleMusicData(completion: @escaping ()->()){
        print("upload Apple Music")
        let songQuery = MPMediaQuery.songs()
        let songs = songQuery.collections
        
        completion()
    }
    
}
