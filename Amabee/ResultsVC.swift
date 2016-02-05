//
//  ResultsVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 04.02.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class ResultVC : BaseChildVC, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    var results : [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = "Towarzystwo \(indexPath.row + 1)"
        cell!.detailTextLabel?.text = self.results[indexPath.row]
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.showAlert("Szczegółowa wycena", message: "Skontaktuj się z nami, aby poznać szczegóły!")
    }

}
