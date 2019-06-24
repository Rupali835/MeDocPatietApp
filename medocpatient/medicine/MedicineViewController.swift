//
//  MedicineViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import EventKit
import SVGKit

class MedicineViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    
    var medicineData = NSMutableArray()
    var prescription = NSMutableArray()
    var timeslot = [String]()
    let image_Types_dataSource = ["Capsules", "Cream", "Drops", "Gel", "Inhaler", "Injection", "Lotion", "Mouthwash", "Ointment", "Others", "Physiotherapy", "Powder", "Spray", "Suppository", "Syrup", "Tablet", "Treatment Session"]
    var images_types = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "Medicines".localized()
        tableview.sectionHeaderHeight = UITableView.automaticDimension
        tableview.estimatedSectionHeaderHeight = 50;
        
        setupReminder()
        
        DispatchQueue.main.async {
            for medicine_type in self.image_Types_dataSource {
                let image = SVGKImage(named: medicine_type)?.uiImage
                image?.accessibilityIdentifier = medicine_type
                self.images_types.append(image)
            }
        }
        
        NetworkManager.isReachable { _ in
            self.fetchmedicine()
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchmedicine()
        }
        NetworkManager.isUnreachable { _ in
            Utilities.shared.centermsg(msg: "No Internet Connection", view: self.view)
        }
        // Do any additional setup after loading the view.
    }
    func setupReminder(){
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        
        self.eventStore.requestAccess(to: EKEntityType.reminder) { (granted, error) in
            if granted {
                // 2
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: { (reminders) in
                    self.reminders = reminders
                })
            } else {
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
        }
    }
    func addreminderSetup(title: String,notes: String?,startdate: DateComponents?,duedate: DateComponents?,completiondate: Date?,alarmdates: [EKAlarm]?,recurrenceRule: [EKRecurrenceRule]?){
        let reminder = EKReminder(eventStore: self.eventStore)
        
        reminder.title = "Time to Take \(title)"
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        reminder.notes = "Cheif Complain: \(notes ?? "Not Mentioned")"
        reminder.startDateComponents = startdate
        reminder.dueDateComponents = duedate
        reminder.completionDate = nil
        reminder.alarms = alarmdates
        reminder.recurrenceRules = recurrenceRule
        
        do {
            try self.eventStore.save(reminder, commit: true)
        } catch {
            print("Error creating and saving new reminder : \(error)")
        }
    }
    func fetchmedicine(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Fetch Medicines..")
        ApiServices.shared.FetchPostDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "medicines", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                //print(json)
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let data = json.value(forKey: "data") as? NSArray{
                            let prescrip = data.value(forKey: "prescription_details") as! NSArray
                            if let medicines = data.value(forKey: "medicines") as? NSArray{
                                self.medicineData.removeAllObjects()
                                self.prescription.removeAllObjects()
                                for (index,med) in medicines.enumerated() {
                                    let count = medicines.object(at: index) as! NSArray
                                    if count.count == 0{
                                        
                                    } else {
                                        self.medicineData.add(med)
                                        self.prescription.add(prescrip[index])
                                    }
                                }
                                print("medicines-\(self.medicineData)")
                                print("prescription-\(self.prescription)")
                                for (index,remind) in self.reminders.enumerated() {
                                    if (remind.notes?.contains(find: "Cheif Complain:"))! {
                                        do {
                                            try self.eventStore.remove(remind, commit: true)
                                            print("Already Added Remove")
                                        } catch {
                                            print("catch")
                                        }
                                    }
                                }
                                self.createNewReminder()
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    Utilities.shared.RemoveLoaderView()
                    if self.medicineData.count == 0{
                        Utilities.shared.centermsg(msg: "You are fit, no medicine found for you", view: self.view)
                    } else {
                        Utilities.shared.removecentermsg()
                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.ActionToast(text: "Something Went Wrong", actionTitle: "Retry", actionHandler: {
                        self.fetchmedicine()
                    })
                }
            }
        }) { () -> (Dictionary<String, Any>) in
            ["all":"1"]
        }
    }
    func createNewReminder(){
        for (index,_) in self.medicineData.enumerated() {
            
            let p_data = self.prescription.object(at: index) as! NSDictionary
            let patient_problem = p_data.value(forKey: "patient_problem") as! String
            
            let mdataarr = self.medicineData.object(at: index) as! NSArray
            
            
            for (index,_) in mdataarr.enumerated() {
                var alreadyadded = false
                
                let mdata = mdataarr.object(at: index) as! NSDictionary
                let created_at = mdata.value(forKey: "created_at") as! String
                
                let medicinename = mdata.value(forKey: "medicine_name") as! String
                let medicine_type = "(\(mdata.value(forKey: "medicine_type") as! String))"
                let medicine_quantity = " - (Quantity: \(mdata.value(forKey: "medicine_quantity") as! String))"
//
//                for (index,remind) in self.reminders.enumerated() {
//                    if remind.notes == "Cheif Complain: \(patient_problem)" && (remind.title?.contains(find: medicinename))!{
//                        do {
//                            try self.eventStore.remove(remind, commit: true)
//                            self.reminders.remove(at: index)
//                            alreadyadded = false
//                            print("Already Added Remove")
//                        } catch {
//                            print("catch")
//                            print("Already Added")
//                            alreadyadded = true
//                        }
//                        break;
//                    }
//                }
                var alarmdates = [EKAlarm]()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: created_at)
                
                let interval_type = "\(mdata.value(forKey: "interval_type") as! Int)"
                let interval_period = "\(mdata.value(forKey: "interval_period") as! Int)"
                let interval_time = "\(mdata.value(forKey: "interval_time") as! String)"
                
                let before_bf = "\(mdata.value(forKey: "before_bf") as! Int)"
                let before_bf_time = "\(mdata.value(forKey: "before_bf_time") as! Int)"
                
                let timedate = Calendar.current.date(byAdding: .day, value: -1, to: date!)
                
                if before_bf == "1"{
                    let breakfastdate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: timedate!)!
                    let before_bfalarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_bf_time)!, to: breakfastdate)!
                    alarmdates.append(EKAlarm(absoluteDate: before_bfalarmdate))
                }
                
                let after_bf = "\(mdata.value(forKey: "after_bf") as! Int)"
                let after_bf_time = "\(mdata.value(forKey: "after_bf_time") as! Int)"
                
                if after_bf == "1" {
                    let breakfastdate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: timedate!)!
                    let after_bfalarmdate = Calendar.current.date(byAdding: .minute, value: Int(after_bf_time)!, to: breakfastdate)!
                    alarmdates.append(EKAlarm(absoluteDate: after_bfalarmdate))
                }
                
                let before_lunch = "\(mdata.value(forKey: "before_lunch") as! Int)"
                let before_lunch_time = "\(mdata.value(forKey: "before_lunch_time") as! Int)"
                
                if before_lunch == "1"{
                    let lunchdate = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: timedate!)!
                    let before_lunchalarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_lunch_time)!, to: lunchdate)!
                    alarmdates.append(EKAlarm(absoluteDate: before_lunchalarmdate))
                }
                
                let after_lunch = "\(mdata.value(forKey: "after_lunch") as! Int)"
                let after_lunch_time = "\(mdata.value(forKey: "after_lunch_time") as! Int)"
                
                if after_lunch == "1"{
                    let lunchdate = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: timedate!)!
                    let after_lunchalarmdate = Calendar.current.date(byAdding: .minute, value: Int(after_lunch_time)!, to: lunchdate)!
                    alarmdates.append(EKAlarm(absoluteDate: after_lunchalarmdate))
                }
                
                let before_dinner = "\(mdata.value(forKey: "before_dinner") as! Int)"
                let before_dinner_time = "\(mdata.value(forKey: "before_dinner_time") as! Int)"
                
                if before_dinner == "1"{
                    let dinnerdate = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: timedate!)!
                    let before_dinneralarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_dinner_time)!, to: dinnerdate)!
                    alarmdates.append(EKAlarm(absoluteDate: before_dinneralarmdate))
                }
                
                let after_dinner = "\(mdata.value(forKey: "after_dinner") as! Int)"
                let after_dinner_time = "\(mdata.value(forKey: "after_dinner_time") as! Int)"
                
                if after_dinner == "1"{
                    let dinnerdate = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: timedate!)!
                    let after_dinneralarmdate = Calendar.current.date(byAdding: .minute, value: Int(after_dinner_time)!, to: dinnerdate)!
                    alarmdates.append(EKAlarm(absoluteDate: after_dinneralarmdate))
                }
                
                if alreadyadded == false {
                    print("Adding Reminder")
                    
                    let startDatecomponent = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: date!)
                    
                    switch interval_type {
                    case "1":
                        let dueDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
                        
                        let dueDatecomponent = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: dueDate!)
                        
                        self.addreminderSetup(title: medicinename + medicine_type + medicine_quantity,
                                              notes: patient_problem,
                                              startdate: startDatecomponent,
                                              duedate: dueDatecomponent,
                                              completiondate: dueDate,
                                              alarmdates: alarmdates,
                                              recurrenceRule: [EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: EKRecurrenceEnd(end: dueDate!))])
                        break
                        //medicinecell.interval_type.text = "Type: Daily"
                    case "2":
                        let dueDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)! * 7, to: date!)
                        
                        let dueDatecomponent = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: dueDate!)
                        
                        var daysofWeek = [EKRecurrenceDayOfWeek]()
                        
                        switch Int(interval_time)!{
                            case 1:
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
                                break;
                            case 2:
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.tuesday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
                                break;
                            case 3:
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
                                break;
                            case 4:
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.sunday))
                                break;
                            case 5:
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.sunday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.saturday))
                                break;
                            case 6:
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.sunday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.tuesday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.thursday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.saturday))
                                break;
                            case 7:
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.sunday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.tuesday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.thursday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
                                daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.saturday))
                                break;
                            default:
                                break;
                        }
                        
                        self.addreminderSetup(title: medicinename + medicine_type + medicine_quantity,
                                              notes: patient_problem,
                                              startdate: startDatecomponent,
                                              duedate: dueDatecomponent,
                                              completiondate: dueDate,
                                              alarmdates: alarmdates,
                                              recurrenceRule:
                            [EKRecurrenceRule(recurrenceWith: .weekly,
                                              interval: Int(interval_period)!,
                                              daysOfTheWeek: daysofWeek,
                                              daysOfTheMonth: nil,
                                              monthsOfTheYear: nil,
                                              weeksOfTheYear: nil,
                                              daysOfTheYear: nil,
                                              setPositions: nil,
                                              end: EKRecurrenceEnd(end: dueDate!))])
                        break
                       // medicinecell.interval_type.text = "Type: Weekly"
                    case "3":
                        let dueDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
                        
                        let dueDatecomponent = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: dueDate!)
                        
                        self.addreminderSetup(title: medicinename + medicine_type + medicine_quantity + " " + " \(interval_time) Times in a day",
                                              notes: patient_problem,
                                              startdate: startDatecomponent,
                                              duedate: dueDatecomponent,
                                              completiondate: dueDate,
                                              alarmdates: alarmdates,
                                              recurrenceRule: [EKRecurrenceRule(recurrenceWith: .daily, interval: Int(interval_period)!, end: EKRecurrenceEnd(end: dueDate!))])
                        break
                      //  medicinecell.interval_type.text = "Type: Time interval"
                    default:
                        break
                    }

                }
            }
        }
    }
}
extension MedicineViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let md = self.medicineData.object(at: section) as! NSArray
        return md.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.prescription.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "headercell") as! headercell
        let d = self.prescription.object(at: section) as! NSDictionary
        let patient_problem = d.value(forKey: "patient_problem") as! String
        header.titles.text = patient_problem
        return header
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicinecell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineTableViewCell
        let md = self.medicineData.object(at: indexPath.section) as! NSArray
        
        self.timeslot.removeAll()
        let d = md.object(at: indexPath.row) as! NSDictionary
        
        let name = d.value(forKey: "medicine_name") as! String
        let medicine_type = d.value(forKey: "medicine_type") as! String
        let medicine_quantity = d.value(forKey: "medicine_quantity") as! String
        
        let before_bf = "\(d.value(forKey: "before_bf") as! Int)"
        let before_bf_time = "\(d.value(forKey: "before_bf_time") as! Int)"
        if before_bf == "1"{
            if !self.timeslot.contains("Before \(before_bf_time) minute Of Breakfast"){
                if before_bf_time == "0" {
                    self.timeslot.append("Before Breakfast")
                } else {
                    self.timeslot.append("Before \(before_bf_time) minute Of Breakfast")
                }
            }
        }
        
        let after_bf = "\(d.value(forKey: "after_bf") as! Int)"
        let after_bf_time = "\(d.value(forKey: "after_bf_time") as! Int)"
        if after_bf == "1"{
            if !self.timeslot.contains("After \(after_bf_time) minute Of Breakfast"){
                if after_bf_time == "0" {
                    self.timeslot.append("After Breakfast")
                } else {
                    self.timeslot.append("After \(after_bf_time) minute Of Breakfast")
                }
            }
        }
        
        let before_lunch = "\(d.value(forKey: "before_lunch") as! Int)"
        let before_lunch_time = "\(d.value(forKey: "before_lunch_time") as! Int)"
        if before_lunch == "1"{
            if !self.timeslot.contains("Before \(before_lunch_time) minute Of Lunch"){
                if before_lunch_time == "0" {
                    self.timeslot.append("Before  Lunch")
                } else {
                    self.timeslot.append("Before \(before_lunch_time) minute Of Lunch")
                }
            }
        }
        
        let after_lunch = "\(d.value(forKey: "after_lunch") as! Int)"
        let after_lunch_time = "\(d.value(forKey: "after_lunch_time") as! Int)"
        if after_lunch == "1"{
            if !self.timeslot.contains("After \(after_lunch_time) minute Of Lunch"){
                if after_lunch_time == "0" {
                    self.timeslot.append("After Lunch")
                } else {
                    self.timeslot.append("After \(after_lunch_time) minute Of Lunch")
                }
            }
        }
        
        let before_dinner = "\(d.value(forKey: "before_dinner") as! Int)"
        let before_dinner_time = "\(d.value(forKey: "before_dinner_time") as! Int)"
        if before_dinner == "1"{
            if !self.timeslot.contains("Before \(before_dinner_time) minute Of Dinner"){
                if before_dinner_time == "0" {
                    self.timeslot.append("Before Dinner")
                } else {
                    self.timeslot.append("Before \(before_dinner_time) minute Of Dinner")
                }
            }
        }
        
        let after_dinner = "\(d.value(forKey: "after_dinner") as! Int)"
        let after_dinner_time = "\(d.value(forKey: "after_dinner_time") as! Int)"
        if after_dinner == "1"{
            if !self.timeslot.contains("After \(after_dinner_time) minute Of Dinner"){
                if after_dinner_time == "0" {
                    self.timeslot.append("After Dinner")
                } else {
                    self.timeslot.append("After \(after_dinner_time) minute Of Dinner")
                }
            }
        }
        
        let interval_period = "\(d.value(forKey: "interval_period") as! Int)"
        let interval_time = d.value(forKey: "interval_time") as! String
        let interval_type = "\(d.value(forKey: "interval_type") as! Int)"
        
        switch interval_type {
        case "1":
            medicinecell.interval_type.text = "Daily - (Quantity: \(medicine_quantity))"
            medicinecell.interval_period.text = "Period: \(interval_period) days"
            medicinecell.interval_time.text = "";
        case "2":
            medicinecell.interval_type.text = "Weekly - (Quantity: \(medicine_quantity))"
            medicinecell.interval_period.text = "Period: \(interval_period) weeks"
            medicinecell.interval_time.text = "Times: \(interval_time) times in a week";
        case "3":
            medicinecell.interval_type.text = "Time interval - (Quantity: \(medicine_quantity))"
            medicinecell.interval_period.text = "Period: \(interval_period) days"
            medicinecell.interval_time.text = "Times: \(interval_time) times in a day";
        default:
            medicinecell.interval_type.text = ""
            medicinecell.interval_period.text = ""
            medicinecell.interval_time.text = ""
        }
        medicinecell.name.text = name //+ "(\(medicine_type))"
        medicinecell.type.text = medicine_type
        
        for (index,item) in self.images_types.enumerated() {
            if item?.accessibilityIdentifier == medicine_type {
                medicinecell.img_type.image = item
            }
        }
        
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
        
        if breakfast == 0 && lunch == 0 && dinner == 0 {
            medicinecell.timeslot.text = ""
            medicinecell.beforeaftertime.text = ""
        } else {
            medicinecell.timeslot.text = "\(breakfast)-\(lunch)-\(dinner)"
            medicinecell.beforeaftertime.text = "# \(self.timeslot.joined(separator: "\n# "))"
        }
        
        let created_at = d.value(forKey: "created_at") as! String
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: created_at)
        
        let df1 = DateFormatter()
        df1.dateFormat = "dd MMM yyyy HH:mm:ss"
        let datestr = df1.string(from: date!)
        
        let Start_dateSeparate = datestr.components(separatedBy: .whitespaces)
        
        medicinecell.start_date.text = Start_dateSeparate[0]
        medicinecell.start_month.text = Start_dateSeparate[1]
        medicinecell.start_year.text = Start_dateSeparate[2]
       // medicinecell.start_time.text = dateSeparate[3]
        
        var endDate: Date?
        
        switch interval_type {
        case "1":
            endDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
        case "2":
            endDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)! * 7, to: date!)
        case "3":
            endDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
        default:
            break;
        }
        
        if endDate != nil {
            let df1 = DateFormatter()
            df1.dateFormat = "dd MMM yyyy HH:mm:ss"
            let datestr = df1.string(from: endDate!)
            
            let End_dateSeparate = datestr.components(separatedBy: .whitespaces)
            
            medicinecell.end_date.text = End_dateSeparate[0]
            medicinecell.end_month.text = End_dateSeparate[1]
            medicinecell.end_year.text = End_dateSeparate[2]
            // medicinecell.end_time.text = dateSeparate[3]
        }
        
        return medicinecell
    }
}
