//
//  SpotifyAuth.swift
//  Queue
//
//  Created by Aditya Gunda on 8/24/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation

var sp_auth = SPTAuth.defaultInstance()!
var sp_session:SPTSession!

let SPredirect_URL = "Queue://returnAfterLogin"

let SPclient_ID = "72d8cf3b5c014ce694675d2c931e339e"

let SPrequested_scopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserLibraryReadScope, SPTAuthUserLibraryModifyScope, SPTAuthUserReadPrivateScope]

let SPtokenSwap_URL = "https://gentle-woodland-29346.herokuapp.com/swap"
let SPtokenRefresh_URL = "https://gentle-woodland-29346.herokuapp.com/refresh"

let SPSession_UserDefaults_Key = "SpotifySession"


func refreshSpotifyToken()
{
    //print("refresh token: \(self.session.encryptedRefreshToken)")
    SPTAuth.defaultInstance().renewSession(sp_session, callback: { (error, session) in
        if error != nil {
            //error renewing spotify session 
            refreshSpotifyToken()
            return
        }
        //write new access token to database
        DataService.instance.writeUserData(uid: AuthService.instance.current_uid, key: spotifyAccessTokenKey, data: sp_session.accessToken)
    })
}
