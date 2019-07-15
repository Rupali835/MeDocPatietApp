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

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var button: WKInterfaceButton!
    @IBOutlet weak var label: WKInterfaceLabel!
    var pending_notifications = [UNNotificationRequest]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    @IBAction func Action() {
        Pending_Notification()
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
       // UserDefaults(suiteName: "")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func Pending_Notification(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            self.pending_notifications = notifications
            self.label.setText("\(notifications.count)")
            print("Watch Count: \(notifications.count)")
            for item in notifications {
                //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.identifier])
                
                print("Watch Count: \(item)")
            }
        }
    }
    
    
}
