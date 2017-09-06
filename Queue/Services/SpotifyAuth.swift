//
//  SpotifyAuth.swift
//  Queue
//
//  Created by Aditya Gunda on 8/24/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SpotifyAuth {
    static let instance = SpotifyAuth()
    var sp_auth = SPTAuth.defaultInstance()!
    var sp_session:SPTSession!
    var auth = SPTAuth()

    //Spotify Developer Info - find a way to remove hardcode from app
    let SPredirect_URL = "Queue://returnAfterLogin"
    let SPclient_ID = "72d8cf3b5c014ce694675d2c931e339e"
    let SPtokenSwap_URL = "https://gentle-woodland-29346.herokuapp.com/swap"
    let SPtokenRefresh_URL = "https://gentle-woodland-29346.herokuapp.com/refresh"
    let SPrequested_scopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserLibraryReadScope, SPTAuthUserLibraryModifyScope, SPTAuthUserReadPrivateScope]
    let SPSession_UserDefaults_Key = "SpotifySession"
    
    let spotifyUserProfileAPIURL = "https://api.spotify.com/v1/me"
    
    func updatePremiumStatus(){
      let header = ["Authorization": "Bearer \( SpotifyAuth.instance.sp_session.accessToken!)"]
        Alamofire.request(spotifyUserProfileAPIURL, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).dictionaryObject!
                guard let product = json["product"] as? String else {
                    return
                }
                if product == "premium" {
                     DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyPremiumProviderKey, data: "true")
                } else {
                    DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyPremiumProviderKey, data: "false")
                }
            case .failure(let error):
                print("error updating user's Spotify Premium status: \(error.localizedDescription)")
                DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyPremiumProviderKey, data: "false")
            }
        }
    }
    
    func refreshSpotifyToken()
    {
        //print("refresh token: \(self.session.encryptedRefreshToken)")
        SPTAuth.defaultInstance().renewSession(sp_session, callback: { (error, session) in
            if error != nil {
                //error renewing spotify session
                self.refreshSpotifyToken()
                return
            }
            //write new access token to database
            DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyAccessTokenKey, data: self.sp_session.accessToken)
        })
    }
    
}
