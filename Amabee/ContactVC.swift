//
//  ContactVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 07.02.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit
import MessageUI

class ContactVC : BaseChildVC, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var agree: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let rightButton = UIBarButtonItem(title: "WYŚLIJ", style: .Plain, target: self, action: "sendTapped")
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func sendTapped() {
        if !self.agree.on {
            return self.showAlert("Błąd", message: "Wyraź zgodę na przetwarzanie danych")
        }
        if self.phone.text == "" {
            return self.showAlert("Błąd", message: "Podaj telefon lub e-mail!")
        }
        if self.name.text == "" {
            return self.showAlert("Błąd", message: "Podaj imię!")
        }
        let body = "Proszę o kontakt w sprawie wyceny ubezpieczenia komunikacyjnego - \(self.name.text!), \(self.phone.text!)"
        if MFMailComposeViewController.canSendMail() {
        let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.setSubject("Amabee - prośba o kontakt")
            picker.setToRecipients(["silverbursted@gmail.com"])
            picker.setMessageBody(body, isHTML: true)
            presentViewController(picker, animated: true, completion: nil)
        } else {
            self.showAlert("Błąd", message: "Twój telefon nie jest w stanie wysłać tej wiadomości. Skonfiguruj domyślnego klienta pocztowego swojego iPhone'a")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nameEnd(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func phoneEnd(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func phoneDidEnd(sender: AnyObject) {
        if self.phone.text == "" {
            self.showAlert("Błąd", message: "Podaj telefon lub e-mail!")
        }
    }
    
    @IBAction func nameDidEnd(sender: AnyObject) {
        if self.name.text == "" {
            self.showAlert("Błąd", message: "Podaj imię!")
        }
    }
}
