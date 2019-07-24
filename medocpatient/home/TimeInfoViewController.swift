//
//  TimeInfoViewController.swift
//  medocpatient
//
//  Created by iAM on 21/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import UserNotifications
import WatchConnectivity

class TimeInfoViewController: UIViewController {

    @IBOutlet var lbl_headertitle : UILabel!
    @IBOutlet var lbl_breakfast: UILabel!
    @IBOutlet var lbl_lunch: UILabel!
    @IBOutlet var lbl_dinner: UILabel!
    @IBOutlet var btn_ok: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_headertitle.text = "Standard Meal Timing Chart".localized()
        lbl_breakfast.text = "Breakfast Time is 8AM".localized()
        lbl_lunch.text = "Lunch Time is 1PM".localized()
        lbl_dinner.text = "Dinner Time is 8PM".localized()
        btn_ok.setTitle("OK".localized(), for: .normal)
        // Do any additional setup after loading the view.
    }
//    override func viewDidAppear(_ animated: Bool) {
//        setlocal()
//    }
    @IBAction func ok(){
        self.dismiss(animated: true, completion: nil)
    }
    func passdataTowatch(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            print("App Count: \(notifications.count)")
            // send a message to the watch if it's reachable
            
            if (WCSession.default.isReachable) {
                // this is a meaningless message, but it's enough for our purposes
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: notifications, requiringSecureCoding: false)
                    let message = ["notification": data]
                    WCSession.default.sendMessage(message, replyHandler: nil)
                } catch {
                    print("catch nskeyarchiever")
                }
            }
            for item in notifications {
                UNUserNotificationCenter.current().removePendingNotificationRequests(
                withIdentifiers: [item.identifier])
                print("App: \(item)")
            }
        }
    }
    func setlocal(){
        let currentDate = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: Date())
        
        var datecomponenets1 = DateComponents()
        datecomponenets1.day = currentDate.day!
        datecomponenets1.month = currentDate.month
        datecomponenets1.year = currentDate.year
        datecomponenets1.hour = currentDate.hour
        datecomponenets1.minute = currentDate.minute
        datecomponenets1.second = currentDate.second! + 10
        
        LocaladdnotificationSetup(datecomponent: datecomponenets1)
    }
    func LocaladdnotificationSetup(datecomponent: DateComponents){
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Take insulate"
        content.subtitle = "Capsules - (Quantity: 1)"
        content.body = "Cheif Complain: Neck Pain"
        content.categoryIdentifier = CategoryIdentifier
        
        let snoozeAction = UNNotificationAction(identifier: SoonzeIdentifier, title: "Snooze 15 Minute ⏱", options: [])
        let TakenAction = UNNotificationAction(identifier: TakenIdentifier, title: "Medicine Taken! 👍", options: [])
        
        let category = UNNotificationCategory(identifier: CategoryIdentifier, actions: [TakenAction,snoozeAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let requestidentifier = "notification.id-43-0"
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: false)
        let request = UNNotificationRequest(identifier: requestidentifier, content: content, trigger: trigger)
        print(request)
        
        UNUserNotificationCenter.current().add(request){ (error) in
            if error != nil {
                print("Request Error: \(error?.localizedDescription)")
            }
        }
        
    }
}
