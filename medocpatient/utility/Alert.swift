//
//  Alert.swift
//  Perfecto
//
//  Created by Prem Sahni on 24/10/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static let shared : Alert = Alert()
    private init() {}
    var alertcontroller = UIAlertController()

    func basicalert(vc: UIViewController,title: String,msg: String){
        let alertcontroller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(ok)
        vc.present(alertcontroller, animated: true, completion: nil)
    }
    func internetoffline(vc: UIViewController){
        Alert.shared.basicalert(vc: vc, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
    }
    func dismissAlert(vc: UIViewController){
        vc.dismiss(animated: true, completion: nil)
    }
    func checkIfAlertViewHasPresented() -> UIAlertController? {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if topController is UIAlertController {
                return (topController as! UIAlertController)
            } else {
                return nil
            }
        }
        return nil
    }
    func ActionAlert(vc: UIViewController,title: String,msg: String,buttontitle: String,button2title: String,ActionCompletion: @escaping () -> (),Action2Completion: @escaping () -> ()){
        if (checkIfAlertViewHasPresented() != nil) {

        } else {
 
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1
            alertWindow.backgroundColor = UIColor.clear

            let alertcontroller = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let titleFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 18.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 15.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: msg, attributes: messageFont)
            
            alertcontroller.setValue(titleAttrString, forKey: "attributedTitle")
            alertcontroller.setValue(messageAttrString, forKey: "attributedMessage")

            alertcontroller.view.backgroundColor = UIColor.clear
        
            let button2 = UIAlertAction(title: button2title, style: .cancel) { (action) in
                Action2Completion()
            }
            let button1 = UIAlertAction(title: buttontitle, style: .default, image: #imageLiteral(resourceName: "like.png").withRenderingMode(.alwaysOriginal)) { (action) in
                ActionCompletion()
            }
           // button1.setValue(#imageLiteral(resourceName: "like.png"), forKey: "image")
            alertcontroller.addAction(button1)
            alertcontroller.addAction(button2)
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertcontroller, animated: true, completion: nil)
        }
        //    vc.present(alertcontroller, animated: true, completion: nil)
    }
    func RejectReason(vc: UIViewController,title: String,msg: String,ActionCompletion: @escaping () -> ()){
        let alertcontroller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertcontroller.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Remark"
            textfield.delegate = vc as? UITextFieldDelegate
            textfield.clearButtonMode = .whileEditing
            textfield.frame.size.height = 50
            textfield.backgroundColor = UIColor.clear
            textfield.borderStyle = .none
            DispatchQueue.main.async {
                
            }
        }
        alertcontroller.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Action Plan"
            textfield.delegate = vc as? UITextFieldDelegate
            textfield.clearButtonMode = .whileEditing
            textfield.frame.size.height = 50
            textfield.backgroundColor = UIColor.clear
            textfield.borderStyle = .none
            DispatchQueue.main.async {
                
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let Send = UIAlertAction(title: "Send", style: .destructive) { (action) in
            let first = alertcontroller.textFields![0] as UITextField
            let Second = alertcontroller.textFields![1] as UITextField
            if (first.text?.isEmpty)! && (Second.text?.isEmpty)! {
               // vc.view.showToast("Empty Remark & Action Plan \n Compulsory If Status is Reject Write Remark & Action Plan", position: .bottom, popTime: 3, dismissOnTap: false)
            } else if (first.text?.isEmpty)!{
               // vc.view.showToast("Empty Remark \n Compulsory If Status is Reject Write Remark", position: .bottom, popTime: 3, dismissOnTap: false)
            } else if (Second.text?.isEmpty)!{
              //  vc.view.showToast("Empty Action Plan \n Compulsory If Status is Reject Write Action Plan", position: .bottom, popTime: 3, dismissOnTap: false)
            } else {
                ActionCompletion()
            }
        }
        alertcontroller.addAction(Send)
        alertcontroller.addAction(cancel)
        vc.present(alertcontroller, animated: true, completion: nil)
    }
    func choose(vc: UIViewController,ActionCompletion: @escaping () -> (),Action2Completion: @escaping () -> ()){
        let alertcontroller = UIAlertController(title: "Choose", message: "", preferredStyle: .actionSheet)
        
        let button1 = UIAlertAction(title: "Image", style: .default) { (action) in
            ActionCompletion()
        }
        let button2 = UIAlertAction(title: "PDF File", style: .default) { (action) in
            Action2Completion()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertcontroller.addAction(button1)
        alertcontroller.addAction(button2)
        alertcontroller.addAction(cancel)
        vc.present(alertcontroller, animated: true, completion: nil)
    }
    func loaderAlert(vc: UIViewController,msg: String?){
        if msg == nil{
            alertcontroller = UIAlertController(title: "Please Wait....", message: nil, preferredStyle: .alert)
        } else {
            alertcontroller = UIAlertController(title: "Please Wait....", message: msg, preferredStyle: .alert)
        }
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 53, y: 18, width: 25, height: 25))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        alertcontroller.view.addSubview(loadingIndicator)
        DispatchQueue.main.async {
            vc.present(self.alertcontroller, animated: true, completion: nil)
        }
    }
    func showToast(vc: UIViewController, message : String,duration: Double?) {
        alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                ]
        )
        alertcontroller.setValue(messageText, forKey: "attributedMessage")
        alertcontroller.view.layer.cornerRadius = 5
        
        if duration != nil{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration!) {
                self.alertcontroller.dismiss(animated: true)
            }
        }
        DispatchQueue.main.async {
            vc.present(self.alertcontroller, animated: true, completion: nil)
        }
    }
}

