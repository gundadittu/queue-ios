//
//  CreatePlaylistVC.swift
//  Queue
//
//  Created by Aditya Gunda on 8/30/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework
import TextFieldEffects
import XLPagerTabStrip

class OldCreatePlaylistVC: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var buttonBarObject: ButtonBarView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        settings.style.selectedBarBackgroundColor = FlatWhite()
        settings.style.buttonBarItemBackgroundColor = FlatPurpleDark()
        settings.style.buttonBarItemTitleColor = FlatWhite()
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 17)
        settings.style.buttonBarMinimumLineSpacing = CGFloat(0)
        super.viewDidLoad()
        self.navigationItem.title = "Create"
        self.navigationController?.isNavigationBarHidden = false
        self.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "createlive")
        let child_2 = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "creategroup")
        return [child_1,child_2]
    }
}
