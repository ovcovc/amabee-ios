//
//  LoadingOverlay.swift
//  Skin Ninja
//
//  Created by Piotr Olejnik on 17.11.2015.
//  Copyright © 2015 Dook. All rights reserved.
//

import UIKit

class LoadingOverlay {
    
    static let sharedInstance = LoadingOverlay()
    let blurEffectView : UIVisualEffectView?
    var overlayView = UIView()
    var activityIndicator = DTIActivityIndicatorView()
    
    private init() {
        self.activityIndicator = DTIActivityIndicatorView(frame: CGRect(x:0, y:0, width:80.0, height:80.0))
        self.activityIndicator.indicatorColor = UIColor(red: 230/255.0, green: 0/255.0, blue: 126/255.0, alpha: 1)
        self.activityIndicator.indicatorStyle = DTIIndicatorStyle.convInv(.spotify)
        self.activityIndicator.startActivity()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        
    }
    
    func showOverlay(view: UIView) {
        self.blurEffectView!.frame = view.bounds
        overlayView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        overlayView.alpha = 0.0
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor.clearColor()
        overlayView.clipsToBounds = true
        activityIndicator.frame = CGRectMake(0, 0, 80.0, 80.0)
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        overlayView.addSubview(blurEffectView!)
        overlayView.addSubview(activityIndicator)
        self.activityIndicator.startActivity()
        view.addSubview(overlayView)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.overlayView.alpha = 1.0
        })
    }
    
    func hideOverlayView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.overlayView.alpha = 0.0
            }) { (Bool) -> Void in
                self.activityIndicator.stopActivity()
                self.overlayView.removeFromSuperview()
        }
        
    }
    
}