extension UIAlertAction {
    convenience init(title: String?, style: UIAlertAction.Style, image: UIImage, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.actionImage = image
    }
    var actionImage: UIImage {
        get {
            return self.value(forKey: "image") as? UIImage ?? UIImage()
        }
        set(image) {
            self.setValue(image, forKey: "image")
        }
    }
}
/*
 
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
 deviceTokenString = token
 print(deviceToken)
 }
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
 print("i am not available in simulator \(error)")
 }
 
 UNUserNotificationCenter.current().delegate = self
 application.registerForRemoteNotifications()
 UNUserNotificationCenter.current().cleanRepeatingNotifications()
 UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -500.0, vertical: 0.0), for: .default)
 
 setCategories()
 
 
 extension AppDelegate:  UNUserNotificationCenterDelegate{
 
 func setCategories(){
 let clearRepeatAction = UNNotificationAction(
 identifier: "clear.repeat.action",
 title: "Stop Repeat",
 options: [])
 let remindaction = UNNotificationAction(
 identifier: "remindLater",
 title: "Remind me later",
 options: [])
 let Category = UNNotificationCategory(
 identifier: "medicine.reminder.category",
 actions: [clearRepeatAction,remindaction],
 intentIdentifiers: [],
 options: [])
 UNUserNotificationCenter.current().setNotificationCategories([Category])
 }
 
 
 func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 completionHandler([.alert,.sound])
 
 }
 
 func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
 if UIApplication.shared.applicationState == .background{
 print("bg")
 }
 UNUserNotificationCenter.current().cleanRepeatingNotifications()
 print("Did recieve response: \(response.actionIdentifier)")
 if response.actionIdentifier == "clear.repeat.action"{
 UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [response.notification.request.identifier])
 
 }
 if response.actionIdentifier == "remindLater" {
 UNUserNotificationCenter.current().getDeliveredNotifications { (receivedNotifications) in
 for notification in receivedNotifications {
 let content = notification.request.content
 let newDate = Date(timeInterval: 60, since: Date())
 self.scheduleNotification(at: newDate, title: content.title, body: content.body, withCompletionHandler: {
 completionHandler()
 })
 }
 }
 }
 completionHandler()
 }
 func scheduleNotification(at date: Date,title: String,body: String,withCompletionHandler: @escaping() -> ()) {
 let calendar = Calendar(identifier: .gregorian)
 let components = calendar.dateComponents(in: .current, from: date)
 let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
 
 let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
 
 let content = UNMutableNotificationContent()
 content.title = title
 content.body = body
 content.sound = UNNotificationSound.default
 content.categoryIdentifier = "medicine.reminder.category"
 
 let request = UNNotificationRequest(identifier: date.description, content: content, trigger: trigger)
 
 UNUserNotificationCenter.current().delegate = self
 UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
 UNUserNotificationCenter.current().add(request) {(error) in
 if let error = error {
 print("Uh oh! We had an error: \(error)")
 }
 }
 }
 
 }
 
 
 

 
 extension UNUserNotificationCenter{
    func cleanRepeatingNotifications(){
        //cleans notification with a userinfo key endDate
        //which have expired.
        var cleanStatus = "Cleaning...."
        getPendingNotificationRequests {
            (requests) in
            for request in requests{
                if let endDate = request.content.userInfo["endDate"]{
                    if Date() >= (endDate as! Date){
                        cleanStatus += "Cleaned request"
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    } else {
                        cleanStatus += "No Cleaning"
                    }
                    print(cleanStatus)
                }
            }
        }
    }
    
    
}*/
