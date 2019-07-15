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
import UserNotifications

let CategoryIdentifier = "Medicines"
let SoonzeIdentifier = "Soonze"
let TakenIdentifier = "Taken Medicine"

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
        
       // setupReminder()
        
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
    func LocaladdnotificationSetup(id: Int,title: String?,subtitle: String?,body: String?,imagename: String?,datecomponent: [DateComponents]){
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Take \(title ?? "")"
        content.subtitle = subtitle ?? ""
        content.body = "Cheif Complain: \(body ?? "Not Mentioned")"
        content.categoryIdentifier = CategoryIdentifier
    
        let url = AssetExtractor.createLocalUrl(forImageNamed: imagename!)
        
        let snoozeAction = UNNotificationAction(identifier: SoonzeIdentifier, title: "Snooze 5 Minute ⏱", options: [])
        let TakenAction = UNNotificationAction(identifier: TakenIdentifier, title: "Medicine Taken! 👍 ", options: [])

        let category = UNNotificationCategory(identifier: CategoryIdentifier, actions: [TakenAction,snoozeAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])

       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        for (i,date) in datecomponent.enumerated() {
            let requestidentifier = "notification.id-\(id)-\(i)"
            if url != nil {
                if let attachment = try? UNNotificationAttachment(identifier: requestidentifier, url: url!, options: nil) {
                    content.attachments = [attachment]
                }
            }
            
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let request = UNNotificationRequest(identifier: "notification.id-\(id)-\(i)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
//                                for (index,remind) in self.reminders.enumerated() {
//                                    if (remind.notes?.contains(find: "Cheif Complain:"))! {
//                                        do {
//                                            try self.eventStore.remove(remind, commit: true)
//                                            print("Already Added Remove")
//                                        } catch {
//                                            print("catch")
//                                        }
//                                    }
//                                }
                                DispatchQueue.main.async {
                                    self.createNewReminder()
                                }
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
                
                let mdata = mdataarr.object(at: index) as! NSDictionary
                let created_at = mdata.value(forKey: "created_at") as! String
                
                let id = mdata.value(forKey: "id") as? Int ?? 0
                let medicinename = mdata.value(forKey: "medicine_name") as! String
                let medicine_type = "\(mdata.value(forKey: "medicine_type") as! String)"
                let medicine_quantity = " - (Quantity: \(mdata.value(forKey: "medicine_quantity") as! String))"
                
               // var alarmdates = [EKAlarm]()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: created_at)
                
                let interval_type = "\(mdata.value(forKey: "interval_type") as! Int)"
                let interval_period = "\(mdata.value(forKey: "interval_period") as! Int)"
                let interval_time = "\(mdata.value(forKey: "interval_time") as! String)"
                
                let startDatecomponent = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: date!)
                
                switch interval_type {
                case "1": //"Type: Daily"
                    let dueDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
                    if dueDate != nil {
                        if dueDate! >= Date() {
                            
                        }
                    }
                    break
                case "2": //"Type: Weekly"
                    let Time_dates = GetBeforeAfterTime_Dates(mdata: mdata, startdate: date!)

                    let dueDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)! * 7, to: date!)
                    if dueDate != nil {
                        if dueDate! >= Date() {
                            self.WeeklyNotification(dueDate: dueDate!, interval_time: interval_time, Startdate: date!, Time_dates: Time_dates, id: id, medicinename: medicinename, medicine_type: medicine_type, medicine_quantity: medicine_quantity, patient_problem: patient_problem)
                        }
                    }
                    break
                case "3": //"Type: Time interval"
                    let dueDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
                    if dueDate != nil {
                        if dueDate! >= Date() {
                            
                        }
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    func GetBeforeAfterTime_Dates(mdata: NSDictionary,startdate: Date)->[Date]{
        var Time_dates = [Date]()

        let before_bf = "\(mdata.value(forKey: "before_bf") as! Int)"
        let before_bf_time = "\(mdata.value(forKey: "before_bf_time") as! Int)"
        
        let timedate = Calendar.current.date(byAdding: .day, value: -1, to: startdate)
        
        if before_bf == "1"{
            let breakfastdate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: timedate!)!
            let before_bfalarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_bf_time)!, to: breakfastdate)!
            Time_dates.append(before_bfalarmdate)
           // alarmdates.append(EKAlarm(absoluteDate: before_bfalarmdate))
        }
        
        let after_bf = "\(mdata.value(forKey: "after_bf") as! Int)"
        let after_bf_time = "\(mdata.value(forKey: "after_bf_time") as! Int)"
        
        if after_bf == "1" {
            let breakfastdate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: timedate!)!
            let after_bfalarmdate = Calendar.current.date(byAdding: .minute, value: Int(after_bf_time)!, to: breakfastdate)!
            Time_dates.append(after_bfalarmdate)
          //  alarmdates.append(EKAlarm(absoluteDate: after_bfalarmdate))
        }
        
        let before_lunch = "\(mdata.value(forKey: "before_lunch") as! Int)"
        let before_lunch_time = "\(mdata.value(forKey: "before_lunch_time") as! Int)"
        
        if before_lunch == "1"{
            let lunchdate = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: timedate!)!
            let before_lunchalarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_lunch_time)!, to: lunchdate)!
            Time_dates.append(before_lunchalarmdate)
          //  alarmdates.append(EKAlarm(absoluteDate: before_lunchalarmdate))
        }
        
        let after_lunch = "\(mdata.value(forKey: "after_lunch") as! Int)"
        let after_lunch_time = "\(mdata.value(forKey: "after_lunch_time") as! Int)"
        
        if after_lunch == "1"{
            let lunchdate = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: timedate!)!
            let after_lunchalarmdate = Calendar.current.date(byAdding: .minute, value: Int(after_lunch_time)!, to: lunchdate)!
            Time_dates.append(after_lunchalarmdate)
          //  alarmdates.append(EKAlarm(absoluteDate: after_lunchalarmdate))
        }
        
        let before_dinner = "\(mdata.value(forKey: "before_dinner") as! Int)"
        let before_dinner_time = "\(mdata.value(forKey: "before_dinner_time") as! Int)"
        
        if before_dinner == "1"{
            let dinnerdate = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: timedate!)!
            let before_dinneralarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_dinner_time)!, to: dinnerdate)!
            Time_dates.append(before_dinneralarmdate)
         //   alarmdates.append(EKAlarm(absoluteDate: before_dinneralarmdate))
        }
        
        let after_dinner = "\(mdata.value(forKey: "after_dinner") as! Int)"
        let after_dinner_time = "\(mdata.value(forKey: "after_dinner_time") as! Int)"
        
        if after_dinner == "1"{
            let dinnerdate = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: timedate!)!
            let after_dinneralarmdate = Calendar.current.date(byAdding: .minute, value: Int(after_dinner_time)!, to: dinnerdate)!
            Time_dates.append(after_dinneralarmdate)
        //    alarmdates.append(EKAlarm(absoluteDate: after_dinneralarmdate))
        }
        return Time_dates
    }
    func DailyNotification(dueDate: Date,interval_time: String,Startdate: Date,Time_dates: [Date],id: Int,medicinename: String,medicine_type: String,medicine_quantity: String,patient_problem: String){
        
        let dueDatecomponent = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: dueDate)
        
        print("Adding Daily Reminder")
        var DailyComponents = [DateComponents]()
        
        let datesBetweenArray = Date.dates(from: Startdate, to: dueDate)
        
        for date in datesBetweenArray {
            print("dates: \(date)")
            
            for time in Time_dates {
                let DailyDate = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: date)
                let Time = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: time)
                
                var component = DateComponents()
                component.day = DailyDate.day
                component.month = DailyDate.month
                component.year = DailyDate.year
                component.hour = Time.hour
                component.minute = Time.minute
                component.second = Time.second
                
                if date >= Date(){
                    DailyComponents.append(component)
                }
            }
        }
        
        self.LocaladdnotificationSetup(id: id, title: medicinename, subtitle: medicine_type + medicine_quantity, body: patient_problem, imagename: medicine_type, datecomponent: DailyComponents)
        
