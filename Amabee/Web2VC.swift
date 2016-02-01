//
//  Web2VC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 30.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class Web2VC : BaseVC {
    
    @IBOutlet weak var wb: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "http://amabee.pl/apka/bazawiedzy.html");
        let requestObj = NSURLRequest(URL: url!);
        self.wb.loadRequest(requestObj);
    }

}
