//
//  PoliciesVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 04.02.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class PoliciesVC : BaseVC, UITableViewDelegate, UITableViewDataSource, AddPolicyDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var policies = [Policy]()
    var onceToken: dispatch_once_t = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let p = Database.sharedInstance.getPolicies() {
            self.policies = p
            self.tableView.reloadData()
        }
        if self.policies.count == 0 {
            dispatch_once(&self.onceToken) {
                self.showAlert("Dodaj polisy", message: "Niestety, lista Twoich polis jest pusta. Aby dodać nową polisę, kliknij przycisk \"DODAJ\"")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let rightButton = UIBarButtonItem(title: "DODAJ", style: .Plain, target: self, action: "addTapped")
        rightButton.tintColor = UIColor.whiteColor()
        self.tabBarController!.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController!.navigationItem.rightBarButtonItem = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: self)
        if segue.identifier == "addPolicy" {
            (segue.destinationViewController as! AddPolicyVC).delegate = self
        }
    }
    
    func didAddPolicy() {
        self.policies = Database.sharedInstance.getPolicies()!
        self.tableView.reloadData()
    }
    
    func addTapped() {
        self.performSegueWithIdentifier("addPolicy", sender: self)
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.policies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let policy = self.policies[indexPath.row]
        cell!.textLabel?.text = policy.name!
        cell!.detailTextLabel?.text = policy.expires
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let policy = self.policies[indexPath.row]
        self.showAlert("Opis polisy:", message: "Ważna do: \(policy.expires!) \n Opis: \(policy.desc!)")
    }

    
}