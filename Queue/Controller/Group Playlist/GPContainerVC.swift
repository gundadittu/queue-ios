//
//  GroupPlaylistContainerVC.swift
//  Queue
//
//  Created by Aditya Gunda on 9/3/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ChameleonFramework

class GroupPlaylistContainerVC: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var buttonBarObj: ButtonBarView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor =  FlatBlack()
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(12))!
        
        //settings.style.selectedBarBackgroundColor = FlatPurpleDark()
        //settings.style.buttonBarMinimumLineSpacing = CGFloat(0)

        self.title = "Group Playlist"
        self.view.backgroundColor = FlatWhite()
        scrollView.backgroundColor = FlatWhite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "GroupPlaylists", bundle: nil).instantiateViewController(withIdentifier: "playlist")
        let child_2 = UIStoryboard(name: "GroupPlaylists", bundle: nil).instantiateViewController(withIdentifier: "more")
        return [child_1,child_2]
    }


}
