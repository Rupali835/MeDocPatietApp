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
import WatchConnectivity

let CategoryIdentifier = "Medicines"
let SoonzeIdentifier = "Soonze"
let TakenIdentifier = "Taken Medicine"
let group = "group.com.kanishka.medocpatient"

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
    var routeFromOtherVC = false
    var getSelectedMedicine: ((_ data: NSArray)->Void)?
    var Prescriptiondata = NSArray()
    var alerttableview = UITableView()
    var editRadiusAlert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "Medicines".localized()
        tableview.sectionHeaderHeight = UITableView.automaticDimension
        tableview.estimatedSectionHeaderHeight = 50;
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddAction))

       // setupReminder()
        
        DispatchQueue.main.async {
            for medicine_type in self.image_Types_dataSource {
                let image = SVGKImage(named: medicine_type)?.uiImage
                image?.accessibilityIdentifier = medicine_type
                self.images_types.append(image)
            }
        }
        
        NetworkManager.isReachable { _ in
            self.fetchPrescription()
            self.fetchmedicine()
            self.navigationItem.rightBarButtonItem = add
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchPrescription()
            self.fetchmedicine()
            self.navigationItem.rightBarButtonItem = add
        }
        NetworkManager.isUnreachable { _ in
            Utilities.shared.centermsg(msg: "No Internet Connection", view: self.view)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloaddata), name: NSNotification.Name("reloaddata"), object: nil)
        
        self.tableview_Alert(title: "Select Prescription For Adding Medicine", msg: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reloaddata(){
        NetworkManager.isReachable { _ in
            self.fetchmedicine()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func tableview_Alert(title: String?,msg: String?){
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        alerttableview = UITableView(frame: CGRect(x: 0, y: 0, width: 250, height: 240))
        alerttableview.delegate = self
        alerttableview.dataSource = self
        vc.view.addSubview(alerttableview)
        editRadiusAlert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        editRadiusAlert.addAction(cancelAction)
    }
    func fetchPrescription(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "prescriptions", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let p_data = json.value(forKey: "data") as? NSArray{
                            self.Prescriptiondata = p_data
                        }
                    }
                }
            } catch {
                print("catch")
            }
        })
    }
    @objc func AddAction(){
        DispatchQueue.main.async {
            self.alerttableview.reloadData()
            self.present(self.editRadiusAlert, animated: true, completion:{})
        }
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
        
       // let url = AssetExtractor.createLocalUrl(forImageNamed: imagename!)
        
        let snoozeAction = UNNotificationAction(identifier: SoonzeIdentifier, title: "Snooze 15 Minute ⏱", options: [])
        let TakenAction = UNNotificationAction(identifier: TakenIdentifier, title: "Medicine Taken! 👍 ", options: [])

        let category = UNNotificationCategory(identifier: CategoryIdentifier, actions: [TakenAction,snoozeAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])

        for (i,date) in datecomponent.enumerated() {
            let requestidentifier = "notification.id-\(id)-\(i)"
            print("requestidentifier: \(requestidentifier)")
//            if let attachment = create(imageFileIdentifier: requestidentifier, data: UIImage(named: imagename!)?.pngData()! as! NSData, options: nil) {
//                content.attachments = [attachment]
//            }
//            if url != nil {
//                if let attachment = try? UNNotificationAttachment(identifier: requestidentifier, url: url!, options: nil) {
//                    content.attachments = [attachment]
//                }
//            }
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let request = UNNotificationRequest(identifier: requestidentifier, content: content, trigger: trigger)
            
            print("request: \(request)")
            UNUserNotificationCenter.current().add(request) {
                (error) in
                if error != nil {
                    print("Snooze Request Error: \(error?.localizedDescription)")
                }
            }
        }
        
    }
    func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        
        let tmpSubFolderName: String = ProcessInfo.processInfo.globallyUniqueString
        let fileURLPath: String = NSTemporaryDirectory()
        let tmpSubFolderURL: String = URL(fileURLWithPath: fileURLPath).appendingPathComponent(tmpSubFolderName).absoluteString
        
        if ((try? FileManager.default.createDirectory(atPath: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)) != nil) {
            let fileURL = URL(fileURLWithPath: tmpSubFolderURL).appendingPathComponent(imageFileIdentifier)
            data.write(to: fileURL, atomically: true)
            let attachment = try? UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
            return attachment!
        }
        return nil
        
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
                              //  self.passdataTowatch(bool: false)
                                DispatchQueue.main.async {
                                    if self.routeFromOtherVC == false {
                                        self.createNewReminder()
                                        self.passdataTowatch(bool: true)
                                    }
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
    func passdataTowatch(bool: Bool){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            print("App Count: \(notifications.count)")
            // send a message to the watch if it's reachable
            
            if bool == true {
                if (WCSession.default.isReachable) {
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: notifications, requiringSecureCoding: false)
                        let message = ["notification": data]
                        WCSession.default.sendMessage(message, replyHandler: nil)
                    } catch {
                        print("catch nskeyarchiever")
                    }
                }
            } else {
                for item in notifications {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(
                        withIdentifiers: [item.identifier])
                    print("App: \(item)")
                }
            }
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
                let Time_dates = GetBeforeAfterTime_Dates(mdata: mdata, startdate: date!)

                switch interval_type {
                case "1": //"Type: Daily"
                    let dueDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
                    if dueDate != nil {
                        if dueDate! >= Date() {
                            self.DailyNotification(dueDate: dueDate!, interval_time: interval_time, Startdate: date!, Time_dates: Time_dates, id: id, medicinename: medicinename, medicine_type: medicine_type, medicine_quantity: medicine_quantity, patient_problem: patient_problem)
                        }
                    }
                    break
                case "2": //"Type: Weekly"

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
                            self.TimeIntervalNotification(dueDate: dueDate!, interval_time: interval_time, Startdate: date!, Time_dates: Time_dates, id: id, medicinename: medicinename, medicine_type: medicine_type, medicine_quantity: medicine_quantity, patient_problem: patient_problem)
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
            let breakfastdate = Calendar.current.date(bySettingHour: 8, minute: 00, second: 00, of: timedate!)!
            let before_bfalarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_bf_time)!, to: breakfastdate)!
            Time_dates.append(before_bfalarmdate)
           // alarmdates.append(EKAlarm(absoluteDate: before_bfalarmdate))
        }
        
        let after_bf = "\(mdata.value(forKey: "after_bf") as! Int)"
        let after_bf_time = "\(mdata.value(forKey: "after_bf_time") as! Int)"
        
        if after_bf == "1" {
            let breakfastdate = Calendar.current.date(bySettingHour: 8, minute: 00, second: 00, of: timedate!)!
            let after_bfalarmdate = Calendar.current.date(byAdding: .minute, value: Int(after_bf_time)!, to: breakfastdate)!
            Time_dates.append(after_bfalarmdate)
          //  alarmdates.append(EKAlarm(absoluteDate: after_bfalarmdate))
        }
        
        let before_lunch = "\(mdata.value(forKey: "before_lunch") as! Int)"
        let before_lunch_time = "\(mdata.value(forKey: "before_lunch_time") as! Int)"
        
        if before_lunch == "1"{
            let lunchdate = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: timedate!)!
            let before_lunchalarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_lunch_time)!, to: lunchdate)!
            Time_dates.append(before_lunchalarmdate)
          //  alarmdates.append(EKAlarm(absoluteDate: before_lunchalarmdate))
        }
        
        let after_lunch = "\(mdata.value(forKey: "after_lunch") as! Int)"
        let after_lunch_time = "\(mdata.value(forKey: "after_lunch_time") as! Int)"
        
        if after_lunch == "1"{
            let lunchdate = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: timedate!)!
            let after_lunchalarmdate = Calendar.current.date(byAdding: .minute, value: Int(after_lunch_time)!, to: lunchdate)!
            Time_dates.append(after_lunchalarmdate)
          //  alarmdates.append(EKAlarm(absoluteDate: after_lunchalarmdate))
        }
        
        let before_dinner = "\(mdata.value(forKey: "before_dinner") as! Int)"
        let before_dinner_time = "\(mdata.value(forKey: "before_dinner_time") as! Int)"
        
        if before_dinner == "1"{
            let dinnerdate = Calendar.current.date(bySettingHour: 20, minute: 00, second: 00, of: timedate!)!
            let before_dinneralarmdate = Calendar.current.date(byAdding: .minute, value: -Int(before_dinner_time)!, to: dinnerdate)!
            Time_dates.append(before_dinneralarmdate)
         //   alarmdates.append(EKAlarm(absoluteDate: before_dinneralarmdate))
        }
        
        let after_dinner = "\(mdata.value(forKey: "after_dinner") as! Int)"
        let after_dinner_time = "\(mdata.value(forKey: "after_dinner_time") as! Int)"
        
        if after_dinner == "1"{
            let dinnerdate = Calendar.current.date(bySettingHour: 20, minute: 00, second: 00, of: timedate!)!
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
                
                print(component)
                DailyComponents.append(component)
            }
        }
        print(DailyComponents)
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
        
        var weekdayComponents = [DateComponents]()
        
        let datesBetweenArray = Date.dates(from: Startdate, to: dueDate)

        for date in datesBetweenArray {
            //print("dates: \(date)")
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
                    
                    weekdayComponents.append(component)
                }
            }
        }
        print(weekdayComponents)
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
            
            for (index,hour) in (1...24).enumerated() {
                let int_time = interval_time == "" ? 0 : Int(interval_time)!
                if index % int_time == 0{
                    print("time interval:\(hour)")
                    let DailyDate = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: date)
                    
                    var component = DateComponents()
                    component.day = DailyDate.day
                    component.month = DailyDate.month
                    component.year = DailyDate.year
                    component.hour = hour
                    component.minute = 0
                    component.second = 0
                    
                    IntervalComponents.append(component)
                }
            }
            
          /*  for time in Time_dates {
                let DailyDate = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: date)
                
                var component = DateComponents()
                component.day = DailyDate.day
                component.month = DailyDate.month
                component.year = DailyDate.year
                
                let int_time = interval_time == "" ? 0 : Int(interval_time)!
                var everytime = 0

                for i in 0...int_time {
                    print(i)
                    let addtime = Calendar.current.date(byAdding: .minute, value: everytime, to: time)!
                    
                    let Time = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: addtime)
                    print(Time)
                    
                    component.hour = Time.hour
                    component.minute = Time.minute
                    component.second = Time.second
                    
                    if i == int_time {
                        
                    } else {
                      //  if date >= Date(){
                            IntervalComponents.append(component)
                      //  }
                        everytime += 60
                    }
                }
                
            }*/
        }
        print(IntervalComponents)
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
        if tableView == self.alerttableview {
            return self.Prescriptiondata.count
        }
        if tableView == self.tableview {
            let md = self.medicineData.object(at: section) as! NSArray
            return md.count
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.alerttableview {
            return 1
        }
        if tableView == self.tableview {
            return self.prescription.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableview {
            let header = tableView.dequeueReusableCell(withIdentifier: "headercell") as! headercell
            let d = self.prescription.object(at: section) as! NSDictionary
            let patient_problem = d.value(forKey: "patient_problem") as! String
            header.titles.text = patient_problem
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.numberOfTouchesRequired = 1
            header.addGestureRecognizer(tapRecognizer)
            return header
        }
        return UIView(frame: .zero)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableview {
            return UITableView.automaticDimension
        }
        return 0
    }
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        print("Tapped")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.alerttableview  {
            return UITableView.automaticDimension
        }
        if tableView == self.tableview {
            return UITableView.automaticDimension
        }
        return 300
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.alerttableview {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            let data = self.Prescriptiondata.object(at: indexPath.row) as! NSDictionary
            let patient_id = data.value(forKey: "patient_id") as? String
            let name = data.value(forKey: "patient_problem") as? String
            cell.textLabel?.text = name!
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            return cell
        }
        if tableView == self.tableview {
            
            let medicinecell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineTableViewCell
            let md = self.medicineData.object(at: indexPath.section) as! NSArray
            let data = md.object(at: indexPath.row) as! NSDictionary
            
            timeslot.removeAll()
            
            medicinecell.SetCellData(d: data, images_types: self.images_types, indexPath: indexPath)
            
            return medicinecell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.alerttableview {
            let addMedicineVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
            addMedicineVC.images_types = self.images_types
            let data = self.Prescriptiondata.object(at: indexPath.row) as! NSDictionary
            let id = data.value(forKey: "id") as? Int ?? 0
            addMedicineVC.prescriptionID = id
            self.editRadiusAlert.dismiss(animated: true, completion: nil)
            navigationController?.pushViewControllerWithFlipAnimation(Self: self, pushVC: addMedicineVC)
            //self.present(addMedicineVC, animated: true, completion: nil)
        }
        if tableView == self.tableview {
            if self.routeFromOtherVC == true {
                let md = self.medicineData.object(at: indexPath.section) as! NSArray
                let data = md.object(at: indexPath.row) as! NSDictionary
                self.getSelectedMedicine?(md)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
