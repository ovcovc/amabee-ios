//
//  FormVC.swift
//  Amabee
//
//  Created by Piotr Olejnik on 25.01.2016.
//  Copyright © 2016 Amabee. All rights reserved.
//

import UIKit

class FormVC: BaseVC, UITableViewDelegate, UITableViewDataSource, CellDelegate, NSXMLParserDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    //result
    var results = [Int]()
    
    var calc : Calculation!
    var selectedField = ""
    var selectedDate = ""
    var count = 0
    
    let yearsInsured = ["0","1","2","3","4","5","6","7","Więcej"]
    
    let installments = [1, 2, 4]
    
    let insurers = [ ["brak polisy": 0], ["Allianz":1], ["AXA Direct":2], ["Aviva":3], ["Benefia":4], ["mBank":5], ["Compensa":6], [ "InterRisk":11 ], ["LibertyDirect":12 ], [ "Link4":13 ], [ "MTU":14 ], [ "PTU":15 ], ["Polski Związek Motorowy":16 ], ["PZU":17 ], ["TUW":18 ],["TUZ":19 ], ["UNIQA":20 ], ["Warta":21 ], ["Proama":22 ],         ["TUW Pocztowy":23 ], ["Gothaer":24 ], ["Inny":99 ], ["Allianz Direct":25 ], [ "Concordia":7 ], ["Ergo Hestia":8 ], ["Generali":9 ], ["HDI":10 ] ];

    let labels = [["Marka pojazdu", "Rok produkcji", "Model", "Pojemność silnika", "Data pierwszej rejestracji", "Suma ubezpieczenia", ], ["PESEL", "Data urodzenia", "Data uzyskania prawa jazdy", "Kod pocztowy", "Miejscowość"], ["Od ilu lat posiadasz OC?", "Ostatnie TU", "Czy była szkoda w ostatnim roku?", "Czy była szkoda w ostatnich 3 latach?"], ["Od ilu lat posiadasz AC?", "Ostatnie TU", "Czy była szkoda w ostatnim roku?", "Czy była szkoda w ostatnich 3 latach?"], ["Data rozpoczęcia ochrony", "Liczba rat", "Ubezpieczenie NNW", "Assistance", "Ochrona szyb"]]
    
    let cells = [["basic", "basic", "basic", "basic", "date", "text", ], ["text", "date", "date", "text", "basic"], ["basic", "basic", "bool", "bool"], ["basic", "basic", "bool", "bool"], ["date", "basic", "bool", "bool", "bool"]]
    
    let fields = [["carName", "carProduced", "carModel", "capacity", "registryDate", "insuranceValue", ], ["pesel", "dob", "licenseDate", "postalCode", "city"], ["ocYears", "ocLastInsurer", "ocDamage1Year", "ocDamage3Years"], ["acYears", "acLastInsurer", "acDamage1Year", "acDamage3Years"], ["startInsurance", "installments", "nnw", "assistance", "windshields"]]

    var manufacturers : [Manufacturer]!
    var years = [Int]()
    var cars = [Car]()
    var capacities = [Int]()
    var cities = [City]()
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
            case "city":
                (segue.destinationViewController as! SelectionVC).values = self.cities
            case "acYears", "ocYears":
                (segue.destinationViewController as! SelectionVC).values = self.yearsInsured
            case "acLastInsurer", "ocLastInsurer":
                (segue.destinationViewController as! SelectionVC).values = self.insurers
            case "installments":
                (segue.destinationViewController as! SelectionVC).values = self.installments
            default:
                print("lol")
            }
        } else if segue.identifier == "results" {
            (segue.destinationViewController as! ResultVC).results = self.results
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
        self.cities.removeAll()
        self.cities = Database.sharedInstance.getCities(self.calc.postalCode!)
        self.tableView.reloadData()
    }
    
    func addTapped() {
        Database.sharedInstance.updateCalculation(self.calc)
    }
    
    func calculateTapped() {
        LoadingOverlay.sharedInstance.showOverlay(self.appDelegate.window!)
        self.results.removeAll()
        self.finalizeCalculation { (success) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            LoadingOverlay.sharedInstance.hideOverlayView()
                if success {
                    self.performSegueWithIdentifier("results", sender: self)
                } else {
                    self.showAlert("Niestety, brak ofert ubezpieczenia", message: "Skontaktuj się z nami po indywidualną ofertę!")
                }
            })
        }
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
        if field == "pesel" {
            if let dob = Utils.stringToDate(value[0...5], format: "yyMMdd") {
                self.calc.dob = Utils.dateToString(dob, format: "dd-MM-yyyy")
            } 
        }
        self.tableView.reloadData()
    }
    
    func didEnterInt(field: String, value:Int) {
        self.setValueForField(field, value: value)
        self.tableView.reloadData()
    }
    
    func didEnterWrongValue(field: String, value: String) {
        self.showAlert("Błąd", message: "Wpisz poprawną wartość!")
        print("WRONG VALUE FOR \(field)")
    }
    
    func didEnterPostalCode(field: String, value:String) {
        self.calc.postalCode = value
        self.cities = Database.sharedInstance.getCities(value)
        if self.cities.isEmpty {
            self.showAlert("Błędny kod", message: "Nie znalezliono miejscowości z tym kodem!")
        }
        self.tableView.reloadData()
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
    
    func getInsurersNameById(id: Int) -> String {
        for i in insurers {
            if i.values.first! == id {
                return i.keys.first!
            }
        }
        return "wybierz..."
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
            switch field {
            case "ocLastInsurer", "acLastInsurer":
                cell!.detailTextLabel?.text = self.getInsurersNameById(self.calc.valueForKey(field)! as! Int)
            case "ocYears", "acYears":
                if self.yearsInsured.count > self.calc.valueForKey(field)! as! Int && self.calc.valueForKey(field)! as! Int != -1 {
                    cell!.detailTextLabel?.text = self.yearsInsured[self.calc.valueForKey(field)! as! Int]
                } else {
                    cell!.detailTextLabel?.text = "wybierz..."
                }
            default:
                cell!.detailTextLabel?.text = "\(self.calc.valueForKey(field)!)"
            }
            cell!.textLabel?.text = self.labels[indexPath.section][indexPath.row]
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
    
    
    //MARK: Query
    
    func finalizeCalculation( completion: (success: Bool) -> Void) {
        
        let path = NSBundle.mainBundle().pathForResource("example", ofType: "txt")
        if path == nil {
            return completion(success: false)
        }
        
        var fileContents: String? = nil
        do {
            fileContents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch _ as NSError {
             return completion(success: false)
        }
        //O JEZU
        
        func invertDate(string: String) -> String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.dateFromString(string)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.stringFromDate(date!)
        }
        
        fileContents = fileContents!.stringByReplacingOccurrencesOfString("PESEL", withString: self.calc.pesel!).stringByReplacingOccurrencesOfString("DOB", withString:  invertDate(self.calc.dob!)).stringByReplacingOccurrencesOfString("POSTALCODE", withString:  self.calc.postalCode!).stringByReplacingOccurrencesOfString("LASTOC", withString:  "\(self.calc.ocLastInsurer!.integerValue)").stringByReplacingOccurrencesOfString("LASTYEAROC", withString:  "\(self.calc.ocDamage1Year!.integerValue)").stringByReplacingOccurrencesOfString("LASTAC", withString:  "\(self.calc.acLastInsurer!.integerValue)").stringByReplacingOccurrencesOfString("LASTYEARAC", withString:  "\(self.calc.acDamage1Year!.integerValue)").stringByReplacingOccurrencesOfString("LICENSEDATE", withString:  invertDate(self.calc.licenseDate!)).stringByReplacingOccurrencesOfString("LAST3YEARSAC", withString:  "\(self.calc.acDamage3Years!.integerValue)").stringByReplacingOccurrencesOfString("REGISTRYDATE", withString:  invertDate(self.calc.registryDate!)).stringByReplacingOccurrencesOfString("CARID", withString:  "\(self.calc.carId!.integerValue)").stringByReplacingOccurrencesOfString("PRODUCED", withString:  "\(self.calc.carProduced!.integerValue)").stringByReplacingOccurrencesOfString("CAPACITY", withString:  "\(self.calc.capacity!.integerValue)").stringByReplacingOccurrencesOfString("STARTINSURANCE", withString:  invertDate(self.calc.startInsurance!)).stringByReplacingOccurrencesOfString("INSURANCEVALUE", withString:  "\(self.calc.insuranceValue!.integerValue)").stringByReplacingOccurrencesOfString("INSTALLMENTS", withString:  "\(self.calc.installments!.integerValue)").stringByReplacingOccurrencesOfString("SZYBY", withString:  "\(self.calc.windshields!.integerValue)").stringByReplacingOccurrencesOfString("\n", withString:  "")

var body = "<soapenv:Envelope xmlns:xsi=\\\"http://www.w3.org/2001/XMLSchema-instance\\\" " +
            "xmlns:xsd=\\\"http://www.w3.org/2001/XMLSchema\\\" " +
            "xmlns:soapenv=\\\"http://schemas.xmlsoap.org/soap/envelope/\\\" " +
            "xmlns:myns=\\\"http://www.example.org/myns/\\\"><soapenv:Header/>" +
            "<soapenv:Body><myns:getQuoteToProducts " +
            "soapenv:encodingStyle=\\\"http://schemas.xmlsoap.org/soap/encoding/\\\">" +
            "<xmlDocument xsi:type=\\\"xsd:string\\\"><![CDATA[CONTENT]]></xmlDocument>" +
        "</myns:getQuoteToProducts></soapenv:Body></soapenv:Envelope>"
        body = body.stringByReplacingOccurrencesOfString("CONTENT", withString: fileContents!)
        body = body.stringByReplacingOccurrencesOfString("\\", withString: "")
        //body = body.stringByReplacingOccurrencesOfString("\n", withString: "")
        let is_URL = "http://systemdlaagenta.pl/ws/QuoteServerXML.php"
        print(body)
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        //lobj_Request.addValue("http://systemdlaagenta.pl", forHTTPHeaderField: "Host")
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //lobj_Request.addValue(String(body.characters.count), forHTTPHeaderField: "Content-Length")
        //lobj_Request.addValue("223", forHTTPHeaderField: "Content-Length")
        //lobj_Request.addValue("http://systemdlaagenta.pl/GetSystemStatus", forHTTPHeaderField: "SOAPAction")
        
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            var xmlParser = NSXMLParser(data: data!)
            xmlParser.delegate = self
            xmlParser.parse()
            xmlParser.shouldResolveExternalEntities = true
            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("\(strData)".xmlSimpleUnescape())
            
            if error != nil
            {
                print("Error: " + error!.description)
            }
             return completion(success: true)
        })
        task.resume()
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        switch count {
        case 1:
            self.count += 1
            break
        case 2:
            if let hajs = Int(string){
                self.results.append(hajs)
            }
            self.count = 0
            break
        default:
            break
        }
        if string.containsString("nr_raty") {
            self.count += 1
        }
        
    }
    
}

