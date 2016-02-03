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
        switch self.field {
            case "registryDate", "licenseDate":
                let order = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: self.datePicker.date,
                    toUnitGranularity: .Day)
                
                switch order {
                case .OrderedDescending:
                    //wczesniej
                    return true
                case .OrderedAscending, .OrderedSame:
                    self.showAlert("Błąd", message: "Wybrana data musi być w przeszłości")
                    return false
                }
            case "dob":
                let order = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: self.datePicker.date,
                    toUnitGranularity: .Day)
                
                switch order {
                case .OrderedDescending:
                    break
                case .OrderedAscending, .OrderedSame:
                    self.showAlert("Błąd", message: "Wybrana data musi być w przeszłości")
                    return false
                }
                let years = NSCalendar.currentCalendar().components(.Year, fromDate: self.datePicker.date, toDate: NSDate(), options: []).year
                    if years >= 18 {
                        return true
                    }
                    self.showAlert("Błąd", message: "Musisz być pełnoletni")
                    return false
            case "startInsurance":
                let order = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: self.datePicker.date,
                    toUnitGranularity: .Day)
                
                switch order {
                case .OrderedAscending:
                    return true
                case .OrderedDescending, .OrderedSame:
                    self.showAlert("Błąd", message: "Wybrana data musi być w przyszłości")
                    return false
            }

            default:
                return true
        }
    }
    
    
    
    func saveTapped() {
        if self.isValid() {
            self.delegate?.didEnterString(self.field, value: Utils.dateToString(self.datePicker.date, format: "dd-MM-yyyy"))
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
