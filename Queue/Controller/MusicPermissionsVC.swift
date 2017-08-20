//
//  MusicPermissionsVC.swift
//  Queue
//
//  Created by Aditya Gunda on 8/17/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit

class MusicPermissionsVC: UIViewController {
    
    @IBAction func spotifyBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func applemusicBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "musicpermtoperm", sender: nil)
    }

}
