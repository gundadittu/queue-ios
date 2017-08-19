

import UIKit

class fbButton: UIButton {

    override func awakeFromNib() {
        self.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        self.layer.cornerRadius = 15 
    }

}
