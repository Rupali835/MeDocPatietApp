//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Nishikant Ashok UMBARKAR on 12/7/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var _title: UILabel!
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var body: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        let split = content.subtitle.components(separatedBy: " - ")
        self._title?.text = content.title
        print(split[0])
        self.subtitle?.text = split[0]
        self.body?.text = content.body
        self.quantity?.text = split[1]
        self.imageview?.image = UIImage(named: split[0])
    }

}
