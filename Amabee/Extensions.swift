//
//  Extensions.swift
//  Amabee
//
//  Created by Piotr Olejnik on 30.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

// Add anywhere in your app
extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, .Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
    
    typealias SimpleToFromRepalceList = [(fromSubString:String,toSubString:String)]
    
    // See http://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
    //
    func simpleReplace( mapList:SimpleToFromRepalceList ) -> String
    {
        var string = self
        
        for (fromStr, toStr) in mapList {
            let separatedList = string.componentsSeparatedByString(fromStr)
            if separatedList.count > 1 {
                string = separatedList.joinWithSeparator(toStr)
            }
        }
        
        return string
    }
    
    func xmlSimpleUnescape() -> String
    {
        let mapList : SimpleToFromRepalceList = [
            ("&amp;",  "&"),
            ("&quot;", "\""),
            ("&#x27;", "'"),
            ("&#x39;", "'"),
            ("&#x92;", "'"),
            ("&#x96;", "'"),
            ("&gt;",   ">"),
            ("&lt;",   "<")]
        
        return self.simpleReplace(mapList)
    }
    
    func xmlSimpleEscape() -> String
    {
        let mapList : SimpleToFromRepalceList = [
            ("&",  "&amp;"),
            ("\"", "&quot;"),
            ("'",  "&#x27;"),
            (">",  "&gt;"),
            ("<",  "&lt;")]
        
        return self.simpleReplace(mapList)
    }
    

}