//
//  Utils.swift
//  Amabee
//
//  Created by Piotr Olejnik on 31.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import Foundation

struct Utils {
    
    static func dateToString(date: NSDate, format: String) -> String {
        //"dd-MM-yyyy"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }

}