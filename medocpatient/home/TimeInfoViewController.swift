//
//  TimeInfoViewController.swift
//  medocpatient
//
//  Created by iAM on 21/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class TimeInfoViewController: UIViewController {

    @IBOutlet var lbl_headertitle : UILabel!
    @IBOutlet var lbl_breakfast: UILabel!
    @IBOutlet var lbl_lunch: UILabel!
    @IBOutlet var lbl_dinner: UILabel!
    @IBOutlet var btn_ok: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_headertitle.text = "Standard Meal Timing Chart".localized()
        lbl_breakfast.text = "Breakfast Time is 8AM".localized()
        lbl_lunch.text = "Lunch Time is 1PM".localized()
        lbl_dinner.text = "Dinner Time is 8PM".localized()
        btn_ok.setTitle("OK".localized(), for: .normal)
        // Do any additional setup after loading the view.
    }
    @IBAction func ok(){
        self.dismiss(animated: true, completion: nil)
    }
}
/*
 extension ProfilePageViewController { //coredata save and retrive
 
 func savedata(){
 let managedobject = self.appdel.persistentContainer.viewContext
 let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedobject)
 
 do {
 SwiftLoader.show(title: "Loading..", animated: true)
 let profile = NSManagedObject(entity: entity!, insertInto: managedobject)
 //user
 let imgdata: Data = (imagesPicView.image?.pngData())!
 profile.setValue(imgdata, forKey: user.image)
 profile.setValue(self.NameTF.text!, forKey: user.name)
 profile.setValue(self.selectedGender, forKey: user.gender)
 profile.setValue(self.DateOfBirthTF.text!, forKey: user.dateofbirth)
 profile.setValue(self.age.text!, forKey: user.age)
 profile.setValue(self.BloodGroupTF.text!, forKey: user.bloodGroup)
 profile.setValue(self.emailTF.text!, forKey: user.email)
 profile.setValue(self.PatientTF.text, forKey: user.patientid)
 //  profile.setValue(self.WeightTF.text!, forKey: user.weight)
 //  profile.setValue(self.HeightTF.text!, forKey: user.height)
 //  profile.setValue(self.BloodPressureTF.text!, forKey: user.bloodPressure)
 //  profile.setValue(self.TempretureTF.text!, forKey: user.temperature)
 profile.setValue(self.MobileNumberTF.text!, forKey: user.mobileNumber)
 profile.setValue(self.Address1TF.text!, forKey: user.address1)
 profile.setValue(self.Address2TF.text!, forKey: user.address2)
 profile.setValue(self.SubCityTF.text!, forKey: user.subcity)
 profile.setValue(self.CityTF.text!, forKey: user.city)
 //guardian
 profile.setValue(self.GuardianNameTF.text!, forKey: guardian.gName)
 profile.setValue(self.GuardianMobileNumberTF.text!, forKey: guardian.gMobileNumber)
 profile.setValue(self.GuardianAddress1TF.text!, forKey: guardian.gAddress1)
 profile.setValue(self.GuardianAddress2TF.text!, forKey: guardian.gAddress2)
 profile.setValue(self.GuardianSubCityTF.text!, forKey: guardian.gSubcity)
 profile.setValue(self.GuardianCityTF.text!, forKey: guardian.gCity)
 //ec1
 profile.setValue(self.FirstEC_NameTF.text!, forKey: emergencyContact.ec1name)
 profile.setValue(self.FirstEC_RelationshipTF.text!, forKey: emergencyContact.ec1relationship)
 profile.setValue(self.FirstEC_NumberTF.text!, forKey: emergencyContact.ec1number)
 //ec2
 profile.setValue(self.SecondEC_NameTF.text!, forKey: emergencyContact.ec2name)
 profile.setValue(self.SecondEC_RelationshipTF.text!, forKey: emergencyContact.ec2relationship)
 profile.setValue(self.SecondEC_NumberTF.text!, forKey: emergencyContact.ec2number)
 //pp
 profile.setValue(self.PP_NameTF.text!, forKey: emergencyContact.ppname)
 profile.setValue(self.PP_NumberTF.text!, forKey: emergencyContact.ppnumber)
 profile.setValue(self.PP_PolicyTF.text!, forKey: emergencyContact.pppolicy)
 profile.setValue(self.PP_PolicyNumberTF.text!, forKey: emergencyContact.pppolicynumber)
 //allergy
 profile.setValue(self.HaveAllergy, forKey: medical.allergy)
 
 profile.setValue(self.selectedfood, forKey: medical.afood)
 profile.setValue(self.FoodAllergyTF.text!, forKey: medical.aexplainFood)
 
 profile.setValue(self.selectedmedicine, forKey: medical.amedicine)
 profile.setValue(self.MedicinesAllergiesTF.text!, forKey: medical.aexplainMedicine)
 
 profile.setValue(self.selectedplants, forKey: medical.aplants)
 profile.setValue(self.PlantsTF.text!, forKey: medical.aexplainPlants)
 
 profile.setValue(self.selectedinsects, forKey: medical.ainsects)
 profile.setValue(self.InsectsTF.text!, forKey: medical.aexplainInsects)
 
 profile.setValue(self.selectedother, forKey: medical.aother)
 profile.setValue(self.otherAllergyTF.text!, forKey: medical.aexplainOther)
 
 //  profile.setValue(self.selectedbp, forKey: medical.mbp)
 profile.setValue(self.BPTF.text!, forKey: medical.mexplainBp)
 
 profile.setValue(self.selecteddiebetes, forKey: medical.mdiebetes)
 profile.setValue(self.DiebetesTF.text!, forKey: medical.mexplainDiebetes)
 
 profile.setValue(self.selectedcancer, forKey: medical.mcancer)
 profile.setValue(self.CancerTF.text!, forKey: medical.mexplainCancer)
 
 profile.setValue(self.selectedheartdisease, forKey: medical.mheartdisease)
 profile.setValue(self.HeartDiseaseTF.text!, forKey: medical.mexplainHeartDisease)
 
 profile.setValue(self.selectedleukemia, forKey: medical.mleukemia)
 profile.setValue(self.LeukemiaTF.text!, forKey: medical.mexplainLeukemia)
 
 profile.setValue(self.selectedrestriction, forKey: medical.mrestrict)
 profile.setValue(self.RestrictionTF.text!, forKey: medical.mexplainRestrict)
 profile.setValue(self.RecentMedicalConditionTF.text!, forKey: medical.mrecentMC)
 //last vaccination done
 profile.setValue(self.tetanusSelectedDate.text!, forKey: lastVaccinationDone.lselecteddate1)
 profile.setValue(self.polioSelectedDate.text!, forKey: lastVaccinationDone.lselecteddate2)
 profile.setValue(self.diphtheriaSelectedDate.text!, forKey: lastVaccinationDone.lselecteddate3)
 profile.setValue(self.mumpsSelectedDate.text!, forKey: lastVaccinationDone.lselecteddate4)
 profile.setValue(self.declare, forKey: lastVaccinationDone.declare)
 try managedobject.save()
 SwiftLoader.hide()
 } catch {
 SwiftLoader.hide()
 print("catch")
 }
 }
 func retrivedata(){
 let managedobject = self.appdel.persistentContainer.viewContext
 let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
 do {
 let result = try managedobject.fetch(fetchReq)
 for data in result as! [NSManagedObject]{
 //user
 SwiftLoader.show(title: "Loading..", animated: true)
 let imgdata = data.value(forKey: user.image) as? Data
 if imgdata != nil{
 self.imagesPicView.image = UIImage(data: imgdata!)
 }
 else {
 self.imagesPicView.image = #imageLiteral(resourceName: "man.png")
 }
 self.NameTF.text = data.value(forKey: user.name) as? String
 self.DateOfBirthTF.text = data.value(forKey: user.dateofbirth) as? String
 self.age.text = data.value(forKey: user.age) as? String
 self.selectedGender = data.value(forKey: user.gender) as? String ?? "0"
 self.BloodGroupTF.text = data.value(forKey: user.bloodGroup) as? String
 self.WeightTF.text = data.value(forKey: user.weight) as? String
 self.HeightTF.text = data.value(forKey: user.height) as? String
 self.BloodPressureTF.text = data.value(forKey: user.bloodPressure) as? String
 self.TempretureTF.text = data.value(forKey: user.temperature) as? String
 
 self.MobileNumberTF.text = data.value(forKey: user.mobileNumber) as? String
 self.Address1TF.text = data.value(forKey: user.address1) as? String
 self.Address2TF.text = data.value(forKey: user.address2) as? String
 self.SubCityTF.text = data.value(forKey: user.subcity) as? String
 self.CityTF.text = data.value(forKey: user.city) as? String
 //guardian
 self.GuardianNameTF.text = data.value(forKey: guardian.gName) as? String
 self.GuardianAddress1TF.text = data.value(forKey: guardian.gAddress1) as? String
 self.GuardianAddress2TF.text = data.value(forKey: guardian.gAddress2) as? String
 self.GuardianSubCityTF.text = data.value(forKey: guardian.gSubcity) as? String
 self.GuardianCityTF.text = data.value(forKey: guardian.gCity) as? String
 //ec1
 self.FirstEC_NameTF.text = data.value(forKey: emergencyContact.ec1name) as? String
 self.FirstEC_RelationshipTF.text = data.value(forKey: emergencyContact.ec1relationship) as? String
 self.FirstEC_NumberTF.text = data.value(forKey: emergencyContact.ec1number) as? String
 //ec2
 self.SecondEC_NameTF.text = data.value(forKey: emergencyContact.ec2name) as? String
 self.SecondEC_RelationshipTF.text = data.value(forKey: emergencyContact.ec2relationship) as? String
 self.SecondEC_NumberTF.text = data.value(forKey: emergencyContact.ec2number) as? String
 //pp
 self.PP_NameTF.text = data.value(forKey: emergencyContact.ppname) as? String
 self.PP_NumberTF.text = data.value(forKey: emergencyContact.ppnumber) as? String
 self.PP_PolicyTF.text = data.value(forKey: emergencyContact.pppolicy) as? String
 self.PP_PolicyNumberTF.text = data.value(forKey: emergencyContact.pppolicynumber) as? String
 //allergy
 HaveAllergy = data.value(forKey: medical.allergy) as! String
 
 selectedfood = data.value(forKey: medical.afood) as! String
 self.FoodAllergyTF.text = data.value(forKey: medical.aexplainFood) as? String
 
 selectedmedicine = data.value(forKey: medical.amedicine) as! String
 self.MedicinesAllergiesTF.text = data.value(forKey: medical.aexplainMedicine) as? String
 
 selectedplants = data.value(forKey: medical.aplants) as! String
 self.PlantsTF.text = data.value(forKey: medical.aexplainPlants) as? String
 
 selectedinsects = data.value(forKey: medical.ainsects) as! String
 self.InsectsTF.text = data.value(forKey: medical.aexplainInsects) as? String
 
 selectedother = data.value(forKey: medical.aother) as! String
 self.otherAllergyTF.text = data.value(forKey: medical.aexplainOther) as? String
 //medical
 //  selectedbp = data.value(forKey: medical.mbp) as! String
 self.BPTF.text = data.value(forKey: medical.mexplainBp) as? String
 
 selecteddiebetes = data.value(forKey: medical.mdiebetes) as! String
 self.DiebetesTF.text = data.value(forKey: medical.mexplainDiebetes) as? String
 
 selectedcancer = data.value(forKey: medical.mcancer) as! String
 self.CancerTF.text = data.value(forKey: medical.mexplainCancer) as? String
 
 selectedheartdisease = data.value(forKey: medical.mheartdisease) as! String
 self.HeartDiseaseTF.text = data.value(forKey: medical.mexplainHeartDisease) as? String
 
 selectedleukemia = data.value(forKey: medical.mleukemia) as! String
 self.LeukemiaTF.text = data.value(forKey: medical.mexplainLeukemia) as? String
 
 selectedrestriction = data.value(forKey: medical.mrestrict) as! String
 self.RestrictionTF.text = data.value(forKey: medical.mexplainRestrict) as? String
 
 self.RecentMedicalConditionTF.text = data.value(forKey: medical.mrecentMC) as? String
 //last vaccination done
 let data1 = data.value(forKey: lastVaccinationDone.lselecteddate1) as? String
 self.tetanusSelectedDate.text = data1
 
 let data2 = data.value(forKey: lastVaccinationDone.lselecteddate2) as? String
 self.polioSelectedDate.text = data2
 
 let data3 = data.value(forKey: lastVaccinationDone.lselecteddate3) as? String
 self.diphtheriaSelectedDate.text = data3
 
 let data4 = data.value(forKey: lastVaccinationDone.lselecteddate4) as? String
 self.mumpsSelectedDate.text = data4
 self.declare = data.value(forKey: lastVaccinationDone.declare) as! String
 SwiftLoader.hide()
 }
 } catch {
 SwiftLoader.hide()
 print("failed")
 }
 }
 }*/

