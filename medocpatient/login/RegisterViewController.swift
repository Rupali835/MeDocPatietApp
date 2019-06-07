//
//  RegisterViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController{

    @IBOutlet var Close: UIButton!
    @IBOutlet var FullNameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var NumberTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    @IBOutlet var ConfirmPasswordTF: UITextField!
    @IBOutlet var GenderRadio: [SKRadioButton]!
    @IBOutlet var Signup: UIButton!
    @IBOutlet var Gview: UIView!

    @IBOutlet var PatientIDRadio: SKRadioButton!
    @IBOutlet var PatientIDTF: UITextField!
    @IBOutlet var Done : UIButton!
    @IBOutlet var patientidView: UIView!
    @IBOutlet var signupView: UIView!
    
    var HavePatientID = false
    var selectedGender = 0
    var patientidget = ""
    
    @IBOutlet var HeightofPatientIDview: NSLayoutConstraint!
    @IBOutlet var HeightofSignupview: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PatientIDTF.delegate = self
        FullNameTF.delegate = self
        EmailTF.delegate = self
        NumberTF.delegate = self
        PasswordTF.delegate = self
        ConfirmPasswordTF.delegate = self
        
        DispatchQueue.main.async {
            self.PatientIDRadio.isSelected = false
            self.minimizeHeight(objects: [self.PatientIDTF,self.Done], heightContantOutlet: [self.HeightofPatientIDview], constant: 0)
        }
        
        Utilities.shared.borderRadius(objects: [Signup], color: UIColor(hexString: "673AB7"))
        Utilities.shared.cornerRadius(objects: [Signup], number: 5.0)
        
        Done.addTarget(self, action: #selector(DoneAction), for: .touchUpInside)
        Close.addTarget(self, action: #selector(CloseAction), for: .touchUpInside)
        
        let button = UIButton(type: .system)
        button.setTitle("Show", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.frame = CGRect(x: CGFloat(PasswordTF.frame.size.width - 10), y: CGFloat(0), width: CGFloat(80), height: CGFloat(40))
        button.addTarget(self, action: #selector(self.showpassword), for: .touchUpInside)
        PasswordTF.rightView = button
        PasswordTF.rightViewMode = .always
        
        PasswordTF.addTarget(self, action: #selector(updatePassword), for: .editingChanged)
        ConfirmPasswordTF.addTarget(self, action: #selector(updateConfirmPassword), for: .editingChanged)
        EmailTF.addTarget(self, action: #selector(updateEmail), for: .editingChanged)

        Signup.addTarget(self, action: #selector(SignupAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func updateEmail(){
        if EmailTF.isFirstResponder {
            if let text = EmailTF.text {
                if let floatingLabelTextField = EmailTF as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = "Fill Your Email"
                    }
                    else if text.count > 0 && text.contains(find: "@"){
                        if text.isValidEmail() {
                            floatingLabelTextField.errorMessage = ""
                        } else {
                            floatingLabelTextField.errorMessage = "Invalid email"
                        }
                    }
                }
            }
        }
    }
    @objc func updateConfirmPassword(){
        
        //check confirm password == password
        if let text = ConfirmPasswordTF.text {
            if let floatingLabelTextField = ConfirmPasswordTF as? SkyFloatingLabelTextField {
                if text.count >= 0{
                    if text == PasswordTF.text! && text.isValidPassword() {
                        floatingLabelTextField.errorMessage = ""
                    } else {
                        floatingLabelTextField.errorMessage = "Not Matched With Password"
                    }
                }
            }
        }
    }
    @objc func updatePassword(){
        if PasswordTF.isFirstResponder {
            if let text = PasswordTF.text {
                if let floatingLabelTextField = PasswordTF as? SkyFloatingLabelTextField {
                    if text.count >= 0{
                        if text.isValidPassword() {
                            floatingLabelTextField.errorMessage = ""
                        } else {
                            floatingLabelTextField.errorMessage = "Invalid password"
                        }
                    }
                }
            }
        }
    }
    @IBAction func ChangeGender(sender: SKRadioButton){
        self.GenderRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if self.GenderRadio[0].isSelected == true{
            self.selectedGender = 1
        }
        else if self.GenderRadio[1].isSelected == true{
            self.selectedGender = 2
        }
        else if self.GenderRadio[2].isSelected == true{
            self.selectedGender = 3
        }
    }
    @objc func showpassword(sender: UIButton){
        if sender.titleLabel?.text == "Show"{
            PasswordTF.isSecureTextEntry = false
            ConfirmPasswordTF.isSecureTextEntry = false
            sender.setTitle("Secure", for: .normal)
        } else {
            sender.setTitle("Show", for: .normal)
            PasswordTF.isSecureTextEntry = true
            ConfirmPasswordTF.isSecureTextEntry = true
        }
    }
    @objc func DoneAction(){
        if (PatientIDTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter Patient Id", duration: 3.0)
        } else {
            fetchDetailByPatientID()
        }
    }
    @objc func CloseAction(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func SignupAction(){
        //check empty textfield
        if (self.FullNameTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.FullNameTF.placeholder!)", duration: 3.0)
        }
//        else if (self.EmailTF.text?.isEmpty)! {
//            Utilities.shared.showToast(text: "Enter \(self.EmailTF.placeholder!)", duration: 3.0)
//        }
        else if self.EmailTF.text != "" && self.EmailTF.text?.isValidEmail() == false{
            Utilities.shared.showToast(text: "Invalid Email", duration: 3.0)
        }
        else if (self.NumberTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.NumberTF.placeholder!)", duration: 3.0)
        }
        else if (self.PasswordTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.PasswordTF.placeholder!)", duration: 3.0)
        }
        else if (self.ConfirmPasswordTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.ConfirmPasswordTF.placeholder!)", duration: 3.0)
        }
//        else if self.NumberTF.text?.isValidIndianContact == false{
  //      Utilities.shared.showToast(text: "Invalid Mobile Number", duration: 3.0)
//        }
        else if self.NumberTF.text?.count != 10{
            Utilities.shared.showToast(text: "Invalid Mobile Number", duration: 3.0)
        }
        else if self.NumberTF.text != "" && self.NumberTF.text?.first == "0"{
            Utilities.shared.showToast(text: "Mobile Number Should Not Start With 0", duration: 3.0)
        }
        else if self.PasswordTF.text?.isValidPassword() == false{
            Utilities.shared.showToast(text: "Invalid Password", duration: 3.0)
        }
        else if self.ConfirmPasswordTF.text != self.PasswordTF.text {
            Utilities.shared.showToast(text: "Not Matched With Password", duration: 3.0)
        }
        else if self.selectedGender == 0{
            Utilities.shared.showToast(text: "Select Gender", duration: 3.0)
        }
        //check all validation
        else {
            if HavePatientID == true{
                //with patient id
                if (self.PatientIDTF.text?.isEmpty)! {
                    
                } else {
                    print("0")
                    let with_patient_id = "name=\(self.FullNameTF.text!)&contact_no=\(self.NumberTF.text!)&gender=\(self.selectedGender)&email=\(self.EmailTF.text!)&password=\(self.PasswordTF.text!)&c_password=\(self.ConfirmPasswordTF.text!)&patient_id=\(self.patientidget)"
                    
                    NetworkManager.isReachable { _ in
                        self.register(parameter: with_patient_id)
                    }
                    NetworkManager.isUnreachable { (_) in
                        Alert.shared.internetoffline(vc: self)
                    }
                    NetworkManager.sharedInstance.reachability.whenReachable = { _ in
                        self.register(parameter: with_patient_id)
                    }
                    NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
                        DispatchQueue.main.async {
                            Utilities.shared.RemoveLoaderView()
                        }
                    }
                }
            }
            else if HavePatientID == false{
                print("1")
                //without patient id
                let without_patient_id = "name=\(self.FullNameTF.text!)&contact_no=\(self.NumberTF.text!)&gender=\(self.selectedGender)&email=\(self.EmailTF.text!)&password=\(self.PasswordTF.text!)&c_password=\(self.ConfirmPasswordTF.text!)"
                
                NetworkManager.isReachable { _ in
                    self.register(parameter: without_patient_id)
                }
                NetworkManager.isUnreachable { (_) in
                    Alert.shared.internetoffline(vc: self)
                }
                NetworkManager.sharedInstance.reachability.whenReachable = { _ in
                    self.register(parameter: without_patient_id)
                }
                NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
                    DispatchQueue.main.async {
                        Utilities.shared.RemoveLoaderView()
                    }
                }
            }
            
        }
    }//7218845446 & Amit@123
    func register(parameter: String){
        //Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait...")
        ApiServices.shared.Login_and_Register(vc: self, Url: ApiServices.shared.baseUrl + "patientregister", parameter:  parameter, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                if let msg = json.value(forKey: "msg") as? String{
                    if msg == "success" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            Utilities.shared.RemoveLoaderView()
                            Utilities.shared.showToast(text: "Signup Successfully", duration: 3.0)

                             NotificationCenter.default.post(name: NSNotification.Name("loginupdate"), object: nil, userInfo:["email":self.NumberTF.text!,"password":self.PasswordTF.text!])
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    if msg == "fail" {
                        if let reason = json.value(forKey: "reason") as? String{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                Utilities.shared.RemoveLoaderView()
                                Utilities.shared.showToast(text: "Reason: \(reason)", duration: 3.0)
                            }
                        }
                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.showToast(text: "Something Went Wrong", duration: 3.0)
                }
            }
        })
    }
    func fetchDetailByPatientID(){
        //Utilities.shared.ShowLoaderView(view: self.view, Message: "Fetching Details...")
        PatientIDTF.endEditing(true)
        ApiServices.shared.Login_and_Register(vc: self, Url: ApiServices.shared.baseUrl + "patientregisterusingid", parameter: "login_id=\(PatientIDTF.text!)", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                let msg = json.value(forKey: "msg") as? String
                
                if msg == "success"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        Utilities.shared.RemoveLoaderView()
                        
                        if let data = json.value(forKey: "data") as? NSDictionary {
                            let name = data.value(forKey: "name") as? String ?? ""
                            let contact_no = data.value(forKey: "contact_no") as? String ?? ""
                            let email = data.value(forKey: "email") as? String ?? ""
                            let gender = "\(data.value(forKey: "gender") as! Int)"
                            let patient_id = "\(data.value(forKey: "patient_id") as! String)"

                            self.FullNameTF.text = ""
                            self.EmailTF.text = ""
                            self.NumberTF.text = ""
                            self.selectedGender = 0
                            self.patientidget = ""
                            self.GenderRadio[0].isSelected = false
                            self.GenderRadio[1].isSelected = false
                            self.GenderRadio[2].isSelected = false
                            self.PasswordTF.text = ""
                            self.ConfirmPasswordTF.text = ""
                            
                            self.FullNameTF.text = name
                            self.EmailTF.text = email
                            self.NumberTF.text = contact_no
                            self.selectedGender = Int(gender)!
                            self.patientidget = patient_id
                            
                            
                            if gender == "1"{
                                self.GenderRadio[0].isSelected = true
                            }
                            else if gender == "2"{
                                self.GenderRadio[1].isSelected = true
                            }
                            else if gender == "3"{
                                self.GenderRadio[2].isSelected = true
                            }
                            
                            self.GenderRadio[0].isUserInteractionEnabled = false
                            self.GenderRadio[1].isUserInteractionEnabled = false
                            self.GenderRadio[2].isUserInteractionEnabled = false

                            self.maximizeHeight(objects: [self.signupView], heightContantOutlet: [self.HeightofSignupview],constant: 400)
                        }
                    }
                }
                else if msg == "fail"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        Utilities.shared.RemoveLoaderView()
                        if let reason = json.value(forKey: "reason") as? String{
                            Utilities.shared.showToast(text: "Reason: \(reason)", duration: 3.0)
                        }
                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.showToast(text: "Something Went Wrong", duration: 3.0)
                }
            }
        })
    }
    @IBAction func PatientIDYesOrNo(sender: SKRadioButton){
        
        if sender.isSelected == false {
            sender.isSelected = true
            HavePatientID = true
            maximizeHeight(objects: [PatientIDTF,Done], heightContantOutlet: [HeightofPatientIDview],constant: 50)
            minimizeHeight(objects: [signupView], heightContantOutlet: [HeightofSignupview], constant: 0)
        }
        else if sender.isSelected == true {
            sender.isSelected = false
            HavePatientID = false
            minimizeHeight(objects: [PatientIDTF,Done], heightContantOutlet: [HeightofPatientIDview], constant: 0)
            maximizeHeight(objects: [signupView], heightContantOutlet: [HeightofSignupview],constant: 400)
        }
        
    }
    func minimizeHeight(objects: [UIView],heightContantOutlet: [NSLayoutConstraint],constant: CGFloat){
        for obj in objects{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.isHidden = true
            }
        }
        for obj in heightContantOutlet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.constant = constant
            }
        }
    }
    func maximizeHeight(objects: [UIView],heightContantOutlet: [NSLayoutConstraint],constant: CGFloat){
        for obj in objects{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.isHidden = false
            }
        }
        for obj in heightContantOutlet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.constant = constant
            }
        }
    }
    
}
extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if PatientIDTF.isFirstResponder {
            if let text = PatientIDTF.text {
                if let floatingLabelTextField = PatientIDTF as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = ""
                    }
                    else if text.count > 0{
                        floatingLabelTextField.errorMessage = ""
                    }
                    
                }
            }
        }
        else if FullNameTF.isFirstResponder {
            if let text = FullNameTF.text {
                if let floatingLabelTextField = FullNameTF as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = "Fill Your Full Name"
                    }
                    else if text.count >= 0{
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        if NumberTF.isFirstResponder {
            if let text = NumberTF.text {
                if let floatingLabelTextField = NumberTF as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = "Fill Your Mobile Number"
                    }
                    else if text.count >= 0{
                        if text.isValidIndianContact {
                            floatingLabelTextField.errorMessage = ""
                        } else {
                            floatingLabelTextField.errorMessage = "Invalid Mobile Number"
                        }
                    }
                }
                let limitLength = 10
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        return true
    }
}
