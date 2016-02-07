//
//  TabBarVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 30.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class TabBarVC : UITabBarController {
    
    let magenta = UIColor(red: 230/255.0, green: 0, blue: 126/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
            if let selectedImage = item.selectedImage {
                item.selectedImage = selectedImage.imageWithColor(magenta).imageWithRenderingMode(.AlwaysOriginal)
            }
            //item.titlePositionAdjustment = UIOffsetMake(0, -30)
        }

    }
    
    
}
