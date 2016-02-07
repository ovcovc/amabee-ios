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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let rightButton = UIBarButtonItem(title: "SKONTAKTUJ SIĘ", style: .Plain, target: self, action: "contactTapped")
        rightButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightButton

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func contactTapped() {
        self.performSegueWithIdentifier("contact", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = "Oferta \(indexPath.row + 1)"
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
