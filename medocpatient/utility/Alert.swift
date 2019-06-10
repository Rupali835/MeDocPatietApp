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
    
    func choose(sender: UIView,vc: UIViewController,ActionCompletion: @escaping () -> (),Action2Completion: @escaping () -> ()){
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
        
        alertcontroller.popoverPresentationController?.sourceView = sender
        alertcontroller.popoverPresentationController?.sourceRect = sender.bounds
        alertcontroller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any;
        
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

