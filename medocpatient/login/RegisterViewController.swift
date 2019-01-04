//
//  RegisterViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//
// Sign up form 
/*
 full name
 email
 number
 password
 confirm 
 gender
 */

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController{

    @IBOutlet var Close: UIButton!
    @IBOutlet var FullNameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var NumberTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    @IBOutlet var ConfirmPasswordTF: UITextField!
    @IBOutlet var GenderSegment: UISegmentedControl!
    @IBOutlet var Signin: UIButton!
    @IBOutlet var Signup: UIButton!
    @IBOutlet var Gview: UIView!

    @IBOutlet var PatientIDRadio: [SKRadioButton]!
    @IBOutlet var PatientIDTF: UITextField!
    @IBOutlet var Done : UIButton!
    @IBOutlet var patientidView: UIView!
    @IBOutlet var signupView: UIView!
    
    var HaveIDselected = 1
    var selectedGender = 0
    
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
            self.PatientIDRadio[1].isSelected = true
            self.minimizeHeight(objects: [self.PatientIDTF,self.Done], heightContantOutlet: [self.HeightofPatientIDview], constant: 50)
        }
        
       // Utilities.shared.bottomBorderSetup(fields: [FullNameTF,EmailTF,NumberTF,PasswordTF,ConfirmPasswordTF],color: UIColor(hexString: "FFFFFF"))
        Utilities.shared.borderRadius(objects: [Signup], color: UIColor(hexString: "4CAF50"))
        Utilities.shared.cornerRadius(objects: [Signup], number: 5.0)
        
        GenderSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "212121"), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: .normal)
        GenderSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "4CAF50"), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .selected)
        GenderSegment.tintColor = UIColor.clear
        GenderSegment.backgroundColor = UIColor.clear
        GenderSegment.addTarget(self, action: #selector(ChangeGender), for: .valueChanged)
        Done.addTarget(self, action: #selector(DoneAction), for: .touchUpInside)
        Close.addTarget(self, action: #selector(CloseAction), for: .touchUpInside)
        Signin.addTarget(self, action: #selector(SigninAction), for: .touchUpInside)
        Utilities.shared.setGradientBackground(view: self.view, color1: UIColor.groupTableViewBackground,color2: UIColor.white)
        Utilities.shared.setGradientBackground(view: Gview, color1: UIColor.groupTableViewBackground,color2: UIColor.white)
        
        let button = UIButton(type: .system)
        button.setTitle("Show", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.frame = CGRect(x: CGFloat(PasswordTF.frame.size.width - 10), y: CGFloat(0), width: CGFloat(80), height: CGFloat(40))
        button.addTarget(self, action: #selector(self.showpassword), for: .touchUpInside)
        PasswordTF.rightView = button
        PasswordTF.rightViewMode = .always
        
        Signup.addTarget(self, action: #selector(SignupAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func ChangeGender(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            self.selectedGender = 0
        }
        else if sender.selectedSegmentIndex == 1{
            self.selectedGender = 1
        }
        else if sender.selectedSegmentIndex == 2{
            self.selectedGender = 2
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
            self.view.showToast("Enter Patient Id", position: .bottom, popTime: 3, dismissOnTap: true)
        } else {
            fetchDetailByPatientID()
        }
    }
    @objc func CloseAction(){
        let pageViewController = self.parent as! PageViewController
        pageViewController.PreviousPageWithIndex(index: 1)
    }
    @objc func SigninAction(){
        let pageViewController = self.parent as! PageViewController
        pageViewController.PreviousPageWithIndex(index: 1)
    }
    @objc func SignupAction(){
        //check empty textfield
        if (self.FullNameTF.text?.isEmpty)! {
            self.view.showToast("Enter \(self.FullNameTF.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (self.EmailTF.text?.isEmpty)! {
            self.view.showToast("Enter \(self.EmailTF.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (self.NumberTF.text?.isEmpty)! {
            self.view.showToast("Enter \(self.NumberTF.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (self.PasswordTF.text?.isEmpty)! {
            self.view.showToast("Enter \(self.PasswordTF.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (self.ConfirmPasswordTF.text?.isEmpty)! {
            self.view.showToast("Enter \(self.ConfirmPasswordTF.placeholder!)", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        //check confirm password == password
        else if self.ConfirmPasswordTF.text != self.PasswordTF.text {
            if let text = ConfirmPasswordTF.text {
                if text == PasswordTF.text! && text.isValidPassword() {
                    print("Match Password")
                } else {
                    self.view.showToast("Not Matched With Password", position: .bottom, popTime: 3, dismissOnTap: true)
                }
            }
        }
        // check single validation false
        else if self.EmailTF.text?.isValidEmail() == false{
            self.view.showToast("Invalid Email", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if self.NumberTF.text?.isValidIndianContact == false{
            self.view.showToast("Invalid Mobile Number", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if self.PasswordTF.text?.isValidPassword() == false{
            self.view.showToast("Invalid Password", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        //check all validation
        else if (self.EmailTF.text?.isValidEmail())! && (self.PasswordTF.text?.isValidPassword())! && (self.NumberTF.text?.isValidIndianContact)! {
            
            if HaveIDselected == 0{
                //with patient id
                if (self.PatientIDTF.text?.isEmpty)! {
                    
                } else {
                    print("0")
                    let with_patient_id = "name=\(self.FullNameTF.text!)&contact_no=\(self.NumberTF.text!)&gender=\(self.selectedGender)&email=\(self.EmailTF.text!)&password=\(self.PasswordTF.text!)&c_password=\(self.ConfirmPasswordTF.text!)&patient_id=\(self.PatientIDTF.text!)"
                    //register(parameter: with_patient_id)
                }
            }
            else if HaveIDselected == 1{
                print("1")
                //without patient id
                let without_patient_id = "name=\(self.FullNameTF.text!)&contact_no=\(self.NumberTF.text!)&gender=\(self.selectedGender)&email=\(self.EmailTF.text!)&password=\(self.PasswordTF.text!)&c_password=\(self.ConfirmPasswordTF.text!)"
                //register(parameter: without_patient_id)
            }
            
        }
    }
    func register(parameter: String){
        SwiftLoader.show(animated: true)
        ApiServices.shared.FetchPostDataFromURL(vc: self, withOutBaseUrl: "patientregister", parameter:  parameter, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    NotificationCenter.default.post(name: NSNotification.Name("loginupdate"), object: nil, userInfo:["email":self.EmailTF.text!,"password":self.PasswordTF.text!])
                    let pageViewController = self.parent as! PageViewController
                    pageViewController.PreviousPageWithIndex(index: 1)
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
    func fetchDetailByPatientID(){
        SwiftLoader.show(animated: true)
        PatientIDTF.endEditing(true)
        ApiServices.shared.FetchPostDataFromURL(vc: self, withOutBaseUrl: "patientregisterusingid", parameter: "patient_id=\(PatientIDTF.text!)", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                let msg = json.value(forKey: "msg") as! String
                
                if msg == "success"{
                    DispatchQueue.main.async {
                        let data = json.value(forKey: "data") as! NSDictionary
                        let name = data.value(forKey: "name") as! String
                        let contact_no = data.value(forKey: "contact_no") as! String
                        let email = data.value(forKey: "email") as! String
                        let gender = data.value(forKey: "gender") as! Int
                        
                        self.FullNameTF.text = name
                        self.EmailTF.text = email
                        self.NumberTF.text = contact_no
                        self.GenderSegment.selectedSegmentIndex = gender
                        
                        SwiftLoader.hide()
                        self.maximizeHeight(objects: [self.signupView], heightContantOutlet: [self.HeightofSignupview],constant: 400)
                    }
                }
                else if msg == "Patient Id invalid"{
                    DispatchQueue.main.async {
                        self.view.showToast("Sorry, Didn't Match With Our Data", position: .bottom, popTime: 3, dismissOnTap: true)
                        SwiftLoader.hide()
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
    @IBAction func PatientIDYesOrNo(sender: SKRadioButton){
        self.PatientIDRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 1 {
            HaveIDselected = 0
            maximizeHeight(objects: [PatientIDTF,Done], heightContantOutlet: [HeightofPatientIDview],constant: 100)
            minimizeHeight(objects: [signupView], heightContantOutlet: [HeightofSignupview], constant: 0)
        }
        else if sender.tag == 2 {
            HaveIDselected = 1
            minimizeHeight(objects: [PatientIDTF,Done], heightContantOutlet: [HeightofPatientIDview], constant: 50)
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
        else if EmailTF.isFirstResponder {
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
