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
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor =  FlatBlack()
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(12))!
        settings.style.buttonBarMinimumLineSpacing = CGFloat(0)
        //settings.style.buttonBarBackgroundColor = UIColor.ghostWhite()
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
        self.navigationController?.navigationBar.barTintColor = FlatPurpleDark()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatBlack()]
        self.navigationController?.navigationBar.tintColor = FlatPurpleDark()
    }
    

}

