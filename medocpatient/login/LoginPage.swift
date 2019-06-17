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
//9619913968 & Sunil@123 & Krish@123
//8850214693 & Meera@123

import UIKit
import SkyFloatingLabelTextField
import CoreData
import ZAlertView

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
    var multipleuserdata = NSArray()
    var alertwithtextfield = UIAlertController()
    var alertwithtext = ZAlertView()

    
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
        button.tintColor = #colorLiteral(red: 0.2117647059, green: 0.09411764706, blue: 0.3294117647, alpha: 1)
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
                        floatingLabelTextField.errorMessage = ""
                    }
//                    else if text.count > 3 && text.contains(find: "@"){
//                        if text.isValidEmail() {
//                            floatingLabelTextField.errorMessage = ""
//                            self.fetch_login_by_relative_check()
//                        } else {
//                            floatingLabelTextField.errorMessage = "Invalid email"
//                        }
//                    }
                    else if text.count < 3{
                        floatingLabelTextField.errorMessage = ""
                    }
                    else if text.count == 10 && text.containsNumbers() == true{
                        self.fetch_login_by_relative_check()
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
    
    func fetchlogin(){
        print("0" )
        
       Utilities.shared.ShowLoaderView(view: self.view, Message:  "Please Wait..")
        ApiServices.shared.FetchPostDataFromUrlWithoutToken(vc: self, Url: ApiServices.shared.baseUrl + "patientlogin", parameter:  "login_id=\(self.PatientTextField.text!)&password=\(self.PasswordTextField.text!)", onSuccessCompletion: {
            
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    Utilities.shared.RemoveLoaderView()
                                    Utilities.shared.showToast(text: "Successfully Logged in", duration: 3.0)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utilities.shared.RemoveLoaderView()
                        Utilities.shared.showToast(text: "\(msg)", duration: 3.0)
                    }
                }
                else if msg == "Unauthorised"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utilities.shared.RemoveLoaderView()
                        Utilities.shared.showToast(text: "Maybe You Entered Wrong Password", duration: 3.0)
                    }
                }
                else if msg == "fail"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utilities.shared.RemoveLoaderView()
                        let reason = json.value(forKey: "reason") as! String
                        Utilities.shared.showToast(text: reason, duration: 3.0)
                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.showToast(text: "Something Went Wrong", duration: 3.0)
                }
            }
        })
    }
    func fetch_login_by_relative_check(){
        ApiServices.shared.FetchPostDataFromUrlWithoutToken(vc: self, Url: ApiServices.shared.baseUrl + "login-by-relative-check", parameter: "login_id=\(self.PatientTextField.text!)") {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print("login-by-relative-check json: \(json)")
                let msg = json.value(forKey: "msg") as! String
                if msg == "success" {
                    DispatchQueue.main.async {
                        if let data = json.value(forKey: "data") as? NSArray {
                            print("data: \(data)")
                            if data.count == 0{
                                
                            } else {
                                self.multipleuserdata = data
                                self.tableview_Alert(title: "Number Register With Multiple User", msg: "Select Your Name To Sign in")
                            }
                        }
                        else if let data = json.value(forKey: "data") as? String {
                            print("data in String: \(data)")
                            if data == "Single or No User"{
                               
                            }
                        }
                    }
                }
            } catch {
                print("catch login-by-relative-check")
            }
        }
    }
    @objc func loginAction(){
        if (PatientTextField.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(PatientTextField.placeholder!)", duration: 3.0)
        }
        else if (PasswordTextField.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(PasswordTextField.placeholder!)", duration: 3.0)
        }
        else{
            self.PatientTextField.endEditing(true)
            self.PasswordTextField.endEditing(true)
            
            NetworkManager.isReachable { _ in
                self.fetchlogin()
            }
            NetworkManager.isUnreachable { (_) in
                Alert.shared.internetoffline(vc: self)
            }
            NetworkManager.sharedInstance.reachability.whenReachable = { _ in
                self.fetchlogin()
            }
            NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                    Alert.shared.internetoffline(vc: self)
                }
            }
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
                        floatingLabelTextField.errorMessage = ""
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
    func tableview_Alert(title: String?,msg: String?){
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 250, height: 240))
        tableview.delegate = self
        tableview.dataSource = self
        vc.view.addSubview(tableview)
        let editRadiusAlert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        editRadiusAlert.addAction(cancelAction)
        self.present(editRadiusAlert, animated: true, completion:{})
    }
}
extension LoginPage: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.multipleuserdata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let data = self.multipleuserdata.object(at: indexPath.row) as! NSDictionary
        let patient_id = data.value(forKey: "patient_id") as? String
        let name = data.value(forKey: "name") as? String
        let relationship = data.value(forKey: "relationship") as? String ?? ""
        cell.textLabel?.text = name!
        cell.detailTextLabel?.text = patient_id
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.accessoryType = .checkmark
        self.PatientTextField.text = cell?.detailTextLabel?.text
        self.dismiss(animated: true, completion: nil)
    }
}
extension LoginPage {
    @IBAction func forgetpasswordAction(){
        if self.PatientTextField.text == "" {
            if let text = PatientTextField.text {
                if let floatingLabelTextField = PatientTextField as? SkyFloatingLabelTextField {
                    floatingLabelTextField.errorMessage = "Enter Your Mobile Number"
                }
            }
        } else {
            fetchforgetPassword(login_id: self.PatientTextField.text!)
        }
    }
    func fetchforgetPassword(login_id: String){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "")
        ApiServices.shared.FetchPostDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "forgot-password", bearertoken: "", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = json.value(forKey: "msg") as? String ?? ""
                if msg.contains(find: "OTP has been sent") {
                    DispatchQueue.main.async {
                        self.alertwithtext.dismissAlertView()
                        self.PatientTextField.endEditing(true)
                        self.PasswordTextField.endEditing(true)
                        self.EnterOTP(title: "", msg: msg, log_id: login_id)
                    }
                }
                else if msg == "fail" {
                    let reason = json.value(forKey: "reason") as? String ?? ""
                    if reason == "Login ID Incorrect" {
                        Utilities.shared.showToast(text: "Incorrect Mobile Number", duration: 3.0)
                    }
                }
                else {
                    print(json)
                    Utilities.shared.showToast(text: msg, duration: 3.0)
                }
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                }
            } catch {
                print("catch fetchforgetPassword")
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                }
            }
        }, HttpBodyCompletion: {
            ["login_id": login_id]
        })
    }
    func fetchforgot_password_approve(login_id: String,otp: String){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "")
        ApiServices.shared.FetchPostDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "forgot-password-approve", bearertoken: "", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                let msg = json.value(forKey: "msg") as? String ?? ""
                if msg == "success" {
                    DispatchQueue.main.async {
                        self.alertwithtext.dismissAlertView()
                        let token = json.value(forKey: "token") as? String ?? ""
                        self.addNewPassword(title: "", msg: "Note: Password Should be Atleast one Capital and Small Alphabet , Number , Special Character (eg:@,$,#)", Token: token)
                    }
                   
                }
                else if msg == "Login Id or OTP Incorrect" {
                    Utilities.shared.alertview(title: "Alert", msg: "Incorrect OTP", dismisstitle: "Ok", mutlipleButtonAdd: { (alert) in
                        
                    }, dismissAction: {})
                   // Utilities.shared.showToast(text: "Incorrect OTP", duration: 3.0)
                }
                else {
                    Utilities.shared.alertview(title: "Alert", msg: msg, dismisstitle: "Ok", mutlipleButtonAdd: { (alert) in
                        
                    }, dismissAction: {})
                  //  Utilities.shared.showToast(text: msg, duration: 3.0)
                }
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                }
            } catch {
                print("catch fetchforgot_password_approve")
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                }
            }
        }, HttpBodyCompletion: {
            ["login_id": login_id,
             "otp": otp]
        })
    }
    func fetchchange_password(token: String,newPassword: String){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "")
        ApiServices.shared.FetchPostDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "change-password", bearertoken: token, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                let msg = json.value(forKey: "msg") as? String ?? ""
                if msg == "success" {
                    
                    DispatchQueue.main.async {
                        self.alertwithtext.dismissAlertView()
                        Utilities.shared.alertview(title: msg, msg: "Password Reset Successfully", dismisstitle: "Ok", mutlipleButtonAdd: { (alert) in
                            
                        }, dismissAction: {})
                        self.PasswordTextField.text = newPassword
                        self.fetchlogin()
                        // Utilities.shared.showToast(text: msg, duration: 3.0)
                    }
                    
                } else {
                    Utilities.shared.alertview(title: "Alert", msg: msg, dismisstitle: "Ok", mutlipleButtonAdd: { (alert) in
                        
                    }, dismissAction: {})
                    // Utilities.shared.showToast(text: msg, duration: 3.0)
                }
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                }
            } catch {
                print("catch fetchchange_password")
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                }
            }
        }, HttpBodyCompletion: {
            ["new_password": newPassword]
        })
    }
    func EnterOTP(title: String,msg: String,log_id: String){
        
        Utilities.shared.alertview(title: title, msg: msg, dismisstitle: "Cancel", mutlipleButtonAdd: { (alert) in
            self.alertwithtext = alert
            
            alert.addButton("Confirm", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                
                if let txt1 = self.alertwithtext.getTextFieldWithIdentifier("OTP") {
                    print(txt1.text!)
                    
                    if txt1.text != "" {
                        self.fetchforgot_password_approve(login_id: log_id, otp: txt1.text!)
                    }
                    
                }
            }
            
            alert.addTextField("OTP", placeHolder: "Enter OTP",keyboardType: .numberPad)
            
        }, dismissAction: { })

    }
    func addNewPassword(title: String,msg: String,Token: String){
        
        Utilities.shared.alertview(title: title, msg: msg, dismisstitle: "Cancel", mutlipleButtonAdd: { (alert) in
            self.alertwithtext = alert

            alert.addButton("Confirm", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                
                if let txt1 = self.alertwithtext.getTextFieldWithIdentifier("New Password") {
                    print(txt1.text!)
                    
                    if txt1.text?.isValidPassword() == true {
                        self.fetchchange_password(token: Token, newPassword: txt1.text!)
                    } else {
                        Utilities.shared.alertview(title: "Alert", msg: "Invalid Password", dismisstitle: "Ok", mutlipleButtonAdd: { (alert) in
                            
                        }, dismissAction: {})
                       // Utilities.shared.showToast(text: "Invalid Password", duration: 3.0)
                    }
                    
                }
            }
            
            alert.addTextField("New Password", placeHolder: "Enter Your New Password")
            
        }, dismissAction: { })
        
    }
}
/* let url = ApiServices.shared.baseUrl + "patientlogin"
 let param: Parameters = ["login_id": self.PatientTextField.text!,"password": self.PasswordTextField.text!]
 let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded","Accept": "application/json"]
 //,"fcm_token": AppDelegate().fcm_token!
 //(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header)
 Alamofire.request(url, method: .post, parameters: param).responseJSON { (resp) in
 print(resp)
 }*/

//            alert.addButton("Resend OTP", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
//                self.fetchforgetPassword(login_id: log_id)
//                Utilities.shared.showToast(text: "Resend OTP", duration: 3.0)
//            }
