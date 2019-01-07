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
    let baseUrl = "http://otgmart.com/medoc/patient-api/public/api/"
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    
    static let shared: ApiServices = ApiServices()
    private init() {}
    
    func Login_and_Register(vc: UIViewController,
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
        
        let token = AppDelegate().devicetoken
        urlReq.setValue(token, forHTTPHeaderField: "token")
        urlReq.httpBody = body
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    if Reachability.isConnectedToNetwork(){
                        print("Internet Connection Available!")
                    }else{
                        print("Internet Connection not Available!")
                        Alert.shared.basicalert(vc: vc, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
                        DispatchQueue.main.async {
                            SwiftLoader.hide()
                        }
                    }
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
            }.resume()
    }
    func FetchPostDataFromUrl(vc: UIViewController,
                            withOutBaseUrl: String,
                            parameter: String,
                            onSuccessCompletion: @escaping ()->(),
                            HttpBodyCompletion: @escaping ()->(Dictionary<String,Any>))
    {
        var urlReq = URLRequest(url: URL(string: "\(baseUrl)\(withOutBaseUrl)")!)
        urlReq.httpMethod = "Post"
        let bt = bearertoken!
        urlReq.setValue("Bearer \(bt)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.setValue("application/json", forHTTPHeaderField: "Accept")
        
        urlReq.httpBody = try? JSONSerialization.data(withJSONObject: HttpBodyCompletion(), options: [])
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    if Reachability.isConnectedToNetwork(){
                        print("Internet Connection Available!")
                    }else{
                        print("Internet Connection not Available!")
                        Alert.shared.basicalert(vc: vc, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
                        DispatchQueue.main.async {
                            SwiftLoader.hide()
                        }
                    }
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
            }.resume()
    }
    func FetchGetDataFromUrl(vc: UIViewController,
                              withOutBaseUrl: String,
                              parameter: String,
                              onSuccessCompletion: @escaping ()->(),
                              HttpBodyCompletion: @escaping ()->(Dictionary<String,Any>))
    {
        var urlReq = URLRequest(url: URL(string: "\(baseUrl)\(withOutBaseUrl)")!)
        urlReq.httpMethod = "GET"
        let bt = bearertoken!
        print(bt)
        urlReq.setValue("Bearer \(bt)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.setValue("application/json", forHTTPHeaderField: "Accept")
        
       // urlReq.httpBody = try? JSONSerialization.data(withJSONObject: HttpBodyCompletion(), options: [])
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    if Reachability.isConnectedToNetwork(){
                        print("Internet Connection Available!")
                    }else{
                        print("Internet Connection not Available!")
                        Alert.shared.basicalert(vc: vc, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
                        DispatchQueue.main.async {
                            SwiftLoader.hide()
                        }
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
                    if Reachability.isConnectedToNetwork(){
                        print("Internet Connection Available!")
                    }else{
                        print("Internet Connection not Available!")
                        Alert.shared.basicalert(vc: vc, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
                        DispatchQueue.main.async {
                            SwiftLoader.hide()
                        }
                    }
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
            }.resume()
    }
}
