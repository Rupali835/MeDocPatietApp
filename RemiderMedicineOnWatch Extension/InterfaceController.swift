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
    let def = UserDefaults(suiteName: "group.com.kanishka.medocpatient")
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //UserDefaults.standard.set(Data(), forKey: "pending_notification")
        // Configure interface objects here.
    }
    func Show_notification_list(){
        do {
            let data = def?.data(forKey: "pending_notification")
            if data == nil {
                self.table.setNumberOfRows(0, withRowType: "RowController")
            } else {
                if let notification = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as? [UNNotificationRequest] {
                    
                    var filter = notification.filter { (filterdata) in
                        let datecomponents = (filterdata.trigger as! UNCalendarNotificationTrigger).dateComponents
                        let triggerdate = Calendar.current.date(from: datecomponents)
                        return triggerdate! >= Date()
                    }
                    
                    let sort = filter.sorted {
                        Calendar.current.date(from: ($0.trigger! as! UNCalendarNotificationTrigger).dateComponents)!.compare(Calendar.current.date(from: ($1.trigger! as! UNCalendarNotificationTrigger).dateComponents)!) == .orderedAscending
                    }
                    
                    self.pending_notifications = sort
                    //self.pending_notifications = notification
                    print(self.pending_notifications.count)

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
                    let date = Calendar.current.date(from: c)
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mm a 'on' dd/MM/yy"
                    formatter.amSymbol = "AM"
                    formatter.pmSymbol = "PM"
                    
                    let dateString = formatter.string(from: date!)
                    print(dateString)
                    rowControl.time.setText(dateString)
                    //rowControl.time.setText("\(c.day!)/\(c.month!)/\(c.year!)   \(c.hour!):\(c.minute!)")
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
            self.def?.set(message["notification"], forKey: "pending_notification")
            self.def?.synchronize()
            self.Show_notification_list()
        }
    }
}
