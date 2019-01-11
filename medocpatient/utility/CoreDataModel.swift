//
//  CoreDataModel.swift
//  MedocPatient
//
//  Created by iAM on 21/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation

struct User {
    var image = "image"
    var name = "name"
    var dateofbirth = "dateofbirth"
    var age = "age"
    var gender = "gender"
    var email = "email"
    var patientid = "patientid"
    var bloodGroup = "bloodGroup"
    var weight = "weight"
    var height = "height"
    var bloodPressure = "bloodPressure"
    var temperature = "temperature"
    
    var mobileNumber = "mobileNumber"
    var address1 = "address1"
    var address2 = "address2"
    var subcity = "subcity"
    var city = "city"
}
struct Guardian {
    var gName = "gName"
    var gMobileNumber = "gMobileNumber"
    var gAddress1 = "gAddress1"
    var gAddress2 = "gAddress2"
    var gSubcity = "gSubcity"
    var gCity = "gCity"
}
struct EmergencyContact {
    
    var ec1name = "ec1name"
    var ec1number = "ec1number"
    var ec1relationship = "ec1relationship"
    
    var ec2name = "ec2name"
    var ec2number = "ec2number"
    var ec2relationship = "ec2relationship"
    
    var ppname = "ppname"
    var ppnumber = "ppnumber"
    var pppolicy = "pppolicy"
    var pppolicynumber = "pppolicynumber"
}
struct Medical {
    
    var allergy = "allergy"
    
    var amedicine = "amedicine"
    var afood = "afood"
    var aplants = "aplants"
    var ainsects = "ainsects"
    var aother = "aother"
    
    var mbp = "mbp"
    var mdiebetes = "mdiebetes"
    var mcancer = "mcancer"
    var mheartdisease = "mheartdisease"
    var mleukemia = "mleukemia"
    
    var aexplainFood = "aexplainFood"
    var aexplainMedicine = "aexplainMedicine"
    var aexplainPlants = "aexplainPlants"
    var aexplainInsects = "aexplainInsects"
    var aexplainOther = "aexplainOther"
    
    var mexplainBp = "mexplainBp"
    var mexplainDiebetes = "mexplainDiebetes"
    var mexplainCancer = "mexplainCancer"
    var mexplainHeartDisease = "mexplainHeartDisease"
    var mexplainLeukemia = "mexplainLeukemia"
    
    var mrestrict = "mrestrict"
    var mexplainRestrict = "mexplainRestrict"
    var mrecentMC = "mrecentMC"
    
    
}
struct LastVaccinationDone {
    var lselecteddate1 = "lselecteddate1"
    var lselecteddate2 = "lselecteddate2"
    var lselecteddate3 = "lselecteddate3"
    var lselecteddate4 = "lselecteddate4"
    
    var declare = "declare"
}
