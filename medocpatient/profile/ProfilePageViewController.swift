//
//  ProfilePageViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import DBAttachmentPickerController
import SkyFloatingLabelTextField

class ProfilePageViewController: UIViewController, UITextFieldDelegate, DBAssetPickerControllerDelegate {
    
    @IBOutlet var segment_typeview: UISegmentedControl!
    @IBOutlet var details_scrollview: UIScrollView!
    @IBOutlet var medical_scrollview: UIScrollView!
    //user
    @IBOutlet var BasicView: UIView!
    @IBOutlet var imagesPicView: UIImageView!
    @IBOutlet var addProfileImage: UIButton!
    @IBOutlet var NameTF: UITextField!
    @IBOutlet var DateOfBirthTF: UITextField!
    @IBOutlet var age: UILabel!
    @IBOutlet var BloodGroupTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var PatientTF: UITextField!
    @IBOutlet var GenderRadio: [SKRadioButton]!
    
    @IBOutlet var MobileAddressView: UIView!
    @IBOutlet var MobileNumberTF: UITextField!
    @IBOutlet var Address1TF: UITextField!
    @IBOutlet var Address2TF: UITextField!
    @IBOutlet var SubCityTF: UITextField!
    @IBOutlet var CityTF: UITextField!
    @IBOutlet var pincodeTF: UITextField!
    //guardian
    @IBOutlet var GuardianView: UIView!
    @IBOutlet var GuardianNameTF: UITextField!
    @IBOutlet var GuardianMobileNumberTF: UITextField!
    @IBOutlet var GuardianAddress1TF: UITextField!
    @IBOutlet var GuardianAddress2TF: UITextField!
    @IBOutlet var GuardianSubCityTF: UITextField!
    @IBOutlet var GuardianCityTF: UITextField!
    @IBOutlet var GuardianPincodeTF: UITextField!
    //emergency contact
    @IBOutlet var ECView: UIView!
    @IBOutlet var FirstEC_NameTF: UITextField! //EC: Emergency Contact
    @IBOutlet var FirstEC_RelationshipTF: UITextField!
    @IBOutlet var FirstEC_NumberTF: UITextField!

    @IBOutlet var SecondEC_NameTF: UITextField! //EC: Emergency Contact
    @IBOutlet var SecondEC_RelationshipTF: UITextField!
    @IBOutlet var SecondEC_NumberTF: UITextField!
    //personal physician

    @IBOutlet var MIPView: UIView!
    @IBOutlet var PP_NameTF: UITextField! //PP: Personal Physician
    @IBOutlet var PP_NumberTF: UITextField!
    @IBOutlet var PP_PolicyTF: UITextField!
    @IBOutlet var PP_PolicyNumberTF: UITextField!
    //allergy
    @IBOutlet var AllergyRadio : [SKRadioButton]!
    //Textfield inside medical information
    @IBOutlet var FoodAllergyTF: UITextField!
    @IBOutlet var MedicinesAllergiesTF: UITextField!
    @IBOutlet var PlantsTF: UITextField!
    @IBOutlet var InsectsTF: UITextField!
    //medical condition
    @IBOutlet var DiebetesTF: UITextField!
    @IBOutlet var CancerTF: UITextField!
    @IBOutlet var HeartDiseaseTF: UITextField!
    @IBOutlet var LeukemiaTF: UITextField!
    @IBOutlet var otherAllergyTF: UITextField!
    @IBOutlet var RestrictionTF: UITextField!
    @IBOutlet var RecentMedicalConditionTF: UITextField!//recent medical condition
    //
    //YES AND NO
    @IBOutlet var FoodRadio: [SKRadioButton]!
    @IBOutlet var MedicinesRadio: [SKRadioButton]!
    @IBOutlet var PlantsRadio: [SKRadioButton]!
    @IBOutlet var InsectsRadio: [SKRadioButton]!
    
    @IBOutlet var DiebetesRadio: [SKRadioButton]!
    @IBOutlet var CancerRadio: [SKRadioButton]!
    @IBOutlet var HeartDiseaseRadio: [SKRadioButton]!
    @IBOutlet var LeukemiaRadio: [SKRadioButton]!
    @IBOutlet var otherAllergyRadio: [SKRadioButton]!
    @IBOutlet var RestrictionRadio: [SKRadioButton]!
    @IBOutlet var RecentMedicalConditionRadio: [SKRadioButton]!
    //
    //Heights of textfield
    @IBOutlet var HeightOfFoodTF: NSLayoutConstraint!
    @IBOutlet var HeightOfMedicinesTF: NSLayoutConstraint!
    @IBOutlet var HeightOfPlantsTF: NSLayoutConstraint!
    @IBOutlet var HeightOfInsectsTF: NSLayoutConstraint!
    
    @IBOutlet var HeightOfDiebetesTF: NSLayoutConstraint!
    @IBOutlet var HeightOfCancerTF: NSLayoutConstraint!
    @IBOutlet var HeightOfHeartDiseaseTF: NSLayoutConstraint!
    @IBOutlet var HeightOfLeukemiaTF: NSLayoutConstraint!
    @IBOutlet var HeightOfotherAllergyTF: NSLayoutConstraint!
    @IBOutlet var HeightOfRestrictionTF: NSLayoutConstraint!
    @IBOutlet var HeightOfRecentMedicalConditionTF: NSLayoutConstraint!
    @IBOutlet var bottomContraint: NSLayoutConstraint!
    //
    @IBOutlet var allergyView: UIView!
    @IBOutlet var HeightOFallergyView: NSLayoutConstraint!
    
    @IBOutlet var btn_add_foodallergy: UIButton!
    @IBOutlet var lbl_data_foodallergy: UILabel!
    
    @IBOutlet var btn_add_drugallergy: UIButton!
    @IBOutlet var lbl_data_drugallergy: UILabel!
    
    @IBOutlet var btn_add_Envirormentallergy: UIButton!
    @IBOutlet var lbl_data_Envirormentallergy: UILabel!
    
    @IBOutlet var btn_add_familyhistory: UIButton!
    @IBOutlet var lbl_data_familyhistory: UILabel!
    
    @IBOutlet var btn_add_knowncondition: UIButton!
    @IBOutlet var lbl_data_knowncondition: UILabel!
    
    @IBOutlet var btn_add_geneticdisorder: UIButton!
    @IBOutlet var lbl_data_geneticdisorder: UILabel!
    
    @IBOutlet var LastDoneView: UIView!
    @IBOutlet var btn_selectdates: [UIButton]!

    @IBOutlet var Save: UIButton!
    
