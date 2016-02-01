//
//  TabBarVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 30.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class TabBarVC : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
            if let selectedImage = item.selectedImage {
                item.selectedImage = selectedImage.imageWithColor(UIColor.redColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
            item.titlePositionAdjustment = UIOffsetMake(0, -30)
        }

    }
    
    
}
