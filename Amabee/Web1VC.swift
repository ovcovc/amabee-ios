//
//  Web1VC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 30.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class Web1VC : BaseVC {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "http://amabee.pl/apka/szkoda.html");
        let requestObj = NSURLRequest(URL: url!);
        self.webView.loadRequest(requestObj);
    }

    
}