    var edit = Bool(false)
    var selectedGender = "1"
    var HaveAllergy = "0"
    var selectedfood = "0"
    var selectedmedicine = "0"
    var selectedplants = "0"
    var selectedinsects = "0"
    var selectedother = "0"
    var selectedbp = "0"
    var selecteddiebetes = "0"
    var selectedcancer = "0"
    var selectedheartdisease = "0"
    var selectedleukemia = "0"
    var selectedrestriction = "0"
    var selectedcondition = "0"
    
    var base64image = ""
    let user = User()
    let guardian = Guardian()
    let emergencyContact = EmergencyContact()
    let medical = Medical()
    let lastVaccinationDone = LastVaccinationDone()
    var dateview = UIDatePicker()
    let appdel = UIApplication.shared.delegate as! AppDelegate
    
    var attachmentArray : NSMutableArray = []
    var APC = DBAttachmentPickerController()
    
    var back = true
    var dict = NSDictionary()
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    var urlpath = ""
    var imagename = ""
    var pdfurl = URL(string: "NF")!
    var editbutton = UIBarButtonItem()
    let pickerview = UIPickerView()
    let bloodtypes = ["A+","A-","B-","B+","AB+","AB-","O+","O-"]
   
    var arr_foodallergy = [String]()
    var arr_drugallergy = [String]()
    var arr_environmentalallergy = [String]()
    var arr_familyhistory = [String]()
    var arr_knowncondition = [String]()
    var arr_geneticdisorders = [String]()

}
extension ProfilePageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.medical_scrollview.alpha = 0
        self.details_scrollview.alpha = 1
        
        segment_typeview.addTarget(self, action: #selector(Action_segment_typeview), for: .valueChanged)
        
        Utilities.shared.cornerRadius(objects: [imagesPicView], number: imagesPicView.frame.width / 2)

        Save.addTarget(self, action: #selector(SaveAction), for: .touchUpInside)
        
        MobileNumberTF.delegate = self
        GuardianMobileNumberTF.delegate = self
        PP_NumberTF.delegate = self
        FirstEC_NumberTF.delegate = self
        SecondEC_NumberTF.delegate = self
        
        pincodeTF.delegate = self
        GuardianPincodeTF.delegate = self

        addProfileImage.addTarget(self, action: #selector(addAttachmentAction), for: .touchUpInside)
        editbutton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EditableandNonEditable))
        self.navigationItem.rightBarButtonItem = editbutton
        self.alltextfield(bool: false)
        self.navigationItem.hidesBackButton = true
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow.png"), style: .plain, target: self, action: #selector(handleBack))
        back.imageInsets = UIEdgeInsets(top: 3, left: -20, bottom: -7, right: -10)
        self.navigationItem.leftBarButtonItem = back
        
        customizePickerViewandDateView()
        
        NetworkManager.isReachable { _ in
            self.fetchProfileDatail()
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchProfileDatail()
        }
        NetworkManager.isUnreachable { _ in
            self.SetupInterface()
        }
        // Do any additional setup after loading the view.
    }
    @objc func Action_segment_typeview(){
        if self.segment_typeview.selectedSegmentIndex == 0{
            self.medical_scrollview.alpha = 0
            self.details_scrollview.alpha = 1
        } else {
            self.medical_scrollview.alpha = 1
            self.details_scrollview.alpha = 0
        }
    }
    @objc func handleBack(){
        if back == true {
            self.navigationController?.popViewController(animated: true)
        } else {
            Utilities.shared.alertview(title: "Alert", msg: "Do you want to go back,Your data will be lost", dismisstitle: "Back", mutlipleButtonAdd: { (alert) in
                alert.addButton("Update", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                    if self.validateProfile() == false{
                        
                    }
                    else {
                        self.sendData()
                    }
                    alert.dismissAlertView()
                }
            }, dismissAction: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
//    @objc func setdateandage(){
//        datePicker(done_complation: {
//            let date = self.dateview.date
//
//            let df = DateFormatter()
//            df.dateFormat = "yyyy-MM-dd"
//
//            self.DateOfBirthTF.text = df.string(from: date)
//            let calendar : NSCalendar = NSCalendar.current as NSCalendar
//            let ageComponents = calendar.components(.month, from: date, to: Date() as Date, options: []).month
//            let years = ageComponents! / 12
//            let months = ageComponents! % 12
//            self.age.text = "Age: \(years) Y / \(months) M"
//        })
//    }
}
extension ProfilePageViewController {//validation
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    @objc func SaveAction(){
        if validateProfile() == false{
            
        }
        else {
            sendData()
        }
    }
    func validateProfile()->Bool{
        if self.MobileNumberTF.text != "" && self.MobileNumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Mobile Number")
            return false
        }
        else if self.emailTF.text != "" && self.emailTF.text?.isValidEmail() == false {
            self.toast(msg: "Enter Valid Email Address")
            return false
        }
        else if self.GuardianMobileNumberTF.text != "" && self.GuardianMobileNumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Guardian Mobile Number")
            return false
        }
        else if self.GuardianMobileNumberTF.text != "" && self.GuardianMobileNumberTF.text?.first == "0" {
            self.toast(msg: "Guardian Mobile Number Should Not Start With 0")
            return false
        }
        else if self.PP_NumberTF.text != "" && self.PP_NumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Personal Physician Mobile Number")
            return false
        }
        else if self.PP_NumberTF.text != "" && self.PP_NumberTF.text?.first == "0" {
            self.toast(msg: "Personal Physician Mobile Number Should Not Start With 0")
            return false
        }
        else if self.FirstEC_NumberTF.text != "" && self.FirstEC_NumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Primary Emergency Mobile Number")
            return false
        }
        else if self.FirstEC_NumberTF.text != "" && self.FirstEC_NumberTF.text?.first == "0" {
            self.toast(msg: "Primary Emergency Mobile Number Should Not Start With 0")
            return false
        }
        else if self.SecondEC_NumberTF.text != "" && self.SecondEC_NumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Secondary Emergency Mobile Number")
            return false
        }
        else if self.SecondEC_NumberTF.text != "" && self.SecondEC_NumberTF.text?.first == "0" {
            self.toast(msg: "Secondary Emergency Mobile Number Should Not Start With 0")
            return false
        }
        else if self.pincodeTF.text != "" && (self.pincodeTF.text?.count)! > 6 {
            self.toast(msg: "Enter Valid Pincode")
            return false
        }
        else if self.GuardianPincodeTF.text != "" && (self.GuardianPincodeTF.text?.count)! > 6 {
            self.toast(msg: "Enter Valid Guardian Pincode")
            return false
        }
        else {
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limitLength = 10
        let pincodelimit = 6

        if MobileNumberTF.isFirstResponder {
            if let text = MobileNumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if GuardianMobileNumberTF.isFirstResponder {
            if let text = GuardianMobileNumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if PP_NumberTF.isFirstResponder {
            if let text = PP_NumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if FirstEC_NumberTF.isFirstResponder {
            if let text = FirstEC_NumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if SecondEC_NumberTF.isFirstResponder {
            if let text = SecondEC_NumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if pincodeTF.isFirstResponder {
            if let text = pincodeTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= pincodelimit
            }
        }
        else if GuardianPincodeTF.isFirstResponder {
            if let text = GuardianPincodeTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= pincodelimit
            }
        }
        else if GuardianPincodeTF.isFirstResponder {
            if let text = GuardianPincodeTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= pincodelimit
            }
        }
        return true
    }
}
extension ProfilePageViewController {
    
    func customizePickerViewandDateView(){
        self.pickerview.reloadAllComponents()
        self.pickerview.reloadInputViews()
        self.pickerview.dataSource = self
        self.pickerview.delegate = self
        self.pickerview.backgroundColor = UIColor.lightText
        
        BloodGroupTF.delegate = self
        BloodGroupTF.inputView = pickerview
        
//        DateOfBirthTF.addTarget(self, action: #selector(setdateandage), for: .editingDidBegin)
//        DateOfBirthTF.inputView = UIView(frame: .zero)
//        DateOfBirthTF.inputAccessoryView = UIView(frame: .zero)

        DateOfBirthTF.delegate = self
        DateOfBirthTF.inputView = dateview
        
        dateview.datePickerMode = .date
        dateview.maximumDate = Date()
        dateview.backgroundColor = UIColor.white
        dateview.setValue(UIColor.black, forKeyPath: "textColor")
        dateview.setDate(Date(), animated: true)
        dateview.addTarget(self, action: #selector(setdate), for: .valueChanged)
    }
    @objc func EditableandNonEditable(){
        NetworkManager.isReachable { _ in
            self.alltextfield(bool: true)

            if self.edit == false{
                self.edit = true
                self.editbutton.title = ""
                self.alltextfield(bool: true)
                self.Save.alpha = 1.0
                self.back = false
            } else {
                self.edit = false
                self.editbutton.title = "Edit"
               // self.alltextfield(bool: false)
            }
        }
        NetworkManager.isUnreachable { _ in
            Alert.shared.basicalert(vc: self, title: "You Cannot Edit Detail Without Internet Connection", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
        }
    }
    func editAllTextfield(bool: Bool,objects: [SkyFloatingLabelTextField]){
        DispatchQueue.main.async {
            for object in objects{
                object.isUserInteractionEnabled = bool
            }
        }
    }
    func alltextfield(bool: Bool){
        let alltf = [NameTF,DateOfBirthTF,BloodGroupTF,emailTF,Address1TF,Address2TF,SubCityTF,CityTF,pincodeTF,GuardianNameTF,GuardianMobileNumberTF,GuardianAddress1TF,GuardianAddress2TF,GuardianSubCityTF,GuardianCityTF,GuardianPincodeTF,FirstEC_NameTF,FirstEC_RelationshipTF,FirstEC_NumberTF,SecondEC_NameTF,SecondEC_RelationshipTF,SecondEC_NumberTF,PP_NameTF,PP_NumberTF,PP_PolicyTF,PP_PolicyNumberTF]
        
        //,FoodAllergyTF,MedicinesAllergiesTF,PlantsTF,InsectsTF,otherAllergyTF,DiebetesTF,CancerTF,HeartDiseaseTF,LeukemiaTF,RestrictionTF,RecentMedicalConditionTF
        self.PatientTF.isUserInteractionEnabled = false
        self.MobileNumberTF.isUserInteractionEnabled = false

        self.addProfileImage.isUserInteractionEnabled = bool
        
        self.GenderRadio[0].isUserInteractionEnabled = bool
        self.GenderRadio[1].isUserInteractionEnabled = bool
        self.GenderRadio[2].isUserInteractionEnabled = bool
        
       /* self.AllergyRadio[0].isUserInteractionEnabled = bool
        self.AllergyRadio[1].isUserInteractionEnabled = bool
        
        self.FoodRadio[0].isUserInteractionEnabled = bool
        self.FoodRadio[1].isUserInteractionEnabled = bool
        
        self.MedicinesRadio[0].isUserInteractionEnabled = bool
        self.MedicinesRadio[1].isUserInteractionEnabled = bool
        
        self.PlantsRadio[0].isUserInteractionEnabled = bool
        self.PlantsRadio[1].isUserInteractionEnabled = bool
        
        self.InsectsRadio[0].isUserInteractionEnabled = bool
        self.InsectsRadio[1].isUserInteractionEnabled = bool
        
        self.otherAllergyRadio[0].isUserInteractionEnabled = bool
        self.otherAllergyRadio[1].isUserInteractionEnabled = bool
        
        self.DiebetesRadio[0].isUserInteractionEnabled = bool
        self.DiebetesRadio[1].isUserInteractionEnabled = bool
        
        self.CancerRadio[0].isUserInteractionEnabled = bool
        self.CancerRadio[1].isUserInteractionEnabled = bool
        
        self.HeartDiseaseRadio[0].isUserInteractionEnabled = bool
        self.HeartDiseaseRadio[1].isUserInteractionEnabled = bool
        
        self.LeukemiaRadio[0].isUserInteractionEnabled = bool
        self.LeukemiaRadio[1].isUserInteractionEnabled = bool
        
        self.RestrictionRadio[0].isUserInteractionEnabled = bool
        self.RestrictionRadio[1].isUserInteractionEnabled = bool
        
        self.RecentMedicalConditionRadio[0].isUserInteractionEnabled = bool
        self.RecentMedicalConditionRadio[1].isUserInteractionEnabled = bool*/
        
        self.btn_add_foodallergy.isUserInteractionEnabled = bool
        self.btn_add_drugallergy.isUserInteractionEnabled = bool
        self.btn_add_Envirormentallergy.isUserInteractionEnabled = bool
        self.btn_add_familyhistory.isUserInteractionEnabled = bool
        self.btn_add_knowncondition.isUserInteractionEnabled = bool
        self.btn_add_geneticdisorder.isUserInteractionEnabled = bool
        
        self.btn_selectdates[0].isUserInteractionEnabled = bool
        self.btn_selectdates[1].isUserInteractionEnabled = bool
        self.btn_selectdates[2].isUserInteractionEnabled = bool
        self.btn_selectdates[3].isUserInteractionEnabled = bool
        
        self.Save.isUserInteractionEnabled = bool
        self.Save.alpha = 0.5
        self.editAllTextfield(bool: bool, objects: alltf as! [SkyFloatingLabelTextField])
    }
    @objc func addAttachmentAction(){
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.notDetermined {
                self.addAttachmentAction()
            } else {
                self.APC = DBAttachmentPickerController(finishPicking: { (attachmentArray) in
                    attachmentArray[0].loadOriginalImage(completion: { (image) in
                        let timestamp = Date().toMillis()
                        image?.accessibilityIdentifier = String(describing: timestamp)
                        self.imagename = "\(String(describing: timestamp!)).jpg"
                        print(self.imagename)
                        
                        self.imagesPicView.image = image
                    })
                    
                }, cancel: nil)
                
                self.APC.mediaType = [.image]
                self.APC.allowsMultipleSelection = false
                self.APC.allowsSelectionFromOtherApps = false
                self.APC.present(on: self)
            }
        }
    }
    @objc func setdate(datePicker: UIDatePicker){
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if DateOfBirthTF.isFirstResponder {
            DateOfBirthTF.text = df.string(from: datePicker.date)
            let calendar : NSCalendar = NSCalendar.current as NSCalendar
            let ageComponents = calendar.components(.month, from: dateview.date, to: Date() as Date, options: []).month
            let years = ageComponents! / 12
            let months = ageComponents! % 12
            self.age.text = "Age: \(years) Y / \(months) M"
        }
    }

    func fetchProfileDatail(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait...")
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "patientprofile", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                print(ApiServices.shared.data)
                self.dict = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = self.dict.value(forKey: "msg") as? String ?? ""
                if msg == "success" {
                    if let data = self.dict.value(forKey: "data") as? NSDictionary {
                        print(data)
                        DispatchQueue.main.async {
                            let pp = data.value(forKey: "profile_picture") as? String ?? ""
                            if pp != ""{
                                let url = URL(string: "\(ApiServices.shared.imageorpdfUrl)\(pp)")!
                                print(url)
                                self.imagesPicView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "man.png"), options: .continueInBackground, completed: nil)
                            }
                            else {
                                self.imagesPicView.image = #imageLiteral(resourceName: "man.png")
                            }
                            let name = data.value(forKey: "name") as? String ?? ""
                            self.NameTF.text = name
                            self.DateOfBirthTF.text = data.value(forKey: "dob") as? String ?? ""
                            UserDefaults.standard.set(pp, forKey: "profile_image")
                            UserDefaults.standard.set(name, forKey: "name")
                            UserDefaults.standard.synchronize()
                            if self.DateOfBirthTF.text == ""{
                                self.age.text = "Age"
                            } else {
                                let df = DateFormatter()
                                df.dateFormat = "yyyy-MM-dd"
                                let date = df.date(from: self.DateOfBirthTF.text!)
                                let calendar : NSCalendar = NSCalendar.current as NSCalendar
                                let ageComponents = calendar.components(.month, from: date!, to: Date() as Date, options: []).month
                                let years = ageComponents! / 12
                                let months = ageComponents! % 12
                                self.age.text = "Age: \(years) Y / \(months) M"
                            }
                            self.selectedGender = data.value(forKey: "gender") as? String ?? "1"
                            self.BloodGroupTF.text = data.value(forKey: "blood_group") as? String ?? ""
                            let email = data.value(forKey: "email") as? String ?? ""
                            self.emailTF.text = email
                            self.PatientTF.text = data.value(forKey: "patient_id") as? String ?? ""
                            
                            self.MobileNumberTF.text = data.value(forKey: "contact_no") as? String ?? ""
                            self.Address1TF.text = data.value(forKey: "address1") as? String ?? ""
                            self.Address2TF.text = data.value(forKey: "address2") as? String ?? ""
                            self.SubCityTF.text = data.value(forKey: "sub_city") as? String ?? ""
                            self.CityTF.text = data.value(forKey: "city") as? String ?? ""
                            self.pincodeTF.text = data.value(forKey: "pincode") as? String ?? ""
                            //guardian
                            self.GuardianNameTF.text = data.value(forKey: "gaurdian_name") as? String ?? ""
                            self.GuardianMobileNumberTF.text = data.value(forKey: "gaurdian_contact") as? String ?? ""
                            self.GuardianAddress1TF.text = data.value(forKey: "gaurdian_address1") as? String ?? ""
                            self.GuardianAddress2TF.text = data.value(forKey: "gaurdian_address2") as? String ?? ""
                            self.GuardianSubCityTF.text = data.value(forKey: "gaurdian_subcity") as? String ?? ""
                            self.GuardianCityTF.text = data.value(forKey: "gaurdian_city") as? String ?? ""
                            self.GuardianPincodeTF.text = data.value(forKey: "gaurdian_pincode") as? String ?? ""
                            //ec1
                            self.FirstEC_NameTF.text = data.value(forKey: "emergency_contact_name1") as? String ?? ""
                            self.FirstEC_RelationshipTF.text = data.value(forKey: "emergency_contact_relation1") as? String ?? ""
                            self.FirstEC_NumberTF.text = data.value(forKey: "emergency_contact_number1") as? String ?? ""
                            //ec2
                            self.SecondEC_NameTF.text = data.value(forKey: "emergency_contact_name2") as? String ?? ""
                            self.SecondEC_RelationshipTF.text = data.value(forKey: "emergency_contact_relation2") as? String ?? ""
                            self.SecondEC_NumberTF.text = data.value(forKey: "emergency_contact_number2") as? String ?? ""
                            //pp
                            self.PP_NameTF.text = data.value(forKey: "personal_physician_name") as? String ?? ""
                            self.PP_NumberTF.text = data.value(forKey: "personal_physician_contact") as? String ?? ""
                            let p_policy = data.value(forKey: "p_policy") as? String ?? ""
                            if p_policy == "NF"{
                                self.PP_PolicyTF.text = ""
                            }
                            else {
                                self.PP_PolicyTF.text = p_policy
                            }
                            let p_policy_Number = data.value(forKey: "p_policy_number") as? String ?? ""
                            if p_policy_Number == "0"{
                                self.PP_PolicyNumberTF.text = ""
                            }
                            else {
                                self.PP_PolicyNumberTF.text = p_policy_Number
                            }
                            //allergy
                            self.HaveAllergy = data.value(forKey: "allergy") as? String ?? "0"
                            
                            self.selectedfood = data.value(forKey: "food_alergy") as? String ?? "0"
                            let food_allergy_details = data.value(forKey: "food_allergy_details") as? String ?? ""
                            if food_allergy_details == "NF" || food_allergy_details == "" || food_allergy_details == "[]"{
                              //  self.FoodAllergyTF.text = ""
                            } else {
                                self.arr_foodallergy = food_allergy_details.convertIntoStringArray()!
                                if self.arr_foodallergy.count > 0 {
                                    self.lbl_data_foodallergy.text = self.arr_foodallergy.joined(separator: " , ")
                                }
                               // self.FoodAllergyTF.text = food_allergy_details
                            }
                            
                            self.selectedmedicine = data.value(forKey: "medicine_alergy") as? String ?? "0"
                            let medicine_allergy_details = data.value(forKey: "medicine_allergy_details") as? String ?? ""
                            if medicine_allergy_details == "NF" || medicine_allergy_details == "" || medicine_allergy_details == "[]"{
                             //   self.MedicinesAllergiesTF.text = ""
                            } else {
                                self.arr_drugallergy = medicine_allergy_details.convertIntoStringArray()!
                                if self.arr_drugallergy.count > 0 {
                                    self.lbl_data_drugallergy.text = self.arr_drugallergy.joined(separator: " , ")
                                }
                             //   self.MedicinesAllergiesTF.text = medicine_allergy_details
                            }
                            
                            self.selectedplants = data.value(forKey: "plants_allergy") as? String ?? "0"
                            let plants_allergy_details = data.value(forKey: "plants_allergy_details") as? String ?? ""
                            if plants_allergy_details == "NF" || plants_allergy_details == "" || plants_allergy_details == "[]"{
                             //   self.PlantsTF.text = ""
                            } else {
                                self.arr_environmentalallergy = plants_allergy_details.convertIntoStringArray()!
                                if self.arr_environmentalallergy.count > 0 {
                                    self.lbl_data_Envirormentallergy.text = self.arr_environmentalallergy.joined(separator: " , ")
                                }
                               // self.PlantsTF.text = plants_allergy_details
                            }
                            
                            self.selectedinsects = data.value(forKey: "insects_allergy") as? String ?? "0"
                            let insects_allergy_details = data.value(forKey: "insects_allergy_details") as? String ?? ""
                            if insects_allergy_details == "NF"{
                               // self.InsectsTF.text = ""
                            } else {
                               // self.InsectsTF.text = insects_allergy_details
                            }
                            
                            self.selectedother = data.value(forKey: "other_allergy") as? String ?? "0"
                            let other_allergy_details = data.value(forKey: "other_allergy_details") as? String ?? ""
                            if other_allergy_details == "NF" || other_allergy_details == "" || other_allergy_details == "[]"{
                             //   self.otherAllergyTF.text = ""
                            } else {
                                self.arr_familyhistory = other_allergy_details.convertIntoStringArray()!
                                if self.arr_familyhistory.count > 0 {
                                    self.lbl_data_familyhistory.text = self.arr_familyhistory.joined(separator: " , ")
                                }
                              //  self.otherAllergyTF.text = other_allergy_details
                            }
                            //medical
                            self.selectedbp = data.value(forKey: "diabetes") as? String ?? "0"
                            
                            self.selecteddiebetes = data.value(forKey: "diabetes") as? String ?? "0"
                            let diabetes_details = data.value(forKey: "diabetes_details") as? String ?? ""
                            if diabetes_details == "NF"{
                               // self.DiebetesTF.text = ""
                            } else {
                               // self.DiebetesTF.text = diabetes_details
                            }
                            
                            self.selectedcancer = data.value(forKey: "cancer") as? String ?? "0"
                            let cancer = data.value(forKey: "diabetes_details") as? String ?? ""
                            if cancer == "NF"{
                               // self.CancerTF.text = ""
                            } else {
                               // self.CancerTF.text = cancer
                            }
                            
                            self.selectedheartdisease = data.value(forKey: "heart_desease") as? String ?? "0"
                            let heart_desease = data.value(forKey: "diabetes_details") as? String ?? ""
                            if heart_desease == "NF"{
                              //  self.HeartDiseaseTF.text = ""
                            } else {
                              //  self.HeartDiseaseTF.text = heart_desease
                            }
                            
                            self.selectedleukemia = data.value(forKey: "lukemia") as? String ?? "0"
                            let lukemia = data.value(forKey: "diabetes_details") as? String ?? ""
                            if lukemia == "NF"{
                               // self.LeukemiaTF.text = ""
                            } else {
                              //  self.LeukemiaTF.text = lukemia
                            }
                            
                            self.selectedrestriction = data.value(forKey: "physical_activity_restriction") as? String ?? "0"
                            let physical_activity_restriction_details = data.value(forKey: "physical_activity_restriction_details") as? String ?? ""
                            if physical_activity_restriction_details == "NF" || physical_activity_restriction_details == "" || physical_activity_restriction_details == "[]"{
                               // self.RestrictionTF.text = ""
                            } else {
                                self.arr_geneticdisorders = physical_activity_restriction_details.convertIntoStringArray()!
                                if self.arr_geneticdisorders.count > 0 {
                                    self.lbl_data_geneticdisorder.text = self.arr_geneticdisorders.joined(separator: " , ")
                                }
                               // self.RestrictionTF.text = physical_activity_restriction_details
                            }
                            self.selectedcondition = data.value(forKey: "recent_medical_condition") as? String ?? "0"

                            let recent_medical_condition_details = data.value(forKey: "recent_medical_condition_details") as? String ?? ""
                            if recent_medical_condition_details == "NF" || recent_medical_condition_details == "" || recent_medical_condition_details == "[]"{
                               // self.RecentMedicalConditionTF.text = ""
                            } else {
                                self.arr_knowncondition = recent_medical_condition_details.convertIntoStringArray()!
                                if self.arr_knowncondition.count > 0 {
                                    self.lbl_data_knowncondition.text = self.arr_knowncondition.joined(separator: " , ")
                                }
                               // self.RecentMedicalConditionTF.text = recent_medical_condition_details
                            }
                            //last vaccination done
                            let placeholder = "Click to select date"
                            let data1 = data.value(forKey: "last_tetanus_date") as? String ?? placeholder
                            self.btn_selectdates[0].setTitle(data1, for: .normal)
                            
                            let data2 = data.value(forKey: "last_polio_date") as? String ?? placeholder
                            self.btn_selectdates[1].setTitle(data2, for: .normal)

                            let data3 = data.value(forKey: "last_diptheria_date") as? String ?? placeholder
                            self.btn_selectdates[2].setTitle(data3, for: .normal)

                            let data4 = data.value(forKey: "last_mumps_date") as? String ?? placeholder
                            self.btn_selectdates[3].setTitle(data4, for: .normal)
                            DispatchQueue.main.async {
                                // self.retrivedata()
                                self.SetupInterface()
                            }
                        }
                    }
                }
            } catch {
                print("catch")
            }
        })
        Utilities.shared.RemoveLoaderView()
    }
    func sendData()
    {
        self.back = true
        var param : [String: Any]
        param =
            [
                "name": self.NameTF.text!,
                "email": self.emailTF.text!,
                "profile_picture":self.imagename,
                "contact_no": self.MobileNumberTF.text!,
                "alt_contact_no": "",
                "gender": self.selectedGender,
                "dob": self.DateOfBirthTF.text!,
                "blood_group": self.BloodGroupTF.text!,
                "height": "",
                "address1": self.Address1TF.text!,
                "address2": self.Address2TF.text!,
                "city": self.CityTF.text!,
                "sub_city": self.SubCityTF.text!,
                "pincode": self.pincodeTF.text!,
                "gaurdian_name": self.GuardianNameTF.text!,
                "gaurdian_contact": self.GuardianMobileNumberTF.text!,
                "gaurdian_address1": self.GuardianAddress1TF.text!,
                "gaurdian_address2": self.GuardianAddress2TF.text!,
                "gaurdian_city": self.GuardianCityTF.text!,
                "gaurdian_subcity": self.GuardianSubCityTF.text!,
                "gaurdian_pincode": self.GuardianPincodeTF.text!,
                "emergency_contact_name1": self.FirstEC_NameTF.text!,
                "emergency_contact_relation1": self.FirstEC_RelationshipTF.text!,
                "emergency_contact_number1": self.FirstEC_NumberTF.text!,
                "emergency_contact_name2": self.SecondEC_NameTF.text!,
                "emergency_contact_relation2": self.SecondEC_RelationshipTF.text!,
                "emergency_contact_number2": self.SecondEC_NumberTF.text!,
                "personal_physician_name": self.PP_NameTF.text!,
                "personal_physician_contact": self.PP_NumberTF.text!,
                "p_policy": self.PP_PolicyTF.text!,
                "p_policy_number": self.PP_PolicyNumberTF.text!,
                /*"allergy": self.HaveAllergy,
                "food_alergy": self.selectedfood,
                "food_allergy_details": self.FoodAllergyTF.text!,
                "medicine_alergy": self.selectedmedicine,
                "medicine_allergy_details": self.MedicinesAllergiesTF.text!,
                "plants_allergy": self.selectedplants,
                "plants_allergy_details": self.PlantsTF.text!,
                "insects_allergy": self.selectedinsects,
                "insects_allergy_details": self.InsectsTF.text!,
                "other_allergy": self.selectedother,
                "other_allergy_details": self.otherAllergyTF.text!,
                "blood_pressure": self.selectedbp,
                "diabetes": self.selecteddiebetes,
                "diabetes_details": self.DiebetesTF.text!,
                "cancer": self.selectedcancer,
                "heart_desease": self.selectedheartdisease,
                "lukemia": self.selectedleukemia,
                "physical_activity_restriction": self.selectedrestriction,
                "physical_activity_restriction_details": self.RestrictionTF.text!,
                "recent_medical_condition": self.selectedcondition,
                "recent_medical_condition_details": self.RecentMedicalConditionTF.text!*/
                "allergy": self.HaveAllergy,
                "food_alergy": self.selectedfood,
                "medicine_alergy": self.selectedmedicine,
                "plants_allergy": self.selectedplants,
                "insects_allergy": self.selectedinsects,
                "insects_allergy_details": "",
                "other_allergy": self.selectedother,
                "blood_pressure": self.selectedbp,
                "diabetes": self.selecteddiebetes,
                "diabetes_details": "",
                "cancer": self.selectedcancer,
                "heart_desease": self.selectedheartdisease,
                "lukemia": self.selectedleukemia,
                "physical_activity_restriction": self.selectedrestriction,
                "recent_medical_condition": self.selectedcondition,
                
                "food_allergy_details": json(from: self.arr_foodallergy)!,
                "medicine_allergy_details": json(from: self.arr_drugallergy)!,
                "plants_allergy_details": json(from: self.arr_environmentalallergy)!,
                "other_allergy_details": json(from: self.arr_familyhistory)!,
                "recent_medical_condition_details": json(from: self.arr_knowncondition)!,
                "physical_activity_restriction_details": json(from: self.arr_geneticdisorders)!
        ]
        let pl = "Click to select date"
        if self.btn_selectdates[0].titleLabel?.text != pl{
            param["last_tetanus_date"] = self.btn_selectdates[0].titleLabel?.text!
        }
        if self.btn_selectdates[1].titleLabel?.text! != pl{
            param["last_polio_date"] = self.btn_selectdates[1].titleLabel?.text!
        }
        if self.btn_selectdates[2].titleLabel?.text != pl{
            param["last_diptheria_date"] = self.btn_selectdates[2].titleLabel?.text!
        }
        if self.btn_selectdates[3].titleLabel?.text != pl{
            param["last_mumps_date"] = self.btn_selectdates[3].titleLabel?.text!
        }
        print("param: \(param)")
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Updating data")
        
        ApiServices.shared.FetchPostDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "patienteditprofile", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    DispatchQueue.main.async {
                        if msg == "success"{
                            if self.imagename != "" {
                                UserDefaults.standard.set(self.imagename, forKey: "profile_image")
                            }
                            UserDefaults.standard.set(self.NameTF.text!, forKey: "name")
                            UserDefaults.standard.synchronize()
                            self.uploadimage()
                            self.view.showToast("Update Profile Details Successfully", position: .bottom, popTime: 3.0, dismissOnTap: true)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                if let error = json.value(forKey: "error") as? NSDictionary{
                    DispatchQueue.main.async {
                        if let email = error.value(forKey: "email") as? [String]{
                            self.view.showToast(email.joined(), position: .bottom, popTime: 5, dismissOnTap: true)
                        }
                        else if let contact_no = error.value(forKey: "contact_no") as? [String]{
                            self.view.showToast(contact_no.joined(), position: .bottom, popTime: 5, dismissOnTap: true)
                        }
                        else if let name = error.value(forKey: "name") as? [String]{
                            self.view.showToast(name.joined(), position: .bottom, popTime: 5, dismissOnTap: true)
                        }
                    }
                }
                
                print("json-\(json)")
            } catch {
                print("catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            param
        }
        Utilities.shared.RemoveLoaderView()
    }
    func uploadimage(){
        ApiServices.shared.FetchMultiformDataWithImageFromUrl(vc: self, Url: ApiServices.shared.medocDoctorUrl + "add_files", parameter: nil, bearertoken: bearertoken!, image: self.imagesPicView.image!, filename: self.imagename, filePathKey: "images[]", pdfurl: pdfurl, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                
                print("image-\(json)")
            } catch {
                print("image catch")
            }
        })
    }
    
}

