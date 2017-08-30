//
//  Defaults.swift
//  Queue
//
//  Created by Aditya Gunda on 8/18/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

let loadingTypeNo = 3
let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
let iconText_success = ["🙌","😀","☺️","🙃"].sm_random()


enum DataError: Error {
    case uploadingPlaylist
    case uploadingSong
    case other
}
