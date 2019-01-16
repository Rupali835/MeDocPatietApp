//
//  PromotionViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import CoreData
import WebKit
import SDWebImage
class PrescriptionViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    @IBOutlet var cancel : UIButton!
    @IBOutlet var heightofCancel : NSLayoutConstraint!
    var status = "0"
    var selected = ""
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    var Prescriptiondata = NSArray()//["Blood Pressure","Diabetes","Asthma","Flu (Influenza)"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.tableview.reloadData()
        
        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        if status == "0"{
            DispatchQueue.main.async {
                self.heightofCancel.constant = 0
                self.cancel.isHidden = true
            }
        }
        else if status == "1"{
            DispatchQueue.main.async {
                self.heightofCancel.constant = 40
                self.cancel.isHidden = false
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchPrescription()
    }
    func fetchPrescription(){
        SwiftLoader.show(title: "Please Wait..", animated: true)
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "prescriptions", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let p_data = json.value(forKey: "data") as? NSArray{
                            self.Prescriptiondata = p_data
                            DispatchQueue.main.async {
                                self.tableview.reloadData()
                                SwiftLoader.hide()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.view.showToast("No Data Found", position: .bottom, popTime: 5, dismissOnTap: true)
                                SwiftLoader.hide()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.showToast("No Data Found", position: .bottom, popTime: 5, dismissOnTap: true)
                            SwiftLoader.hide()
                        }
                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.async {
                    self.view.showToast("No Data Found", position: .bottom, popTime: 5, dismissOnTap: true)
                    SwiftLoader.hide()
                }
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }

}
extension PrescriptionViewController: UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Prescriptiondata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Precell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell") as! PrescriptionTableViewCell
        Precell.accessoryType = .disclosureIndicator
        let d = self.Prescriptiondata.object(at: indexPath.row) as! NSDictionary
        let patient_problem = d.value(forKey: "patient_problem") as! String
        let prescription_details = d.value(forKey: "prescription_details") as! String
        let blood_pressure = d.value(forKey: "blood_pressure") as! String
        let created_at = d.value(forKey: "created_at") as! String
        let drawing_image = d.value(forKey: "drawing_image") as! String
        let handwritten_image = d.value(forKey: "handwritten_image") as! String
        let height = d.value(forKey: "height") as! String
        let other_details = d.value(forKey: "other_details") as! String
        let prescription_pdf = d.value(forKey: "prescription_pdf") as! String
        let signature_image = d.value(forKey: "signature_image") as! String
        let temperature = d.value(forKey: "temperature") as! String
        let weight = d.value(forKey: "weight") as! String


        let url = URL(string: "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(signature_image)")!
      //  Precell.signature_image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder.jpg"), options: .continueInBackground, completed: nil)
        Precell.signature_image.image = #imageLiteral(resourceName: "placeholder--pdf.png")
        Precell.patient_problem.text = "Problem: \(patient_problem)"
     //   Precell.prescription_details.text = "Detail: \(prescription_details)"
        Precell.date.text = "D:\(created_at)"
        Precell.height.text = "Height: \(height)"
        Precell.weight.text = "Weight: \(weight)"
        Precell.temperature.text = "Temp: \(temperature)"
        Precell.blood_pressure.text = "BP: \(blood_pressure)"

       // Precell.title.text = data[indexPath.row]
        return Precell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = self.Prescriptiondata.object(at: indexPath.row) as! NSDictionary
        let signature_image = d.value(forKey: "signature_image") as! String

        let url = URL(string: "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(signature_image)")
        let webView = WKWebView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64))
        let urlRequest = URLRequest(url: url!)
        webView.navigationDelegate = self
        webView.load(urlRequest)

        let pdfVC = UIViewController()
        pdfVC.view.addSubview(webView)
        //pdfVC.title = pdfTitle
        self.navigationController?.pushViewController(pdfVC, animated: true)
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SwiftLoader.show(animated: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftLoader.hide()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SwiftLoader.hide()
    }
}
