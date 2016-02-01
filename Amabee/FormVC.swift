//
//  FormVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 25.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class FormVC: BaseVC, UITableViewDelegate, UITableViewDataSource, CellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var calc : Calculation!
    var selectedField = ""
    var selectedDate = ""

    let labels = [["Marka pojazdu", "Rok produkcji", "Model", "Pojemność silnika", "Data pierwszej rejestracji", "Suma ubezpieczenia", ], ["PESEL", "Data urodzenia", "Data uzyskania prawa jazdy", "Kod pocztowy", "Miejscowość"], ["Od ilu lat posiadasz OC?", "Ostatnie TU", "Czy była szkoda w ostatnim roku?", "Czy była szkoda w ostatnich 3 latach?"], ["Od ilu lat posiadasz AC?", "Ostatnie TU", "Czy była szkoda w ostatnim roku?", "Czy była szkoda w ostatnich 3 latach?"], ["Data rozpoczęcia ochrony", "Liczba rat", "Ubezpieczenie NNW", "Assistance", "Ochrona szyb"]]
    
    let cells = [["basic", "basic", "basic", "basic", "date", "text", ], ["text", "date", "date", "text", "basic"], ["basic", "basic", "bool", "bool"], ["basic", "basic", "bool", "bool"], ["date", "basic", "bool", "bool", "bool"]]
    
    let fields = [["carName", "carProduced", "carModel", "capacity", "registryDate", "insuranceValue", ], ["pesel", "dob", "licenseDate", "postalCode", "city"], ["ocYears", "ocLastInsurer", "ocDamage1Year", "ocDamage3Years"], ["acYears", "acLastInsurer", "acDamage1Year", "acDamage3Years"], ["startInsurance", "installments", "nnw", "assistance", "windshields"]]

    var manufacturers : [Manufacturer]!
    var years = [Int]()
    var cars = [Car]()
    var capacities = [Int]()
    var year = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if self.calc == nil {
            calc = Database.sharedInstance.createNewCalculation()
        }
        self.initData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let leftButton = UIBarButtonItem(title: "WYLICZ", style: .Plain, target: self, action: "calculateTapped")
        let rightButton = UIBarButtonItem(title: "ZAPISZ", style: .Plain, target: self, action: "addTapped")
        leftButton.tintColor = UIColor.whiteColor()
        rightButton.tintColor = UIColor.whiteColor()
        self.tabBarController!.navigationItem.rightBarButtonItem = rightButton
        self.tabBarController!.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.tabBarController!.navigationItem.rightBarButtonItem = nil
        self.tabBarController!.navigationItem.leftBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: self)
        if segue.identifier == "select" {
            (segue.destinationViewController as! SelectionVC).field = self.selectedField
            (segue.destinationViewController as! SelectionVC).delegate = self
            (segue.destinationViewController as! SelectionVC).tabVC = self.parentViewController as? TabBarVC
            switch self.selectedField {
            case "carName":
                (segue.destinationViewController as! SelectionVC).values = self.manufacturers
            case "carProduced":
                (segue.destinationViewController as! SelectionVC).values = self.years
            case "carModel":
                (segue.destinationViewController as! SelectionVC).values = self.cars
            case "capacity":
                (segue.destinationViewController as! SelectionVC).values = self.capacities
            default:
                print("lol")
            }
        } else {
            (segue.destinationViewController as! DateVC).field = self.selectedField
            (segue.destinationViewController as! DateVC).delegate = self
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let d = formatter.dateFromString(self.selectedDate)
            if d != nil {
                (segue.destinationViewController as! DateVC).inputDate = d
            }
        }
    }
    
    func loadCalc(calculation: Calculation) {
        self.calc = calculation
        if (Int(self.calc.manufacturerId!) != -1) {
            self.cars.removeAll()
            self.capacities.removeAll()
            self.years.removeAll()
            self.years = Database.sharedInstance.getYearsForManufacturer(Int(calculation.manufacturerId!))
            self.cars = Database.sharedInstance.getCarsFromYear(Int(calculation.manufacturerId!), year: Int(calculation.year!))
            self.capacities = Database.sharedInstance.getCapacitiesForModel(Int(calculation.modelId!))
        }
        self.tableView.reloadData()
    }
    
    func addTapped() {
        Database.sharedInstance.updateCalculation(self.calc)
    }
    
    func calculateTapped() {
        print("calculating")
    }
    
    func setValueForField(field: String, value: AnyObject) {
        self.calc.setValue(value, forKey:field)
    }
    
    // MARK: input values handling
    
    func initData(){
        self.manufacturers = Database.sharedInstance.getManufacturers()
    }

    //PRAGMA MARK:CELL DELEGATE METHODS
    func didToggleField(field: String, selected: Bool) {
        self.setValueForField(field, value: selected)
        self.tableView.reloadData()
    }
    
    func didEnterString(field: String, value: String) {
        self.setValueForField(field, value: value)
        self.tableView.reloadData()
    }
    
    func didEnterInt(field: String, value:Int) {
        self.setValueForField(field, value: value)
        self.tableView.reloadData()
    }
    
    func didEnterWrongValue(field: String, value: String) {
        print("WRONG VALUE FOR \(field)")
    }
    
    func didChooseManufacturerId(id: Int) {
        self.calc.manufacturerId = id
        self.calc.carProduced = -1
        self.calc.carModel = ""
        self.calc.carId = -1
        self.calc.modelId = -1
        self.calc.year = -1
        self.calc.capacity = -1
        self.years = Database.sharedInstance.getYearsForManufacturer(id)
        self.cars.removeAll()
        self.capacities.removeAll()
        self.tableView.reloadData()
    }
    
    func didChooseYear(year: Int) {
        self.calc.carModel = ""
        self.calc.capacity = -1
        self.calc.carId = -1
        self.calc.modelId = -1
        self.calc.year = year
        self.cars = Database.sharedInstance.getCarsFromYear(Int(self.calc.manufacturerId!), year: year)
        self.capacities.removeAll()
        self.tableView.reloadData()
    }
    
    func didChooseModelId(id: Int) {
        self.calc.modelId = id
        self.calc.capacity = -1
        self.capacities = Database.sharedInstance.getCapacitiesForModel(id)
        self.tableView.reloadData()
    }
    
    //PRAGMA MARK: TAB DELEGATE METHODS
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 5
        case 2:
            return 4
        case 3:
            return 4
        default:
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = self.cells[indexPath.section][indexPath.row]
        if identifier == "date" {
            identifier = "basic"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        let field = self.fields[indexPath.section][indexPath.row]
        if cell is BoolCell {
            let boolVal = self.calc.valueForKey(field) as! Bool
            (cell as! BoolCell).selectionStyle = .None
            (cell as! BoolCell).delegate = self
            (cell as! BoolCell).field = field
            (cell as! BoolCell).setBoolValue(boolVal)
            (cell as! BoolCell).titleLabel.text = self.labels[indexPath.section][indexPath.row]
        } else if cell is InputCell {
            let stringVal = "\(self.calc.valueForKey(field)!)"
            (cell as! InputCell).selectionStyle = .None
            (cell as! InputCell).delegate = self
            (cell as! InputCell).field = field
            (cell as! InputCell).inputField.text = stringVal
            (cell as! InputCell).titleLabel.text = self.labels[indexPath.section][indexPath.row]
        } else {
            cell!.textLabel?.text = self.labels[indexPath.section][indexPath.row]
            cell!.detailTextLabel?.text = "\(self.calc.valueForKey(field)!)"
            if cell!.detailTextLabel!.text == "" || cell!.detailTextLabel!.text == "-1" {
                cell!.detailTextLabel?.text = "wybierz..."
            }
        }
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let type = self.cells[indexPath.section][indexPath.row]
        self.selectedField = self.fields[indexPath.section][indexPath.row]
        switch type {
        case "date":
            self.selectedDate = self.calc.valueForKey(self.selectedField) as! String
            self.performSegueWithIdentifier("date", sender: self)
        case "basic":
            self.performSegueWithIdentifier("select", sender: self)
        default:
            print("NO SEGUE")
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "SAMOCHÓD"
        case 1:
            return "WŁAŚCICIEL"
        case 2:
            return "HISTORIA OC"
        case 3:
            return "HISTORIA AC"
        default:
            return "UBEZPIECZENIE"
        }

    }
    

    
}

