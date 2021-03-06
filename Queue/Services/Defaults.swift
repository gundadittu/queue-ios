//
//  Defaults.swift
//  Queue
//
//  Created by Aditya Gunda on 8/18/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import ChameleonFramework

let loadingTypeNo = 3
let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
let iconText_success = ["🙌","😀","☺️","🙃"].sm_random()
let iconText_sad = ["😢", "😳", "🙄", "😕", "😒", "😔"].sm_random()!


enum DataError: Error {
    case uploadingPlaylist
    case uploadingSong
    case other
}

let backgroundGradientColors = [FlatPurpleDark(), FlatMagentaDark(), FlatMagenta(), FlatPink()]