extension ProfilePageViewController {//setupinterface
    
    func minimizeHeight(objects: [UIView],heightContantOutlet: [NSLayoutConstraint]){
        for obj in objects{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.isHidden = true
            }
        }
        for obj in heightContantOutlet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.constant = 0
            }
        }
    }
    func maximizeHeight(objects: [UIView],heightContantOutlet: [NSLayoutConstraint]){
        for obj in objects{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.isHidden = false
            }
        }
        for obj in heightContantOutlet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.constant = 40
            }
        }
    }
    @IBAction func ClicktoSelectDate(sender: UIButton){
        self.datePicker(done_complation: {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let datestr = formatter.string(from: self.dateview.date)
            
            if sender.tag == 1{
                self.btn_selectdates[0].setTitle(datestr, for: .normal)
            }
            else if sender.tag == 2{
                self.btn_selectdates[1].setTitle(datestr, for: .normal)
            }
            else if sender.tag == 3{
                self.btn_selectdates[2].setTitle(datestr, for: .normal)
            }
            else if sender.tag == 4{
                self.btn_selectdates[3].setTitle(datestr, for: .normal)
            }
        })
    }
    func SetupInterface(){

        DispatchQueue.main.async {
            self.GenderRadio[Int(self.selectedGender)! - 1].isSelected = true
            
//            if self.HaveAllergy == "0"{
//                self.AllergyRadio[1].isSelected = true
//                self.hideAllergy()
//            } else if self.HaveAllergy == "1" {
//                self.showAllergy()
//                self.AllergyRadio[0].isSelected = true
//            }
//            self.HeightOFallergyView.constant = 0
//            self.bottomContraint.isActive = false
//            self.allergyView.isHidden = true
        }
        //4CAF50
      //  minimize()
        
       // yesORnoActionInsideAllergyView()
    }
    func minimize(){
        minimizeHeight(objects: [FoodAllergyTF,MedicinesAllergiesTF,PlantsTF,InsectsTF,DiebetesTF,CancerTF,HeartDiseaseTF,LeukemiaTF,otherAllergyTF,RestrictionTF],heightContantOutlet:  [HeightOfFoodTF,HeightOfMedicinesTF,HeightOfPlantsTF,HeightOfInsectsTF,HeightOfDiebetesTF,HeightOfCancerTF,HeightOfHeartDiseaseTF,HeightOfLeukemiaTF,HeightOfotherAllergyTF,HeightOfRestrictionTF])
    }
    @IBAction func AllergyRadioAction(sender: SKRadioButton){
        self.AllergyRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 3{//yes
            showAllergy()
        }
        else if sender.tag == 4{//no
            hideAllergy()
        }
    }
    func showAllergy(){
        HaveAllergy = "1"
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.allergyView.isHidden = false
                self.HeightOFallergyView.constant = 227
                self.allergyView.alpha = 1
                self.bottomContraint.isActive = true
                self.view.layoutIfNeeded()
            })
        }
    }
    func hideAllergy(){
        HaveAllergy = "0"
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.allergyView.isHidden = true
                self.HeightOFallergyView.constant = 0
                self.allergyView.alpha = 0
                self.bottomContraint.isActive = false
                self.view.layoutIfNeeded()
            })
        }
    }
    func yesORnoActionInsideAllergyView(){
        if HaveAllergy == "0"{
            hideAllergy()
        }
        else if HaveAllergy == "1"{
            showAllergy()
        }
        
        FoodRadio[Int(selectedfood)!].isSelected = true
        if selectedfood == "1"{
            FoodRadio[0].isSelected = false
            maximizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        } else if selectedfood == "0"{
            FoodRadio[1].isSelected = false
            minimizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
        
        MedicinesRadio[Int(selectedmedicine)!].isSelected = true
        if selectedmedicine == "1"{
            MedicinesRadio[0].isSelected = false
            maximizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        } else if selectedmedicine == "0"{
            MedicinesRadio[1].isSelected = false
            minimizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
        
        PlantsRadio[Int(selectedplants)!].isSelected = true
        if selectedplants == "1"{
            PlantsRadio[0].isSelected = false
            maximizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        } else if selectedplants == "0"{
            PlantsRadio[1].isSelected = false
            minimizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
        
        InsectsRadio[Int(selectedinsects)!].isSelected = true
        if selectedinsects == "1"{
            InsectsRadio[0].isSelected = false
            maximizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        } else if selectedinsects == "0"{
            InsectsRadio[1].isSelected = false
            minimizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
        
        otherAllergyRadio[Int(selectedother)!].isSelected = true
        if selectedother == "1"{
            otherAllergyRadio[0].isSelected = false
            maximizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        } else if selectedother == "0"{
            otherAllergyRadio[1].isSelected = false
            minimizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
        DiebetesRadio[Int(selecteddiebetes)!].isSelected = true
        if selecteddiebetes == "1"{
            DiebetesRadio[0].isSelected = false
            maximizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        } else if selecteddiebetes == "0"{
            DiebetesRadio[1].isSelected = false
            minimizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
        
        CancerRadio[Int(selectedcancer)!].isSelected = true
        if selectedcancer == "1"{
            CancerRadio[0].isSelected = false
          //  maximizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        } else if selectedcancer == "0"{
            CancerRadio[1].isSelected = false
          //  minimizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
        
        HeartDiseaseRadio[Int(selectedheartdisease)!].isSelected = true
        if selectedheartdisease == "1"{
            HeartDiseaseRadio[0].isSelected = false
           // maximizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        } else if selectedheartdisease == "0"{
            HeartDiseaseRadio[1].isSelected = false
           // minimizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
        
        LeukemiaRadio[Int(selectedleukemia)!].isSelected = true
        if selectedleukemia == "1"{
            LeukemiaRadio[0].isSelected = false
         //   maximizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        } else if selectedleukemia == "0"{
            LeukemiaRadio[1].isSelected = false
           // minimizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
        
        RestrictionRadio[Int(selectedrestriction)!].isSelected = true
        if selectedrestriction == "1"{
            RestrictionRadio[0].isSelected = false
            maximizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        } else if selectedrestriction == "0"{
            RestrictionRadio[1].isSelected = false
            minimizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
        
        if self.selectedcondition == "0"{
            RecentMedicalConditionRadio[1].isSelected = true
            minimizeHeight(objects: [RecentMedicalConditionTF], heightContantOutlet: [HeightOfRecentMedicalConditionTF])
        } else if self.selectedcondition == "1" {
            RecentMedicalConditionRadio[0].isSelected = true
            maximizeHeight(objects: [RecentMedicalConditionTF], heightContantOutlet: [HeightOfRecentMedicalConditionTF])
        }
    }
   
}
extension ProfilePageViewController: PassSelectionData { //button action
    @IBAction func GenderRadioAction(sender: SKRadioButton){
        self.GenderRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 5{
            selectedGender = "1"
        }
        else if sender.tag == 6{
            selectedGender = "2"
        }
        else if sender.tag == 7{
            selectedGender = "3"
        }
    }
    @IBAction func FoodYesOrNo(sender: SKRadioButton){
        self.FoodRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 11 {
            self.selectedfood = String(1)
            maximizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
        else if sender.tag == 12 {
            self.selectedfood = String(0)
            minimizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
    }
    @IBAction func MedicineYesOrNo(sender: SKRadioButton){
        self.MedicinesRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 13 {
            self.selectedmedicine = String(1)
            maximizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
        else if sender.tag == 14 {
            self.selectedmedicine = String(0)
            minimizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
    }
    @IBAction func PlantsYesOrNo(sender: SKRadioButton){
        self.PlantsRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 15 {
            self.selectedplants = String(1)
            maximizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
        else if sender.tag == 16 {
            self.selectedplants = String(0)
            minimizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
    }
    @IBAction func InsectsYesOrNo(sender: SKRadioButton){
        self.InsectsRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 17 {
            self.selectedinsects = String(1)
            maximizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
        else if sender.tag == 18 {
            self.selectedinsects = String(0)
            minimizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
    }
    @IBAction func DiebetesYesOrNo(sender: SKRadioButton){
        self.DiebetesRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 21 {
            self.selecteddiebetes = String(1)
            maximizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
        else if sender.tag == 22 {
            self.selecteddiebetes = String(0)
            minimizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
    }
    @IBAction func CancerYesOrNo(sender: SKRadioButton){
        self.CancerRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 23 {
            self.selectedcancer = String(1)
           // maximizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
        else if sender.tag == 24 {
            self.selectedcancer = String(0)
          //  minimizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
    }
    @IBAction func HeartDiseaseYesOrNo(sender: SKRadioButton){
        self.HeartDiseaseRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 25 {
            self.selectedheartdisease = String(1)
         //   maximizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
        else if sender.tag == 26 {
            self.selectedheartdisease = String(0)
          //  minimizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
    }
    @IBAction func LeukemiaYesOrNo(sender: SKRadioButton){
        self.LeukemiaRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 27 {
            self.selectedleukemia = String(1)
         //   maximizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
        else if sender.tag == 28 {
            self.selectedleukemia = String(0)
          //  minimizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
    }
    @IBAction func otherAllergyYesOrNo(sender: SKRadioButton){
        self.otherAllergyRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 29 {
            self.selectedother = String(1)
            maximizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
        else if sender.tag == 30 {
            self.selectedother = String(0)
            minimizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
    }
    @IBAction func RestrictionYesOrNo(sender: SKRadioButton){
        self.RestrictionRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 31 {
            self.selectedrestriction = String(1)
            maximizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
        else if sender.tag == 32 {
            self.selectedrestriction = String(0)
            minimizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
    }
    @IBAction func RecentMedicalConditionAction(sender: SKRadioButton){
        self.RecentMedicalConditionRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 8 {
            self.selectedcondition = String(1)
            maximizeHeight(objects: [RecentMedicalConditionTF], heightContantOutlet: [HeightOfRecentMedicalConditionTF])
        }
        else if sender.tag == 9 {
            self.selectedcondition = String(0)
            minimizeHeight(objects: [RecentMedicalConditionTF], heightContantOutlet: [HeightOfRecentMedicalConditionTF])
        }
    }
    
    
    @IBAction func foodallergy(sender: UIButton){
        gotoSelectionVC(type: .food_allergies, arr: self.arr_foodallergy)
    }
    @IBAction func drugallergy(sender: UIButton){
        gotoSelectionVC(type: .drug_allergies, arr: self.arr_drugallergy)
    }
    @IBAction func environmentallergy(sender: UIButton){
        gotoSelectionVC(type: .Environmental_allergies, arr: self.arr_environmentalallergy)
    }
    @IBAction func familyhistory(sender: UIButton){
        gotoSelectionVC(type: .family_history, arr: self.arr_familyhistory)
    }
    @IBAction func knowncondition(sender: UIButton){
        gotoSelectionVC(type: .known_conditions, arr: self.arr_knowncondition)
    }
    @IBAction func geneticdisorder(sender: UIButton){
        gotoSelectionVC(type: .genetic_disorders, arr: self.arr_geneticdisorders)
    }
    func gotoSelectionVC(type: TypeSelection,arr: [String]){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        vc.selected = type
        vc.selectedrowdata = arr
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    func checkmarkdata(type: TypeSelection,Array: [String]) {
        switch type{
        case .food_allergies:
            self.arr_foodallergy = Array
            let str = self.arr_foodallergy.joined(separator: " , ")
            if Array.count == 0{
                self.lbl_data_foodallergy.text = "None"
            } else {
                self.lbl_data_foodallergy.text = str
            }
            break;
        case .drug_allergies:
            self.arr_drugallergy = Array
            let str = self.arr_drugallergy.joined(separator: " , ")
            if Array.count == 0{
                self.lbl_data_drugallergy.text = "None"
            } else {
                self.lbl_data_drugallergy.text = str
            }
            break;
        case .Environmental_allergies:
            self.arr_environmentalallergy = Array
            let str = self.arr_environmentalallergy.joined(separator: " , ")
            if Array.count == 0{
                self.lbl_data_Envirormentallergy.text = "None"
            } else {
                self.lbl_data_Envirormentallergy.text = str
            }
            break;
        case .family_history:
            self.arr_familyhistory = Array
            let str = self.arr_familyhistory.joined(separator: " , ")
            if Array.count == 0{
                self.lbl_data_familyhistory.text = "None"
            } else {
                self.lbl_data_familyhistory.text = str
            }
            break;
        case .known_conditions:
            self.arr_knowncondition = Array
            let str = self.arr_knowncondition.joined(separator: " , ")
            if Array.count == 0{
                self.lbl_data_knowncondition.text = "None"
            } else {
                self.lbl_data_knowncondition.text = str
            }
            break;
        case .genetic_disorders:
            self.arr_geneticdisorders = Array
            let str = self.arr_geneticdisorders.joined(separator: " , ")
            if Array.count == 0{
                self.lbl_data_geneticdisorder.text = "None"
            } else {
                self.lbl_data_geneticdisorder.text = str
            }
            break;
        default:
            break;
        }
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
extension ProfilePageViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.bloodtypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.bloodtypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.bloodtypes.count == 0{
            
        } else {
            self.BloodGroupTF.text = self.bloodtypes[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel{
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = self.bloodtypes[row]
        
        return label
    }
    func datePicker(done_complation: @escaping ()->()){
        let vc = UIViewController()
        
        let editRadiusAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let width = editRadiusAlert.view.frame.width
        vc.preferredContentSize = CGSize(width: width,height: 240)
        dateview = UIDatePicker(frame: CGRect(x: 0, y: 0, width: width, height: 240))
        dateview.datePickerMode = .date
        dateview.maximumDate = Date()
        vc.view.addSubview(dateview)
        
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            done_complation()
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
}
