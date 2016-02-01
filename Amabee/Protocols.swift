//
//  Protocols.swift
//  Amabee
//
//  Created by Piotr Olejnik on 30.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import Foundation

protocol CellDelegate {
    
    func didToggleField(field: String, selected: Bool)
    func didEnterString(field: String, value: String)
    func didEnterInt(field: String, value:Int)
    func didEnterWrongValue(field: String, value: String)
    func didChooseManufacturerId(id: Int)
    func didChooseYear(year: Int)
    func didChooseModelId(id: Int)
}