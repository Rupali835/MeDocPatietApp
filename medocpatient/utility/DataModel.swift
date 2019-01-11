//
//  DataModel.swift
//  Perfecto
//
//  Created by Prem Sahni on 24/10/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation
struct FAQDataModal {
    var Question : String!
    var Answer: String!
    
    init(question: String,answer: String) {
        self.Question = question
        self.Answer = answer
    }
    
}
struct report : Decodable {
    var msg : String
    var data : reportdata
}
struct reportdata: Decodable {
    
}
struct PrescriptionsGeneral: Decodable{
    var msg: String?
    var data: [PrescriptionsGeneralData]?
}
struct PrescriptionsGeneralData : Decodable{
    var prescription_id: String?
    var patientProblem: String?
}
