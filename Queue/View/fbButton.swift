//
//  highlightedButton.swift
//  Queue
//
//  Created by Aditya Gunda on 8/17/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit

class fbButton: UIButton {

    override func awakeFromNib() {
        self.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        self.layer.cornerRadius = 15 
    }

}
