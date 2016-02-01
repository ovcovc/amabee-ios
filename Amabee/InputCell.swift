//
//  InputCell.swift
//  Amabee
//
//  Created by Piotr Olejnik on 31.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class InputCell : UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    var delegate : CellDelegate?
    var field : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func didEnd(sender: AnyObject) {
        switch field {
        case "insuranceValue" :
            if let number = Int(self.inputField.text!) {
                self.delegate?.didEnterInt(field, value: number)
            } else {
                self.inputField.text = "0"
                self.delegate?.didEnterWrongValue(field, value: self.inputField.text!)
            }
        default:
            self.delegate?.didEnterString(field, value: self.inputField.text!)
        }
        
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        if self.inputField.text! == ""{
            self.inputField.text = "0"
        }
    }
}
