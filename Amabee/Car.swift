//
//  Car.swift
//  Amabee
//
//  Created by Piotr Olejnik on 29.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import Foundation

class Car {
    
    var model: String!
    var capacity: Int!
    var manufacturerId: Int64!
    var prodFrom: Int!
    var prodTo: Int!
    var modelId: Int64!
    var ieId: Int64!
    
    init(model: String!, capacity: Int!, mId: Int64, from: Int!, to: Int!, ieId: Int64, modelId: Int64) {
        self.manufacturerId = mId
        self.model = model
        self.capacity = capacity
        self.prodFrom = from
        self.prodTo = to
        self.ieId = ieId
        self.modelId = modelId
    }
    
}