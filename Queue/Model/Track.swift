//
//  File.swift
//  Queue
//
//  Created by Aditya Gunda on 9/1/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import Foundation

class track  {
    private var _name: String!
    private var  _artistName: String!
    
    var name: String {
        return _name
    }
    
    var artistName: String {
        return _artistName
    }
    
    init(trackName: String, artistName: String) {
        self._name = trackName
        self._artistName = artistName
    }
}
