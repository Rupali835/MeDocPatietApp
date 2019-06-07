//
//  Utilities.swift
//  Perfecto
//
//  Created by Prem Sahni on 25/10/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation
import UIKit
import ZAlertView
import UserNotifications
import MaterialComponents.MaterialSnackbar

class Utilities {
    static let shared: Utilities = Utilities()
    private init() {}
    var message = UILabel()
    
    func shadow(object: [UIView]){
        for blueView in object{
            blueView.layer.cornerRadius = 5.0 
            blueView.layer.shadowColor = UIColor.darkGray.cgColor
            blueView.layer.shadowOffset = CGSize(width: 0, height: 2)
            blueView.layer.shadowOpacity = 0.5
            blueView.layer.shadowRadius = 1.0
        }
    }
    func bottomBorderSetup(fields: [UITextField],color: UIColor){
        for field in fields {
            field.borderStyle = .none
            field.autocorrectionType = .no
            field.layer.backgroundColor = color.cgColor
            field.layer.masksToBounds = false
            field.layer.shadowColor = UIColor(hexString: "#BDBDBD").cgColor
            field.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            field.layer.shadowOpacity = 1.0
            field.layer.shadowRadius = 0.0
        }
    }
    func borderRadius(objects: [UIView],color: UIColor){
        for object in objects{
            object.layer.borderColor = color.cgColor
            object.layer.borderWidth = 0.5
        }
    }
    func cornerRadius(objects: [UIView],number: CGFloat){
        for object in objects{
            object.layer.cornerRadius = number
            object.clipsToBounds = true
        }
    }
    func go_to_zoomimageview(vc: UIViewController,image: UIImage?){
        let zvc = UIViewController()
        zvc.navigationItem.title = "Image Viewer"
        let imageview = ImageScrollView(frame: CGRect(x: 0, y: 64, width: zvc.view.frame.width, height: zvc.view.frame.height - 64))
        imageview.backgroundColor = .white
        if image != nil{
            zvc.view.addSubview(imageview)
            imageview.display(image: image!)
            vc.navigationController?.pushViewController(zvc, animated: false)
        }
    }
    func showToast(text: String,duration: TimeInterval?){
        let message = MDCSnackbarMessage()
        message.text = text
        
        if duration != nil{
            message.duration = duration ?? 3.0
        }
        MDCSnackbarManager.buttonFont = UIFont.boldSystemFont(ofSize: 25)
//        MDCSnackbarManager.messageTextColor = UIColor.black
//        MDCSnackbarManager.snackbarMessageViewBackgroundColor = UIColor.white
        MDCSnackbarManager.show(message)
    }
    func centermsg(msg: String,view: UIView){
        message.text = msg
        message.translatesAutoresizingMaskIntoConstraints = false
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(message)
        
        message.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func removecentermsg(){
        message.removeFromSuperview()
    }
    var blurEffectView = UIVisualEffectView()
    
    func ShowLoaderView(view: UIView,Message: String){
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.startAnimating()
        
        message.text = Message
        message.translatesAutoresizingMaskIntoConstraints = false
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = UIFont.boldSystemFont(ofSize: 18)
        message.textColor = UIColor.white
        blurEffectView.contentView.addSubview(message)
        
        message.leftAnchor.constraint(equalTo: blurEffectView.contentView.leftAnchor, constant: 30).isActive = true
        message.rightAnchor.constraint(equalTo: blurEffectView.contentView.rightAnchor, constant: -30).isActive = true
        message.topAnchor.constraint(equalTo: activityIndicator.topAnchor, constant: 50).isActive = true
    }
    func RemoveLoaderView(){
        DispatchQueue.main.async {
            self.blurEffectView.removeFromSuperview()
        }
    }
    func alertview(title: String,msg: String,dismisstitle: String,mutlipleButtonAdd: @escaping(ZAlertView)->(),dismissAction: @escaping()->()){
        ZAlertView.alertTitleFont = UIFont.boldSystemFont(ofSize: 25)
        ZAlertView.messageFont = UIFont.boldSystemFont(ofSize: 18)
        ZAlertView.buttonHeight = 50
        
        let alert = ZAlertView(title: title, message: msg, alertType: ZAlertView.AlertType.multipleChoice)
        mutlipleButtonAdd(alert)
        alert.addButton(dismisstitle, font: UIFont.boldSystemFont(ofSize: 18), color: UIColor.clear, titleColor: UIColor.black) { (dismiss) in
            dismissAction()
            alert.dismissAlertView()
        }
        alert.show()
    }
    func dropdowninTextfield(fields: [UITextField]){
        for field in fields {
            let arrow = UIImageView(image: #imageLiteral(resourceName: "arrow-down-sign-to-navigate.png"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 30.0, height: size.height)
            }
            arrow.contentMode = UIView.ContentMode.center
            field.rightView = arrow
            field.rightViewMode = UITextField.ViewMode.always
        }
    }
    func setGradientBackground(view: UIView,color1: UIColor,color2: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1.cgColor,color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame.size = view.frame.size
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
