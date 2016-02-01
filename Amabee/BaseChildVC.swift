//
//  BaseChildVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 01.02.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class BaseChildVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBarTitle()
    }
    
    func setBarTitle() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "amabee_icon.png")
        imageView.image = image
        self.navigationItem.titleView = imageView
    }

}
