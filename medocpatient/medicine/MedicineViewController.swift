//
//  MedicineViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import UserNotifications
struct Med: Decodable {
    var msg: String?
    var data: [MedData]?
}
struct MedData: Decodable {
    var prescription_details: MedPrescription?
    var medicines: [MedicinesData]?
}
struct MedPrescription: Decodable {
    var patient_problem: String?
}
struct MedicinesData: Decodable {
    var medicine_name: String?
}
class MedicineViewController: UIViewController , UISearchControllerDelegate , UISearchBarDelegate{

    @IBOutlet var tableview: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

 //   var items : [Medicine] = []
    var notificationGranted = false
    var medicineData = NSArray()
    var prescription = NSArray()
    var data = NSArray()
    var timeslot = [String]()
    var took = false
    var headertitle = ""
    var timerDic = NSMutableDictionary()
    
//    var med = [Med]()
//    var medData = [MedData]()
//    var medPrescription = [MedPrescription]()
//    var medicinesData = [MedicinesData]()
//
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=20
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   SearchAction()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadmedicine"), object: nil)
      //  navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
       
       // UNUserNotificationCenter.current().cleanRepeatingNotifications()
        
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    @objc func add(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMedicinesViewController") as! AddMedicinesViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func repeatNotification(title: String,body: String,minute: Int){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "medicine.reminder.category"
        
        var dateComponents = DateComponents()
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        dateComponents.hour = hour
        dateComponents.minute = minutes + minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "medicine.reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error in pizza reminder: \(error.localizedDescription)")
            }
        }
        print("added notification:\(request.identifier)")
    }
    @objc func reload(){
        self.tableview.reloadData()
    }
    func SearchAction(){
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self  
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.white
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        let barButtonAppearanceInSearchBar: UIBarButtonItem?
        barButtonAppearanceInSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
      //  barButtonAppearanceInSearchBar?.image = #imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate)
        barButtonAppearanceInSearchBar?.tintColor = UIColor.white
      //  barButtonAppearanceInSearchBar?.title = nil 
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        searchController.searchBar.endEditing(true)
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
        searchController.searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchController.searchBar.text?.isEmpty)! {
           // filter = getAllusersdata
            tableview.reloadData()
            searchController.searchBar.showsCancelButton = true
        } else {
            searchController.searchBar.showsCancelButton = true
            tableview.reloadData()
        } 
    }
    override func viewDidAppear(_ animated: Bool) {
       // fetchdata()
        fetchmedicine()
    }
    func fetchmedicine(){
        SwiftLoader.show(title: "Fetch Medicines..", animated: true)
        ApiServices.shared.FetchPostDataFromUrl(vc: self, withOutBaseUrl: "medicines", bearertoken: bearertoken!, parameter: "", onSuccessCompletion: {
            do {
                
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let data = json.value(forKey: "data") as? NSArray{
                            self.data = data
                            self.prescription = data.value(forKey: "prescription_details") as! NSArray
                            print("prescription-\(self.prescription)")
                           // self.headertitle = "Problem: \(patientproblem)"
                            if let medicines = data.value(forKey: "medicines") as? NSArray{
                                self.medicineData = medicines
                                print("medicines-\(self.medicineData)")

                                DispatchQueue.main.async {
                                    self.tableview.reloadData()
                                    SwiftLoader.hide()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.view.showToast("No Medicine Found", position: .bottom, popTime: 5, dismissOnTap: true)
                                SwiftLoader.hide()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.showToast("No Medicine Found", position: .bottom, popTime: 5, dismissOnTap: true)
                            SwiftLoader.hide()
                            
                        }
                    }
                }
            } catch {
                print("catch")
                SwiftLoader.hide()
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
/*
 let decode = try JSONDecoder().decode(Med.self, from: ApiServices.shared.data)
 self.med = [decode]
 DispatchQueue.global(qos: .userInteractive).async {
 for item in self.med {
 self.medData = item.data!
 }
 for item in self.medData {
 self.medPrescription = [item.prescription_details] as! [MedPrescription]
 }
 }
 
 DispatchQueue.main.async {
 self.tableview.reloadData()
 //  self.view.showToast("No Medicine Found", position: .bottom, popTime: 5, dismissOnTap: true)
 SwiftLoader.hide()
 }
*/
//    func fetchdata(){
//        let appdel = UIApplication.shared.delegate as! AppDelegate
//        let context = appdel.persistentContainer.viewContext
//        
//        do{
//            items = try context.fetch(Medicine.fetchRequest())
//            self.tableview.reloadData()
//        } catch {
//            
//        }
//    }
}
extension MedicineViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let md = self.medicineData.object(at: section) as! NSArray
        print("md: \(md.count)")
        return md.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.prescription.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let d = self.prescription.object(at: section) as! NSDictionary
        let patient_problem = d.value(forKey: "patient_problem") as! String
        return "Name : \(patient_problem)"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicinecell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineTableViewCell
        let md = self.medicineData.object(at: indexPath.section) as! NSArray
        if md.count == 0{
            
        } else {
            
        let d = md.object(at: indexPath.row) as! NSDictionary

        let name = d.value(forKey: "medicine_name") as! String
       
        let before_bf = d.value(forKey: "before_bf") as! String
        let before_bf_time = d.value(forKey: "before_bf_time") as! String
//        if before_bf == "1"{
//            if !self.timeslot.contains("Before \(before_bf_time) minute Of Breakfast"){
//                self.timeslot.append("Before \(before_bf_time) minute Of Breakfast")
//            }
//        }
        
        let after_bf = d.value(forKey: "after_bf") as! String
        let after_bf_time = d.value(forKey: "after_bf_time") as! String
//        if after_bf == "1"{
//            if !self.timeslot.contains("After \(after_bf_time) minute Of Breakfast"){
//                self.timeslot.append("After \(after_bf_time) minute Of Breakfast")
//            }
//        }
        
        let before_lunch = d.value(forKey: "before_lunch") as! String
        let before_lunch_time = d.value(forKey: "before_lunch_time") as! String
//        if before_lunch == "1"{
//            if !self.timeslot.contains("Before \(before_lunch_time) minute Of Lunch"){
//                self.timeslot.append("Before \(before_lunch_time) minute Of Lunch")
//            }
//        }
        
        let after_lunch = d.value(forKey: "after_lunch") as! String
        let after_lunch_time = d.value(forKey: "after_lunch_time") as! String
//        if after_lunch == "1"{
//            if !self.timeslot.contains("After \(after_lunch_time) minute Of Lunch"){
//                self.timeslot.append("After \(after_lunch_time) minute Of Lunch")
//            }
//        }
        
        let before_dinner = d.value(forKey: "before_dinner") as! String
        let before_dinner_time = d.value(forKey: "before_dinner_time") as! String
//        if before_dinner == "1"{
//            if !self.timeslot.contains("Before \(before_dinner_time) minute Of Dinner"){
//                self.timeslot.append("Before \(before_dinner_time) minute Of Dinner")
//            }
//        }
        
        let after_dinner = d.value(forKey: "after_dinner") as! String
        let after_dinner_time = d.value(forKey: "after_dinner_time") as! String
//        if after_dinner == "1"{
//            if !self.timeslot.contains("After \(after_dinner_time) minute Of Dinner"){
//                self.timeslot.append("After \(after_dinner_time) minute Of Dinner")
//            }
//        }
        
        let interval_period = d.value(forKey: "interval_period") as! String
        let interval_time = d.value(forKey: "interval_time") as! String
        let interval_type = d.value(forKey: "interval_type") as! String
        
        switch interval_type {
        case "1":
            medicinecell.interval_type.text = "Type: Daily"
            medicinecell.interval_period.text = "Period: \(interval_period) days"
            medicinecell.interval_time.text = "";
        case "2":
            medicinecell.interval_type.text = "Type: Weekly"
            medicinecell.interval_period.text = "Period: \(interval_period) weeks"
            medicinecell.interval_time.text = "Time: \(interval_time) times";
        case "3":
            medicinecell.interval_type.text = "Type: Time interval"
            medicinecell.interval_period.text = "Period: \(interval_period) days"
            medicinecell.interval_time.text = "Time: \(interval_time) times";
        default:
            medicinecell.interval_type.text = "Type: NF"
            medicinecell.interval_period.text = ""
            medicinecell.interval_time.text = ""
        }
        medicinecell.name.text = "Medicine Name: \(name)"
        
        var breakfast = Int()
        var lunch = Int()
        var dinner = Int()
        
        breakfast = Int(before_bf)! + Int(after_bf)!
        lunch = Int(before_lunch)! + Int(after_lunch)!
        dinner = Int(before_dinner)! + Int(after_dinner)!
        
        if breakfast == 2{
            breakfast = 1
        }
        if lunch == 2{
            lunch = 1
        }
        if dinner == 2{
            dinner = 1
        }

        //medicinecell.timeslot.text = "\(before_bf)-\(after_bf)-\(before_lunch)-\(after_lunch)-\(before_dinner)-\(after_dinner)"
        medicinecell.timeslot.text = "\(breakfast)-\(lunch)-\(dinner)"

       // medicinecell.timeslot.text = "\(self.timeslot.joined(separator: "-"))"
       }
        
//        if notificationGranted {
//           // repeatNotification(title: "Time To Take Medicine", body: "-\(items[indexPath.row].name!)", minute: Int(items[indexPath.row].repeattimeslot!)!)
//        } else {
//            print("notification not granted")
//        }
       /* for _ in 0...medicineData.count {
            DispatchQueue.main.async {
                Alert.shared.ActionAlert(vc: self, title: "Time To Take Medicine", msg: "-\(name)", buttontitle: "Taken", button2title: "Remind Me Later", ActionCompletion: {
                    self.took = true
                }) {
                    self.took = false
                    self.timerDic = ["msg":"-\(name)","took":self.took]
                    Timer.scheduledTimer(timeInterval: 60 * 1, target: self, selector: #selector(self.remind), userInfo: self.timerDic, repeats: true)
                }
            }
        }*/
      /*  for _ in 0...items.count{
            for i in items {
                if items.count > 0{
                    if i.took == false {
                        
                        let now = Date()
                        var first = Date()
                        var second = Date()
                        
                        if (i.timeslot?.contains(find: "Morning"))! {
                            first = now.dateAt(hours: 8, minutes: 0)
                            second = now.dateAt(hours: 11, minutes: 00)
                            print("M-\(first)-\(second)")
                            break
                        }
                        else if (i.timeslot?.contains(find: "Afternoon"))! {
                            first = now.dateAt(hours: 12, minutes: 0)
                            second = now.dateAt(hours: 15, minutes: 00)
                            print("A-\(first)-\(second)")
                            break
                        }
                        else if (i.timeslot?.contains(find: "Evening"))! {
                            first = now.dateAt(hours: 17, minutes: 0)
                            second = now.dateAt(hours: 19, minutes: 00)
                            print("E-\(first)-\(second)")
                            break
                        }
                        else if (i.timeslot?.contains(find: "Night"))! {
                            first = now.dateAt(hours: 20, minutes: 0)
                            second = now.dateAt(hours: 23, minutes: 59)
                            print("N-\(first)-\(second)")
                            break
                        }
                        print("\(first)-\(second)")
                        print("BT: \(now >= first) && \(now <= second)")
                        if now >= first &&
                            now <= second
                        {
                            DispatchQueue.main.async {
                                print("BT: \(now >= first) && \(now <= second)")
                                Alert.shared.ActionAlert(vc: self, title: "Time To Take Medicine", msg: "-\(i.name!)", buttontitle: "Took", button2title: "Remind Me Later", ActionCompletion: {
                                    i.took = true
                                }) {
                                    i.took = false
                                    self.timerDic = ["msg":"-\(i.name!)","took":i.took]
                                    Timer.scheduledTimer(timeInterval: 60 * 5, target: self, selector: #selector(self.remind), userInfo: self.timerDic, repeats: true)
                                }
                            }
                        }
                    } else {
                        // Alert.shared.dismissAlert(vc: self)
                    }
                }
            }
        }*/
       
        return medicinecell
    }
    @objc func remind(timer: Timer){
        if let timerDic = timer.userInfo as? NSMutableDictionary {
            var took = timerDic["took"] as? Bool
            if took == false {
                if let msg = timerDic["msg"] as? String {
                    Alert.shared.ActionAlert(vc: self, title: "Time To Take Medicine", msg: msg, buttontitle: "Took", button2title: "Remind Me Later", ActionCompletion: {
                        self.took = true
                    }) {
                        self.took = false
                        Timer.scheduledTimer(timeInterval: 60 * 10, target: self, selector: #selector(self.remind), userInfo: ["msg":msg], repeats: true)
                    }
                }
            } else {
           //     Alert.shared.dismissAlert(vc: self)
            }
            
        }
    }
    
}
extension MedicineViewController: UIScrollViewDelegate {
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableview.contentOffset.y + tableview.frame.size.height) >= tableview.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
               // loadCallLogData(offset: self.offset, limit: self.limit)
            }
        }
    }
}

