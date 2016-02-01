//
//  DateVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 01.02.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class DateVC : BaseChildVC {
   
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate : CellDelegate?
    var field = ""
    var inputDate : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let date = self.inputDate  {
            self.datePicker.setDate(date, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let rightButton = UIBarButtonItem(title: "ZAPISZ", style: .Plain, target: self, action: "saveTapped")
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func isValid() -> Bool {
        return true
    }
    
    func saveTapped() {
        if self.isValid() {
            self.delegate?.didEnterString(self.field, value: Utils.dateToString(self.datePicker.date, format: "dd-MM-yyyy"))
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
