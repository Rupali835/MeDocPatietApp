//
//  ApiServices.swift
//  Perfecto
//
//  Created by Prem Sahni on 24/10/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation
import UIKit

class ApiServices {
    var data = Data()
    let baseUrl = "http://192.168.1.112/kspatient2/public/api/"
    
    static let shared: ApiServices = ApiServices()
    private init() {}
    
    func FetchPostDataFromURL(vc: UIViewController,
                              withOutBaseUrl: String,
                              parameter: String,
                              onSuccessCompletion: @escaping ()->(),
                              HttpBodyCompletion: @escaping ()->(Dictionary<String,Any>))
    {
        var urlReq = URLRequest(url: URL(string: "\(baseUrl)\(withOutBaseUrl)")!)
        let myParams = parameter
        let postData = myParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let body = postData
        urlReq.httpMethod = "Post"
        urlReq.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //      urlReq.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        urlReq.httpBody = body
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    Alert.shared.basicalert(vc: vc, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn ON Mobile Data or Wifi Connection")
                    DispatchQueue.main.async {
                       // SwiftLoader.hide()
                    }
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
            }.resume()
    }
    func FetchGetRequestDataFromURL(vc: UIViewController,
                              withOutBaseUrl: String,
                              parameter: [String:String],
                              onSuccessCompletion: @escaping ()->(),
                              HttpBodyCompletion: @escaping ()->(Dictionary<String,Any>))
    {
        var urlcom = URLComponents(string: "\(baseUrl)\(withOutBaseUrl)")!
        urlcom.queryItems = parameter.map({ (key, value) in
            URLQueryItem(name: key, value: value)
        })
        urlcom.percentEncodedQuery = urlcom.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var urlReq = URLRequest(url: urlcom.url!)
        urlReq.httpMethod = "GET"
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    Alert.shared.basicalert(vc: vc, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn ON Mobile Data or Wifi Connection")
                    DispatchQueue.main.async {
                        // SwiftLoader.hide()
                    }
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
            }.resume()
    }
}
