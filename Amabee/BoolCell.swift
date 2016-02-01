//
//  BoolCell.swift
//  Amabee
//
//  Created by Piotr Olejnik on 30.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class BoolCell : UITableViewCell {
    
    
    @IBOutlet weak var boolSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    var boolVal = false
    var field : String!
    var delegate : CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetValues()
    }
    
    func resetValues() {
        self.boolSwitch.setOn(boolVal, animated: true)
    }
    
    func setBoolValue(selected: Bool){
        boolVal = selected
        self.boolSwitch.setOn(selected, animated: true)
    }
    
    @IBAction func switchToggled(sender: AnyObject) {
        boolVal = self.boolSwitch.on
        self.delegate?.didToggleField(field, selected: self.boolSwitch.on)
    }
}
