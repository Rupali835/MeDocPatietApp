//
//  ViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CoreData

class LoginPage: UIViewController, UITextFieldDelegate{

    @IBOutlet var LoginNow: UIButton!
    @IBOutlet var PatientTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var Register: UIButton!
    @IBOutlet var Gview: UIView!

    var pageVC = PageViewController()
    let appdel = UIApplication.shared.delegate as! AppDelegate
    let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   Utilities.shared.bottomBorderSetup(fields: [PatientTextField,PasswordTextField],color: UIColor(hexString: "FFFFFF"))
        Utilities.shared.borderRadius(objects: [LoginNow], color: UIColor(hexString: "4CAF50"))
        Utilities.shared.cornerRadius(objects: [LoginNow,Register], number: 5.0)
        Register.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        PatientTextField.delegate = self
        PasswordTextField.delegate = self
        
        let button = UIButton(type: .system)
        button.setTitle("Show", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.frame = CGRect(x: CGFloat(PasswordTextField.frame.size.width - 10), y: CGFloat(0), width: CGFloat(80), height: CGFloat(40))
        button.addTarget(self, action: #selector(self.showpassword), for: .touchUpInside)
        PasswordTextField.rightView = button
        PasswordTextField.rightViewMode = .always
        NotificationCenter.default.addObserver(self, selector: #selector(update(notification: )), name: NSNotification.Name("loginupdate"), object: nil)
        LoginNow.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func update(notification: NSNotification){
        DispatchQueue.main.async {
            SwiftLoader.show(animated: true)
            if let email = notification.userInfo?["email"] as? String{
                self.PatientTextField.text = email
            }
            if let password = notification.userInfo?["password"] as? String{
                self.PasswordTextField.text = password
            }
            SwiftLoader.hide()
        }
    }
    func savedata(name: String,gender: Int,email: String,contact: String){
        let managedobject = self.appdel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedobject)
        
        do {
            let profile = NSManagedObject(entity: entity!, insertInto: managedobject)
            //user
            profile.setValue(name, forKey: user.name)
            profile.setValue(gender, forKey: user.gender)
            profile.setValue(email, forKey: user.email)
            profile.setValue(contact, forKey: user.mobileNumber)
            try managedobject.save()
        } catch {
            print("catch")
        }
    }
    func login(){
        print("0")
        SwiftLoader.show(title: "Please Wait..", animated: true)
        ApiServices.shared.FetchPostDataFromURL(vc: self, withOutBaseUrl: "patientlogin", parameter:  "login_id=\(self.PatientTextField.text!)&password=\(self.PasswordTextField.text!)", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                let msg = json.value(forKey: "message") as! String
                if msg == "success"{
                    let data = json.value(forKey: "data") as! NSDictionary
                    let token = json.value(forKey: "token") as! String
                    
                    let contact_no = data.value(forKey: "contact_no") as! String
                    let email = data.value(forKey: "email") as! String
                    let id = data.value(forKey: "id") as! Int
                    let name = data.value(forKey: "name") as! String
                    let pid = data.value(forKey: "patient_id") as! String
                  //  let gender = data.value(forKey: "gender") as! Int
                    UserDefaults.standard.set(true, forKey: "Logged")
                    
                    UserDefaults.standard.set(contact_no, forKey: "contact_no")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(id, forKey: "id")
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(pid, forKey: "Patient_id")
                    UserDefaults.standard.set(token, forKey: "token")
                    
                   // self.savedata(name: name, gender: gender, email: email, contact: contact_no)
                    
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async {
                        self.appdel.RootPatientHomeVC()
                        SwiftLoader.hide()
                        self.view.showToast("Successfully Logged in", position: .bottom, popTime: 3, dismissOnTap: true)
                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
    @objc func loginAction(){
        if (PatientTextField.text?.isEmpty)! {
            self.view.showToast("Enter \(PatientTextField.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (PasswordTextField.text?.isEmpty)! {
            self.view.showToast("Enter \(PasswordTextField.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if PatientTextField.text?.isEmpty == false && PasswordTextField.text?.isEmpty == false {
            login()
        }
    }
    @objc func showpassword(sender: UIButton){
        if sender.titleLabel?.text == "Show"{
            PasswordTextField.isSecureTextEntry = false
            sender.setTitle("Secure", for: .normal)
        } else {
            sender.setTitle("Show", for: .normal)
            PasswordTextField.isSecureTextEntry = true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if PatientTextField.isFirstResponder {
            if let text = PatientTextField.text {
                if let floatingLabelTextField = PatientTextField as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = "Fill Patient Id , Contact No. or Email"
                    }
                    else if text.count > 3 && text.contains(find: "@"){
                        if text.isValidEmail() {
                            floatingLabelTextField.errorMessage = ""
                        } else {
                            floatingLabelTextField.errorMessage = "Invalid email"
                        }
                    }
                    else if text.count < 3{
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        if PasswordTextField.isFirstResponder {
            if let text = PasswordTextField.text {
                if let floatingLabelTextField = PasswordTextField as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = PasswordTextField.placeholder
                    }
                    else if text.count > 1{
                        if text.isValidPassword() {
                            floatingLabelTextField.errorMessage = ""
                        } else {
                            floatingLabelTextField.errorMessage = "Invalid password"
                        }
                    }
                    else if text.count < 1{
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        return true
    }
    override func viewWillLayoutSubviews() {
        Utilities.shared.setGradientBackground(view: self.view, color1: UIColor.groupTableViewBackground,color2: UIColor.white)
        Utilities.shared.setGradientBackground(view: Gview, color1: UIColor.groupTableViewBackground,color2: UIColor.white)
    }
    @objc func registerAction(){
        let pageViewController = self.parent as! PageViewController
        pageViewController.nextPageWithIndex(index: 2)
    }
}

