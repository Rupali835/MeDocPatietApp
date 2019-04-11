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
    let imageurl = "http://otgmart.com/medoc/medoc_doctor_api/index.php/API/"
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
        
        let token = AppDelegate().fcm_token
        urlReq.setValue(token, forHTTPHeaderField: "fcm_token")
        urlReq.httpBody = body
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
            }.resume()
    }
    func FetchPostDataFromUrl(vc: UIViewController,
                            withOutBaseUrl: String,
                            bearertoken: String,
                            parameter: String,
                            onSuccessCompletion: @escaping ()->(),
                            HttpBodyCompletion: @escaping ()->(Dictionary<String,Any>))
    {
        var urlReq = URLRequest(url: URL(string: "\(baseUrl)\(withOutBaseUrl)")!)
        urlReq.httpMethod = "Post"
        urlReq.setValue("Bearer \(bearertoken)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.setValue("application/json", forHTTPHeaderField: "Accept")
        
        urlReq.httpBody = try? JSONSerialization.data(withJSONObject: HttpBodyCompletion(), options: [])
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
            }.resume()
    }
    func FetchformPostDataFromUrl(vc: UIViewController,
                              withOutBaseUrl: String,
                              bearertoken: String,
                              parameter: String,
                              onSuccessCompletion: @escaping ()->(),
                              HttpBodyCompletion: @escaping ()->(Dictionary<String,Any>))
    {
        var urlReq = URLRequest(url: URL(string: "\(baseUrl)\(withOutBaseUrl)")!)
        urlReq.httpMethod = "Post"
        urlReq.setValue("Bearer \(bearertoken)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlReq.setValue("application/json", forHTTPHeaderField: "Accept")
        let myParams = parameter
        let postData = myParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let body = postData
        urlReq.httpBody = body
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    
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
                              bearertoken: String,
                              onSuccessCompletion: @escaping ()->(),
                              HttpBodyCompletion: @escaping ()->(Dictionary<String,Any>))
    {
        var urlReq = URLRequest(url: URL(string: "\(baseUrl)\(withOutBaseUrl)")!)
        urlReq.httpMethod = "GET"
        urlReq.setValue("Bearer \(bearertoken)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    
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
                    
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
            }.resume()
    }
    func FetchMultiformDataWithImageFromUrl(vc: UIViewController,
                             withOutBaseUrl: String,
                             parameter: [String:Any]?,
                             bearertoken: String,
                             image: UIImage?,
                             filename: String,
                             filePathKey: String,
                             pdfurl: URL,
                             onSuccessCompletion: @escaping ()->(),
                             HttpBodyCompletion: @escaping ()->(Dictionary<String,Any>))
    {
        
        var urlReq = URLRequest(url: URL(string: "\(imageurl)\(withOutBaseUrl)")!)
        urlReq.httpMethod = "Post"
        
        let boundary = generateBoundaryString()
        urlReq.setValue("Bearer \(bearertoken)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       // urlReq.setValue("application/json", forHTTPHeaderField: "Accept")
        var mimetype = ""
        var data = Data()
        
        if pdfurl.absoluteString != "NF"{
            data = try! Data(contentsOf: pdfurl)
            mimetype = "application/pdf"
        } else {
            if image != nil{
                data = image!.jpegData(compressionQuality: 0.1)!
                mimetype = "image/jpg"
            }
        }
        
        urlReq.httpBody = createBodyWithParameters(parameters: parameter, filePathKey: filePathKey, filename: filename, imageDataKey: data, boundary: boundary, mimetype: mimetype)
        
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if error != nil{
                print("error")
                if (error?.localizedDescription) != nil{
                    
                }
            } else {
                self.data = data!
                onSuccessCompletion()
            }
        }.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?,filename: String, imageDataKey: Data, boundary: String, mimetype: String) -> Data {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        let filename = filename
        let mimetype = mimetype
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageDataKey)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return body as Data
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
