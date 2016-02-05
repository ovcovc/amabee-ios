//
//  Calculation.swift
//
//
//  Created by Piotr Olejnik on 30.01.2016.
//
//

import Foundation
import CoreData


class Calculation: NSManagedObject {
    
    @NSManaged var calcId: NSNumber?
    @NSManaged var year: NSNumber?
    @NSManaged var manufacturerId: NSNumber?
    @NSManaged var modelId: NSNumber?
    @NSManaged var carName: String? 
    @NSManaged var carProduced: NSNumber?
    @NSManaged var carId: NSNumber?
    @NSManaged var carModel: String?
    @NSManaged var editedAt: String?
    @NSManaged var capacity: NSNumber?
    @NSManaged var registryDate: String?
    @NSManaged var insuranceValue: NSNumber?
    @NSManaged var pesel: String?
    @NSManaged var licenseDate: String?
    @NSManaged var postalCode: String?
    @NSManaged var dob: String?
    @NSManaged var city: String?
    @NSManaged var results: String?
    @NSManaged var cityId: NSNumber?
    @NSManaged var ocYears: NSNumber?
    @NSManaged var ocLastInsurer: NSNumber?
    @NSManaged var ocDamage1Year: NSNumber?
    @NSManaged var ocDamage3Years: NSNumber?
    @NSManaged var acYears: NSNumber?
    @NSManaged var acLastInsurer: NSNumber?
    @NSManaged var acDamage1Year: NSNumber?
    @NSManaged var acDamage3Years: NSNumber?
    @NSManaged var startInsurance: String?
    @NSManaged var installments: NSNumber?
    @NSManaged var finished: NSNumber?
    @NSManaged var nnw: NSNumber?
    @NSManaged var assistance: NSNumber?
    @NSManaged var windshields: NSNumber?
   
    func initValues() {
        self.manufacturerId = -1
        self.calcId = -1
        self.carName = ""
        self.carProduced = -1
        self.carId = -1
        self.carModel = ""
        self.modelId = -1
        self.capacity = -1
        self.registryDate = ""
        self.insuranceValue = 0
        self.pesel = ""
        self.licenseDate = ""
        self.postalCode = ""
        self.dob = ""
        self.city = ""
        self.cityId = -1
        self.ocYears = -1
        self.ocLastInsurer = -1
        self.ocDamage1Year = 0
        self.ocDamage3Years = 0
        self.acYears = -1
        self.acLastInsurer = -1
        self.acDamage1Year = 0
        self.acDamage3Years = 0
        self.startInsurance = ""
        self.installments = -1
        self.nnw = 0
        self.assistance = 0
        self.results = ""
        self.windshields = 0
        self.finished = 0
        self.editedAt = "not edited"
        self.year = -1
    }
}


