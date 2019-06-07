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
    
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    let pdfVC = UIViewController()
    var Prescriptiondata = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.tableview.reloadData()

        NetworkManager.isReachable { _ in
            self.fetchPrescription()
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchPrescription()
        }
        // Do any additional setup after loading the view.
    }
    func fetchPrescription(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait..")
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "prescriptions", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let p_data = json.value(forKey: "data") as? NSArray{
                            self.Prescriptiondata = p_data
                        }
                    }
                }
                DispatchQueue.main.async {
                    if self.Prescriptiondata.count == 0{
                        Utilities.shared.centermsg(msg: "No Prescription Added for You", view: self.view)
                    }
                    self.tableview.reloadData()
                    Utilities.shared.RemoveLoaderView()
                }
            } catch {
                print("catch")
                Utilities.shared.RemoveLoaderView()
            }
        })
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
        let created_at = d.value(forKey: "created_at") as! String
        
        Precell.prescription_pdf.image = #imageLiteral(resourceName: "pdf.png")
        Precell.patient_problem.text = "Chief Complain: \(patient_problem)"
        Precell.date.text = "Date:\(created_at)"
        return Precell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.Prescriptiondata.object(at: indexPath.row) as! NSDictionary
        let prescription_pdf = data.value(forKey: "prescription_pdf") as! String
        let patient_id = data.value(forKey: "patient_id") as! String
        if prescription_pdf == "NF"{
            Utilities.shared.showToast(text: "No PDF Added", duration: 3.0)
        } else {
            let url = URL(string: "http://medoc.co.in/medoc_doctor_api/prescription_pdf/\(patient_id)/\(prescription_pdf)")
            let webView = WKWebView()
            webView.translatesAutoresizingMaskIntoConstraints = false
            pdfVC.view.addSubview(webView)

            webView.leadingAnchor.constraint(equalTo: pdfVC.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: pdfVC.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: pdfVC.view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: pdfVC.view.bottomAnchor).isActive = true
            
            let urlRequest = URLRequest(url: url!)
            webView.navigationDelegate = self
            webView.load(urlRequest)
            
            pdfVC.navigationItem.title = "Pdf Viewer"
            self.navigationController?.pushViewController(pdfVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utilities.shared.ShowLoaderView(view: self.pdfVC.view, Message: "")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utilities.shared.RemoveLoaderView()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utilities.shared.RemoveLoaderView()
    }
}
