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
struct GetEmployee: Decodable{
    let msg : String?
    let data : [GetEmployeeData]?
    
    let kra_accepted_by_self : String?
    let kra_accepted_by_reporting_to: String?
    let kra_accepted_by_self_time : String?
    let kra_accepted_by_reporting_to_time : String?
    let user_reporting_to_id : String?
    let user_reporting_to_id_name : String?
}
struct GetEmployeeData: Decodable{
    let fb_id : String?
    let user_id : String?
    let user_id_name : String?
    let fb_name : String?
    let added_by : String?
    let added_by_name : String?
    let added_time : String?
    let approved_by : String?
    let approved_by_name : String?
    let approved_time : String?
    let fb_status : String?
    //achievement
    let ac_id: String?
    let ac_name : String?
    let ac_status : String?
   //training 
    let t_id: String?
    let t_name : String?
    let tm_id : String?
    let tm_id_name: String?
    let t_status : String?
    //training type
    let tm_name : String?
    let active : String?
    let activated_by: String?
    let activated_time : String?
    let inactivated_by: String?
    let inactivated_time : String?
    let created_by : String?
    let created_time: String?
    let modified_by : String?
    let modified_time : String?
    //my kra
    let ak_id : String?
    let kra_dept_de_id: String?
    let ak_weightage : String?
    let k_name : String?
    //my kpi
    let akp_id : String?
    let kp_name: String?
    let kp_type : String?
    let kp_id : String?
    let kpd_id : String?
    let kpd_target: String?
    let kpac_achieved : String?
    let kpac_achieved_pending : String?
}
//highlight & Lowlight
struct GetHighlight: Decodable {
    let msg : String?
    let data : [GetHighlightData]?
}
struct GetHighlightData: Decodable {
    let fkpi_id : String?
    let kp_id : String?
    let user_id : String?
    let user_id_name : String?
    let fkpi_name : String?
    let added_by : String?
    let added_by_name : String?
    let added_time : String?
    let approved_by : String?
    let approved_by_name : String?
    let approved_time : String?
    let fkpi_status : String?
    let fkpi_remark : String?
    let fkpi_actionplan : String?
}
struct GetLowlight: Decodable {
    let msg : String?
    let data : [GetLowlightData]?
}
struct GetLowlightData: Decodable {
    let fkpi_id : String?
    let kp_id : String?
    let user_id : String?
    let user_id_name : String?
    let fkpi_name : String?
    let added_by : String?
    let added_by_name : String?
    let added_time : String?
    let approved_by : String?
    let approved_by_name : String?
    let approved_time : String?
    let fkpi_status : String?
    let fkpi_remark : String?
    let fkpi_actionplan : String?
}
struct GetManager: Decodable{
    let msg : String?
    let data : [GetManagerData]?
}
struct GetManagerData: Decodable{
    let app_type : String?
    let id : String?
    let app_name : String?
    let app_for_user_id : String?
    let app_for_user_name : String?
    let timestamp : String?
    
    let user_id: String?
    let user_name: String?
}
struct GetUser: Decodable{
    let msg : String?
    let data : [GetUserData]?
}
struct GetUserData: Decodable{
    let user_id: String?
    let user_name: String?
}
