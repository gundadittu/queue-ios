//
//  SongOptionsVC.swift
//  Queue
//
//  Created by Aditya Gunda on 9/4/17.
//  Copyright © 2017 Aditya Gunda. All rights reserved.
//

import UIKit
import RMActionController

class SongOptionsController: RMActionController<UIView> {

        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    required override init?(style aStyle: RMActionControllerStyle, title aTitle: String?, message aMessage: String?, select selectAction: RMAction<UIView>?, andCancel cancelAction: RMAction<UIView>?) {
        super.init(style: aStyle, title: aTitle, message: aMessage, select: selectAction, andCancel: cancelAction);
        self.contentView = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
