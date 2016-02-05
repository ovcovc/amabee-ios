//
//  Policy.swift
//
//
//  Created by Piotr Olejnik on 04.02.2016.
//
//

import Foundation
import CoreData


class Policy: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var desc: String?
    @NSManaged var expires: String?
    
}
