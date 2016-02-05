//
//  AddPolicyVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 04.02.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit



class AddPolicyVC : BaseChildVC, UITextFieldDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    var delegate : AddPolicyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descField.delegate = self
        self.nameField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let rightButton = UIBarButtonItem(title: "ZAPISZ", style: .Plain, target: self, action: "saveTapped")
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func saveTapped() {
        if self.nameField.text! == "" || self.descField.text! == "" {
            return self.showAlert("Błąd", message: "Uzupełnij wymagane pola")
        }
        let order = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: self.datePicker.date,
            toUnitGranularity: .Day)
        if order == .OrderedDescending || order == .OrderedSame {
            return self.showAlert("Błąd", message: "Wybrana data musi być w przyszłości")
        }
        Database.sharedInstance.createPolicy(self.nameField.text!, desc: self.descField.text!, expires: Utils.dateToString(self.datePicker.date, format: "dd-MM-yyyy"))
        self.navigationController?.popViewControllerAnimated(true)
        self.delegate?.didAddPolicy()
    }

    
    
    @IBAction func nameDidEdit(sender: AnyObject) {
        self.nameField.resignFirstResponder()
    }
    @IBAction func descDidEdit(sender: AnyObject) {
        self.descField.resignFirstResponder()
    }
}
