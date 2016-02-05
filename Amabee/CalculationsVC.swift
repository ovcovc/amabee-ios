//
//  CalculationsVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 25.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class CalculationsVC: BaseVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var calculations : [Calculation] = [Calculation]()
    var calc : Calculation?
    var onceToken: dispatch_once_t = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.calculations = Database.sharedInstance.getCalculations()!
        self.tableView.reloadData()
        if self.calculations.count == 0 {
            dispatch_once(&self.onceToken) {
                self.showAlert("Zapisane kalkulacje", message: "Lista zapisanych kalkulacji jest pusta. Aby ją zapełnić, kliknij przycisk \"ZAPISZ\" w formularzu")
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: self)
        if segue.identifier == "results" {
            (segue.destinationViewController as! ResultVC).results = self.calc!.results!.characters.split{$0 == ","}.map(String.init)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calculations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let calc = self.calculations[indexPath.row]
        if !calc.finished!.boolValue {
            cell!.textLabel!.text = "Niedokończona kalkulacja"
        } else {
            cell!.textLabel!.text = "Kalkulacja"
        }
        cell?.detailTextLabel?.text = calc.editedAt
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let calc = self.calculations[indexPath.row]
        if calc.finished!.boolValue {
            self.calc = calc
            self.performSegueWithIdentifier("results", sender: self)
        } else {
            self.goToFormAndRedraw(calc)
        }
    }
    
    func goToFormAndRedraw(calc: Calculation) {
        for vc in self.tabBarController!.viewControllers! {
            if vc is FormVC {
                (vc as! FormVC).loadCalc(calc)
                return (self.tabBarController?.selectedIndex = 0)!
            }
        }
        
    }
    
}

