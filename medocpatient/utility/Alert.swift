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
    
    func basicalert(vc: UIViewController,title: String,msg: String){
        let alertcontroller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(ok)
        vc.present(alertcontroller, animated: true, completion: nil)
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
        
            let cancel = UIAlertAction(title: button2title, style: .cancel) { (action) in
                Action2Completion()
            }
            let logout = UIAlertAction(title: buttontitle, style: .destructive) { (action) in
                ActionCompletion()
            }
            alertcontroller.addAction(logout)
            alertcontroller.addAction(cancel)
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
}
extension Date
{
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}
