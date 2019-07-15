//
//  NotificationController.swift
//  RemiderMedicineOnWatch Extension
//
//  Created by Nishikant Ashok UMBARKAR on 12/7/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class NotificationController: WKUserNotificationInterfaceController {

    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Void) {
        print("didReceive")
    }
    override func didReceiveRemoteNotification(_ remoteNotification: [AnyHashable : Any], withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Void) {
        print("didReceiveRemoteNotification")
    }
    override func handleAction(withIdentifier identifier: String?, forRemoteNotification remoteNotification: [AnyHashable : Any]) {
        print("handleAction")
    }
    
}