//        self.addreminderSetup(title: medicinename + medicine_type + medicine_quantity,
//                              notes: patient_problem,
//                              startdate: startDatecomponent,
//                              duedate: dueDatecomponent,
//                              completiondate: dueDate,
//                              alarmdates: alarmdates,
//                              recurrenceRule: [EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: EKRecurrenceEnd(end: dueDate!))])
        
    }
    func WeeklyNotification(dueDate: Date,interval_time: String,Startdate: Date,Time_dates: [Date],id: Int,medicinename: String,medicine_type: String,medicine_quantity: String,patient_problem: String){
        
        var dueDatecomponent = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: dueDate)
        
        var daysofWeek = [EKRecurrenceDayOfWeek]()
        var weekdays = [Int]()
        
        switch Int(interval_time)!{
        case 1:
           // daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
            weekdays = [4]
            break;
        case 2:
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.tuesday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
            weekdays = [3,6]
            break;
        case 3:
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
            weekdays = [2,4,6]
            break;
        case 4:
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.sunday))
            weekdays = [2,4,6,1]
            break;
        case 5:
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.sunday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.saturday))
            weekdays = [1,2,4,6,7]
            break;
        case 6:
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.sunday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.tuesday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.thursday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.saturday))
            weekdays = [1,2,3,5,6,7]
            break;
        case 7:
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.sunday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.monday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.tuesday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.wednesday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.thursday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.friday))
//            daysofWeek.append(EKRecurrenceDayOfWeek(EKWeekday.saturday))
            weekdays = [1,2,3,4,5,6,7]
            break;
        default:
            break;
        }
        
        print("Adding Weekly Reminder")
        var weekdayComponents = [DateComponents]()
        
        let datesBetweenArray = Date.dates(from: Startdate, to: dueDate)

        for date in datesBetweenArray {
            print("dates: \(date)")
            let weekday = Calendar.current.component(.weekday, from: date)
            
            if weekdays.contains(weekday) {
                print("weekday date: \(date)")
                for time in Time_dates {
                    let weekdayDate = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: date)
                    let Time = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: time)

                    var component = DateComponents()
                    component.day = weekdayDate.day
                    component.month = weekdayDate.month
                    component.year = weekdayDate.year
                    component.hour = Time.hour
                    component.minute = Time.minute
                    component.second = Time.second
                    
                    if date >= Date(){
                        weekdayComponents.append(component)
                    }
                }
            }
        }
        
        self.LocaladdnotificationSetup(id: id, title: medicinename, subtitle: medicine_type + medicine_quantity, body: patient_problem, imagename: medicine_type, datecomponent: weekdayComponents)
        
