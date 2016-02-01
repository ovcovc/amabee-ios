//
//  Database.swift
//  Amabee
//
//  Created by Piotr Olejnik on 28.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit
import SQLite
import CoreData

class Database {
    
    static let sharedInstance = Database()
    let appDelegate : AppDelegate!
    
    private init() {
        print(__FUNCTION__)
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    // MARK: CORE DATA
    
    
    func createNewCalculation() -> Calculation? {
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Calculation")
        fetchRequest.predicate = NSPredicate(format: "calcId = %@", "-1")
        if let fetchResults = try? managedContext!.executeFetchRequest(fetchRequest) as? [Calculation] {
            if fetchResults != nil && fetchResults!.count != 0 {
                for f in fetchResults! {
                    managedContext!.deleteObject(f)
                }
            }
        }
        let entity =  NSEntityDescription.entityForName("Calculation",
            inManagedObjectContext:managedContext!)
        let calc = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext) as! Calculation
        calc.initValues()
        do {
            try managedContext!.save()
            return calc
        } catch {
            print("Database save error")
        }
        return nil
    }
    
    func updateCalculation(calc: Calculation) -> Calculation? {
        let managedContext = appDelegate!.managedObjectContext
        if calc.calcId == -1 {
            calc.calcId = getCalculations()?.count
        }
            //calc.carModel = "updated"
        calc.editedAt = Utils.dateToString(NSDate(), format: "HH:mm dd-MM-yyyy")
        do {
            try managedContext!.save()
            return calc
        } catch {
            print("Database save error")
        }
        return nil
    }
    
    
    func getCalculations() -> [Calculation]? {
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Calculation")
        if let fetchResults = try? managedContext!.executeFetchRequest(fetchRequest) as? [Calculation] {
            if fetchResults != nil {
                return fetchResults
            }
        }
        return nil
    }

    
    //MARK: sqlite
    
    //45 - fiat
    func getModels(id: Int64) -> [Car] {
        
        let path = NSBundle.mainBundle().pathForResource("auta", ofType: "sqlite")!
        
        let db = try? Connection(path, readonly: true)
        
        let name = Expression<String>("model")
        let mid = Expression<Int64>("id_marka")
        let from = Expression<Int>("prod_od")
        let to = Expression<Int>("prod_do")
        let capacity = Expression<Int>("pojemnosc")
        let ieId = Expression<Int64>("id_ie")
        let modelId = Expression<Int64>("MODEL_ID")
        
        let models = Table("modele").filter(mid == id)
        
        var result = [Car]()
        
        for c in try! db!.prepare(models) {
            print("name: \(c[name])")
            result.append(Car(model: c[name], capacity: c[capacity], mId: c[mid], from: c[from], to: c[to], ieId: c[ieId], modelId: c[modelId]))
        }
        
        return result
        
    }
    
    func getYearsForManufacturer(id: Int) -> [Int] {
        let cars = Database.sharedInstance.getModels(Int64(id))
        var year_from = 3000
        var year_to = 1000
        for c in cars {
            if c.prodFrom < year_from {
                year_from = c.prodFrom
            }
            if c.prodTo > year_to {
                year_to = c.prodTo
            }
        }
        var years = [Int]()
        if !(year_to == 1000 || year_from == 3000){
            years = Array(year_from...year_to)
        }
        return years
    }
    
    func getCarsFromYear(id: Int, year: Int) -> [Car] {
        
        let path = NSBundle.mainBundle().pathForResource("auta", ofType: "sqlite")!
        
        let db = try? Connection(path, readonly: true)
        
        var result = [Car]()
        
        for c in try! db!.prepare("SELECT * FROM modele WHERE id_marka LIKE \(id) AND ((prod_od < \(year) AND prod_do LIKE 0) OR (\(year) BETWEEN prod_od AND prod_do))") {
            print(c)
            var canInsert = true
            for car in result {
                if (car.modelId == c[1] as! Int64 || car.model.stringByReplacingOccurrencesOfString(" ", withString: "") == (c[2] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")) {
                    canInsert = false
                    break
                }
            }
            if canInsert {
                result.append(Car(model: c[2] as! String, capacity: Int(c[4] as! Int64), mId: c[0] as! Int64, from: Int(c[5] as! Int64), to: Int(c[6] as! Int64), ieId: c[3] as! Int64, modelId: c[1] as! Int64))
            }
        }
        
        return result

    }
    
    func getCapacitiesForModel(id: Int) -> [Int] {
        
        let path = NSBundle.mainBundle().pathForResource("auta", ofType: "sqlite")!
        
        let db = try? Connection(path, readonly: true)
        
        var result = [Int]()
        
        for c in try! db!.prepare("SELECT pojemnosc FROM modele WHERE MODEL_ID LIKE \(id)") {
            print(c)
            result.append(Int(c[0] as! Int64))
        }
        
        return  Array(Set(result))
        
    }
    
    
    
    func getManufacturers() -> [Manufacturer] {
        
        let path = NSBundle.mainBundle().pathForResource("auta", ofType: "sqlite")!
        
        let db = try? Connection(path, readonly: true)
        
        let name = Expression<String>("MARKA")
        let id = Expression<Int64>("MARKA_ID")
        
        let manufacturers = Table("marki")
        
        var result = [Manufacturer]()
        
        for m in try! db!.prepare(manufacturers) {
            print("id: \(m[id]), name: \(m[name])")
            result.append(Manufacturer(name: m[name], id: Int(m[id])))
        }
        return result
    }
    
    
    func getManufacturerById(mid: Int64) -> [Manufacturer] {
        
        let path = NSBundle.mainBundle().pathForResource("auta", ofType: "sqlite")!
        
        let db = try? Connection(path, readonly: true)
        
        let name = Expression<String>("MARKA")
        let id = Expression<Int64>("MARKA_ID")
        
        let manufacturers = Table("marki").filter(id == mid)
        
        var result = [Manufacturer]()
        
        for m in try! db!.prepare(manufacturers) {
            print("id: \(m[id]), name: \(m[name])")
            result.append(Manufacturer(name: m[name], id: Int(m[id])))
        }
        return result
        
    }
    
    
}