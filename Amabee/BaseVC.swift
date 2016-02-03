//
//  BaseVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 25.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class BaseVC : UIViewController {
    
    var appDelegate : AppDelegate!
    var tabVC : TabBarVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.setBarTitle()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func setBarTitle() {
        let tabVC = self.parentViewController!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "amabee_icon.png")
        imageView.image = image
        tabVC.navigationItem.titleView = imageView
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
}
