//
//  Enums.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation


enum playlistType: String {
    case spotify = "spotify"
    case appleMusic = "apple_music"
    case live = "live"
    case group = "group"
}

enum accessType {
    case publicAccess
    case privateAccess
}

enum playlistMood: String {
    case party = "Party"
    case focus = "Focus"
    case chill = "Chill"
    case shower = "Shower"
    case sleep = "Sleep"
    case gaming = "Gaming"
    case travel = "Travel"
    case dinner = "Dinner"
    case sad = "Sad"
    case workout = "Workout"
    case romance = "Romance"
    case family = "Family"
    //case motivation
    //case weekend
}

 enum trackGenre: String {
 case hiphop = "HipHop"
 case alternative = "Alternative"
 case classical = "Classical"
 case electronic = "Electronic"
 case indie = "Indie"
 case metal = "Metal"
 case rb = "R&B"
 //oldies
 //rock y alternativeo
 //stage and screen
 case blues = "Blues"
 case country = "Country"
 case hardRock = "Hard Rock"
 case jazz = "Jazz"
 ///músic mexicana
 case pop = "Pop"
 case reggae = "Reggae"
 //singer/songwriter
 //urbano latino
 case christianGospel = "Christian Gospel"
 case dance = "Dance"
 case kpop = "K-Pop"
 //musica tropical
 ///pop latino
 case rock = "Rock"
 case soulFunk = "Soul/Funk"
 //folk and americana
 //decades
 ///electronic/dance

}
