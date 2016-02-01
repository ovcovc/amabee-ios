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
        default:
            print("lol")
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
