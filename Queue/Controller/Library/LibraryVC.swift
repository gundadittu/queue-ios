//
//  LibraryVC.swift
//  Queue
//
//  Created by Aditya Gunda on 9/4/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ChameleonFramework


class LibraryVC: ButtonBarPagerTabStripViewController{
    
    
    @IBOutlet weak var buttonBarObj: ButtonBarView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor =  FlatBlack()
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(12))!
        settings.style.buttonBarMinimumLineSpacing = CGFloat(0)
        settings.style.selectedBarBackgroundColor = FlatPurpleDark()
        super.viewDidLoad()
        self.title = "Library"
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Library", bundle: nil).instantiateViewController(withIdentifier: "playlists")
        let child_2 = UIStoryboard(name: "Library", bundle: nil).instantiateViewController(withIdentifier: "songs")
        let child_3 = UIStoryboard(name: "Library", bundle: nil).instantiateViewController(withIdentifier: "albums")

        return [child_1,child_2, child_3]
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
