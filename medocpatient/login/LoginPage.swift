//
//  ViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//
//9876545677 & Kalyani@123
//8108091854 & Prashant@123
//7738260306 & Amit@123

import UIKit
import SkyFloatingLabelTextField
import CoreData
import Alamofire

class LoginPage: UIViewController, UITextFieldDelegate{

    @IBOutlet var LoginNow: UIButton!
    @IBOutlet var PatientTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var Register: UIButton!
    @IBOutlet var Gview: UIView!
    @IBOutlet var loginview: UIView!
    @IBOutlet var logo : UIImageView!
    @IBOutlet var cutview: UIView!

    let appdel = UIApplication.shared.delegate as! AppDelegate
    let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.borderRadius(objects: [LoginNow], color: UIColor(hexString: "673AB7"))
        Utilities.shared.cornerRadius(objects: [LoginNow,Register,loginview,logo], number: 5.0)
        
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
        PasswordTextField.addTarget(self, action: #selector(updatePassword), for: .editingChanged)
        PatientTextField.addTarget(self, action: #selector(updatePatient), for: .editingChanged)

        LoginNow.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func updatePatient(){
        if PatientTextField.isFirstResponder {
            if let text = PatientTextField.text {
                if let floatingLabelTextField = PatientTextField as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = "Fill Contact No. or Email"
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
    }
    @objc func update(notification: NSNotification){
        DispatchQueue.main.async {
            if let email = notification.userInfo?["email"] as? String{
                self.PatientTextField.text = email
            }
            if let password = notification.userInfo?["password"] as? String{
                self.PasswordTextField.text = password
            }
        }
    }
    func savedata(name: String,gender: String,email: String,contact: String,profile_image: String){
        let managedobject = self.appdel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedobject)
        
        do {
            let profile = NSManagedObject(entity: entity!, insertInto: managedobject)
            //user
            profile.setValue(name, forKey: user.name)
            profile.setValue(gender, forKey: user.gender)
            profile.setValue(email, forKey: user.email)
            profile.setValue(contact, forKey: user.mobileNumber)
            profile.setValue(profile_image, forKey: user.profile_image)
            try managedobject.save()
        } catch {
            print("catch")
        }
    }
    func login(){
        print("0")
       /* let url = ApiServices.shared.baseUrl + "patientlogin"
        let param: Parameters = ["login_id": self.PatientTextField.text!,"password": self.PasswordTextField.text!]
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded","Accept": "application/json"]
        //,"fcm_token": AppDelegate().fcm_token!
        //(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header)
        Alamofire.request(url, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
        }*/
        
        Utilities.shared.ShowLoaderView(view: self.view, Message:  "Please Wait..")
        ApiServices.shared.Login_and_Register(vc: self, Url: ApiServices.shared.baseUrl + "patientlogin", parameter:  "login_id=\(self.PatientTextField.text!)&password=\(self.PasswordTextField.text!)", onSuccessCompletion: {
            do {
                let js = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers)
                let json = js as! NSDictionary
                print(js)
                var msg = ""
                
                if let error = json.value(forKey: "msg") as? String {
                    msg = error
                } else {
                    msg = json.value(forKey: "message") as! String
                }
                
                if msg == "success"{
                    if let data = json.value(forKey: "data") as? NSDictionary{
                        let bearertoken = json.value(forKey: "token") as! String
                        
                        let contact_no = data.value(forKey: "contact_no") as! String
                        let email = data.value(forKey: "email") as? String ?? ""
                        let profile_image = data.value(forKey: "profile_image") as? String ?? ""
                        let name = data.value(forKey: "name") as! String
                        let pid = data.value(forKey: "patient_id") as! String
                        let gender = data.value(forKey: "gender") as? Int ?? 1
                        let id = data.value(forKey: "id") as! Int
                        UserDefaults.standard.set(true, forKey: "Logged")
                        
                        UserDefaults.standard.set(contact_no, forKey: "contact_no")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(profile_image, forKey: "profile_image")
                        UserDefaults.standard.set(name, forKey: "name")
                        UserDefaults.standard.set(pid, forKey: "Patient_id")
                        UserDefaults.standard.set(id, forKey: "id")
                        UserDefaults.standard.set(bearertoken, forKey: "bearertoken")
                        
                        UserDefaults.standard.synchronize()
                        self.savedata(name: name, gender: "\(gender)", email: email, contact: contact_no, profile_image: profile_image)
                        
                        let bearertokenget = UserDefaults.standard.string(forKey: "bearertoken")
                        
                        if let bt = bearertokenget {
                            if bt == bearertoken {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    Utilities.shared.RemoveLoaderView()
                                    self.view.showToast("Successfully Logged in", position: .bottom, popTime: 3, dismissOnTap: true)
                                    self.appdel.RootPatientHomeVC()
                                }
                            } else {
                                print(bt)
                                print("nil Bearer token")
                            }
                        }
                    }
                }
                else if msg == "User not registered"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        Utilities.shared.RemoveLoaderView()
                        self.view.showToast("\(msg)", position: .bottom, popTime: 3, dismissOnTap: true)
                    }
                }
                else if msg == "Unauthorised"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        Utilities.shared.RemoveLoaderView()
                        self.view.showToast("Maybe You Entered Wrong Password", position: .bottom, popTime: 3, dismissOnTap: true)
                    }
                }
                else if msg == "fail"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        Utilities.shared.RemoveLoaderView()
                        let reason = json.value(forKey: "reason") as! String
                        self.view.showToast(reason, position: .bottom, popTime: 3, dismissOnTap: true)
                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    Utilities.shared.RemoveLoaderView()
                    self.view.showToast("Something Went Wrong", position: .bottom, popTime: 3, dismissOnTap: true)
                }
            }
        })
    }
    @objc func loginAction(){
        if (PatientTextField.text?.isEmpty)! {
            self.view.showToast("Enter \(PatientTextField.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (PasswordTextField.text?.isEmpty)! {
            self.view.showToast("Enter \(PasswordTextField.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else{
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
    @objc func updatePassword(){
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
                            floatingLabelTextField.errorMessage = ""//"Invalid password"
                        }
                    }
                    else if text.count < 1{
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
    }
    @objc func registerAction(){
        let signupvc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(signupvc, animated: true, completion: nil)
    }
}

