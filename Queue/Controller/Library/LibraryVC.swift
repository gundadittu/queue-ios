//
//  LibraryVC.swift
//  Queue
//
//  Created by Aditya Gunda on 8/31/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework

class LibraryVC: UIViewController {

    ///@IBOutlet weak var segmentedController: TwicketSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Library"
        self.view.backgroundColor = FlatWhite()
        /*
        let titles = ["Recent", "Playlists", "Songs", "Albums", "Artists"]
        segmentedController.setSegmentItems(titles)
        segmentedController.isUserInteractionEnabled = true
        segmentedController.isSliderShadowHidden = true
        segmentedController.defaultTextColor = FlatWhite() //unselected text
        segmentedController.highlightTextColor = FlatWhite() //selected text
        segmentedController.segmentsBackgroundColor = FlatWhiteDark() //unselected segments
        segmentedController.sliderBackgroundColor = FlatPurple() //selected segment
        segmentedController.backgroundColor = FlatWhite()
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
