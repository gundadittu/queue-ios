//
//  FirstViewController.swift
//  Queue
//
//  Created by Aditya Gunda on 8/3/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import XLPagerTabStrip

class HomeVC: ButtonBarPagerTabStripViewController  {
    
    @IBOutlet weak var buttonBarObject: ButtonBarView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        settings.style.selectedBarBackgroundColor = FlatPurpleDark()
        settings.style.buttonBarItemBackgroundColor = UIColor.white //GradientColor(.topToBottom, frame: view.frame, colors: backgroundGradientColors)
        settings.style.buttonBarItemTitleColor =  FlatBlack()
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(12))!
        settings.style.buttonBarMinimumLineSpacing = CGFloat(0)
        settings.style.buttonBarBackgroundColor = FlatWhite()
        //settings.style.buttonBarHeight = CGFloat(30)
        super.viewDidLoad()
        self.title = "Home"
        self.view.backgroundColor = FlatWhite()
        scrollView.backgroundColor = FlatWhite()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "feed")
        let child_2 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "explore")
        return [child_1,child_2]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    

}

