//
//  SelectionVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 31.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class SelectionVC : BaseChildVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var field = ""
    var values = [AnyObject]()
    var delegate : CellDelegate?
    var tabVC : TabBarVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        var label = ""
        switch self.field {
        case "carName":
            label = (self.values[indexPath.row] as! Manufacturer).name
        case "carProduced", "capacity":
            label = "\(self.values[indexPath.row])"
        case "carModel":
            label = ((self.values[indexPath.row] as! Car).model)
        case "city":
            label = ((self.values[indexPath.row] as! City).name)
        case "acYears", "ocYears":
            label = self.values[indexPath.row] as! String
            //(segue.destinationViewController as! SelectionVC).values = self.yearsInsured
        case "acLastInsurer", "ocLastInsurer":
            label = Array(self.values[indexPath.row] as! Dictionary<String, Int>)[0].0
            //(segue.destinationViewController as! SelectionVC).values = self.insurers
        case "installments":
            label = "\(self.values[indexPath.row])"
            //(segue.destinationViewController as! SelectionVC).values = self.installments

        default:
            print("lol")
        }
        cell?.textLabel?.text = label
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch self.field {
        case "carName":
            self.delegate?.didEnterString(self.field, value: (self.values[indexPath.row] as! Manufacturer).name)
            self.delegate?.didChooseManufacturerId((self.values[indexPath.row] as! Manufacturer).id)
        case "carProduced":
            self.delegate?.didEnterInt(self.field, value: self.values[indexPath.row] as! Int)
            self.delegate?.didChooseYear(self.values[indexPath.row] as! Int)
        case "carModel":
            self.delegate?.didEnterString(self.field, value: (self.values[indexPath.row] as! Car).model)
            self.delegate?.didEnterInt("carId", value: Int((self.values[indexPath.row] as! Car).ieId))
            self.delegate?.didChooseModelId(Int((self.values[indexPath.row] as! Car).modelId))
        case "capacity":
            self.delegate?.didEnterInt(self.field, value: self.values[indexPath.row] as! Int)
        case "city":
            self.delegate?.didEnterString(self.field, value: (self.values[indexPath.row] as! City).name)
            let code = (self.values[indexPath.row] as! City).code
            self.delegate?.didEnterInt("cityId", value: code)
        case "acYears", "ocYears":
            self.delegate?.didEnterInt(field, value: indexPath.row)
            //abel = self.values[indexPath.row] as! String
            //(segue.destinationViewController as! SelectionVC).values = self.yearsInsured
        case "acLastInsurer", "ocLastInsurer":
            let arr = Array(self.values[indexPath.row] as! Dictionary<String, Int>)
            self.delegate?.didEnterInt(self.field, value: arr[0].1)
            break
            //(segue.destinationViewController as! SelectionVC).values = self.insurers
        case "installments":
            self.delegate?.didEnterInt(field, value: self.values[indexPath.row] as! Int)

        default:
            print("lol")
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