//        self.addreminderSetup(title: medicinename + medicine_type + medicine_quantity,
//                              notes: patient_problem,
//                              startdate: startDatecomponent,
//                              duedate: dueDatecomponent,
//                              completiondate: dueDate,
//                              alarmdates: alarmdates,
//                              recurrenceRule:
//            [EKRecurrenceRule(recurrenceWith: .weekly,
//                              interval: Int(interval_period)!,
//                              daysOfTheWeek: daysofWeek,
//                              daysOfTheMonth: nil,
//                              monthsOfTheYear: nil,
//                              weeksOfTheYear: nil,
//                              daysOfTheYear: nil,
//                              setPositions: nil,
//                              end: EKRecurrenceEnd(end: dueDate!))])
    }
    func TimeIntervalNotification(dueDate: Date,interval_time: String,Startdate: Date,Time_dates: [Date],id: Int,medicinename: String,medicine_type: String,medicine_quantity: String,patient_problem: String){
        
        let dueDatecomponent = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: dueDate)
        
        print("Adding Time Interval Reminder")
        var IntervalComponents = [DateComponents]()
        
        let datesBetweenArray = Date.dates(from: Startdate, to: dueDate)
        
        for date in datesBetweenArray {
            print("dates: \(date)")
            
            for time in Time_dates {
                let DailyDate = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: date)
                
                var component = DateComponents()
                component.day = DailyDate.day
                component.month = DailyDate.month
                component.year = DailyDate.year
                
                let int_time = interval_time == "" ? 0 : Int(interval_time)!
                
                var eachtime = 0
                
                for _ in 0...int_time {
                    
                    let addtime = Calendar.current.date(byAdding: .minute, value: eachtime, to: time)!
                    
                    let Time = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: addtime)
                    
                    component.hour = Time.hour
                    component.minute = Time.minute
                    component.second = Time.second
                    
                    eachtime += 15
                }
                
                if date >= Date(){
                    IntervalComponents.append(component)
                }
            }
        }
        
        self.LocaladdnotificationSetup(id: id, title: medicinename, subtitle: medicine_type + medicine_quantity, body: patient_problem, imagename: medicine_type, datecomponent: IntervalComponents)
        
//        self.addreminderSetup(title: medicinename + medicine_type + medicine_quantity + " " + " \(interval_time) Times in a day",
//            notes: patient_problem,
//            startdate: startDatecomponent,
//            duedate: dueDatecomponent,
//            completiondate: dueDate,
//            alarmdates: alarmdates,
//            recurrenceRule: [EKRecurrenceRule(recurrenceWith: .daily, interval: Int(interval_period)!, end: EKRecurrenceEnd(end: dueDate!))])
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
        let data = md.object(at: indexPath.row) as! NSDictionary
        
        timeslot.removeAll()

        medicinecell.SetCellData(d: data, images_types: self.images_types, indexPath: indexPath)
        
        return medicinecell
    }
}
