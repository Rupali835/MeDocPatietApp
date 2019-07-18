//
//  InterfaceController.swift
//  RemiderMedicineOnWatch Extension
//
//  Created by Nishikant Ashok UMBARKAR on 12/7/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications
import WatchConnectivity

class RowController: NSObject {
    @IBOutlet weak var medicinename: WKInterfaceLabel!
    @IBOutlet weak var medicinetype: WKInterfaceLabel!
    @IBOutlet weak var quantity: WKInterfaceLabel!
    @IBOutlet weak var time: WKInterfaceLabel!
}

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var refeshbutton: WKInterfaceButton!
    @IBOutlet weak var table: WKInterfaceTable!
    
    var pending_notifications = [UNNotificationRequest]()
    var session : WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //UserDefaults.standard.set(Data(), forKey: "pending_notification")
        // Configure interface objects here.
    }
    func Show_notification_list(){
        do {
            let data = UserDefaults.standard.data(forKey: "pending_notification")
            if data == nil {
                self.table.setNumberOfRows(0, withRowType: "RowController")
            } else {
                if let notification = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as? [UNNotificationRequest] {
                    
                    self.pending_notifications = notification.filter { (filterdata) in
                        let datecomponents = (filterdata.trigger as! UNCalendarNotificationTrigger).dateComponents
                        let triggerdate = Calendar.current.date(from: datecomponents)
                        return triggerdate! >= Date()
                    }
                    //self.pending_notifications = notification
                    print(self.pending_notifications)

                    self.Setup_tablerows()
                }
            }
        } catch {
            print("catch unarchiver")
        }
    }
    func Setup_tablerows(){
        self.table.setNumberOfRows(self.pending_notifications.count, withRowType: "RowController")
        
        for (index,item) in self.pending_notifications.enumerated() {
            if let rowControl = table.rowController(at: index) as? RowController {
                
                let content = item.content
                let subtitle_split = content.subtitle.components(separatedBy: " - ")
                
                let medicinename = content.title.replacingOccurrences(of: "Time to Take ", with: "")
                rowControl.medicinename.setText(medicinename)
                
                let medicinetype = subtitle_split[0]
                rowControl.medicinetype.setText(medicinetype)
                
                let medicineQuantity = subtitle_split[1]
                rowControl.quantity.setText(medicineQuantity)
                
                if let time = item.trigger as? UNCalendarNotificationTrigger {
                    let c = time.dateComponents
                    rowControl.time.setText("\(c.day!)/\(c.month!)/\(c.year!)   \(c.hour!):\(c.minute!)")
                }
            }
        }
    }
    @IBAction func refeshbuttonAction() {
        DispatchQueue.main.async {
            self.Show_notification_list()
        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
        pending_notifications = [UNNotificationRequest]()
        self.table.setNumberOfRows(0, withRowType: "RowController")
        Show_notification_list()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
//    func Pending_Notification(){
//        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
//            self.pending_notifications = notifications
//            print("Watch Count: \(notifications.count)")
//            for item in notifications {
//                //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.identifier])
//                
//                print("Watch Count: \(item)")
//            }
//        }
//    }
    
    
}
extension InterfaceController: WCSessionDelegate{
    
    // 4: Required stub for delegating session
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
      //  print(message)
        DispatchQueue.main.async {
            UserDefaults.standard.set(message["notification"], forKey: "pending_notification")
            UserDefaults.standard.synchronize()
            self.Show_notification_list()
        }
    }
}
