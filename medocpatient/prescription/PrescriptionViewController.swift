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
    var doctorlist = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.tableview.reloadData()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddAction))
        
        NetworkManager.isReachable { _ in
            self.fetchdoctors()
            self.fetchPrescription()
            self.navigationItem.rightBarButtonItem = add
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchdoctors()
            self.fetchPrescription()
            self.navigationItem.rightBarButtonItem = add
        }
        NetworkManager.isUnreachable { _ in
            Utilities.shared.centermsg(msg: "No Internet Connection", view: self.view)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloaddata), name: NSNotification.Name("reloaddata"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reloaddata(){
        NetworkManager.isReachable { _ in
            self.fetchdoctors()
            self.fetchPrescription()
        }
    }
    @objc func AddAction(){
        let addPrescriptionVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPrescriptionViewController") as! AddPrescriptionViewController
        addPrescriptionVC.doctorlist = self.doctorlist
        navigationController?.pushViewControllerWithFlipAnimation(Self: self, pushVC: addPrescriptionVC)
        //self.present(addReportVC, animated: true, completion: nil)
    }
    func fetchdoctors(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "get-doctors-list", bearertoken: bearertoken!) {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
               // print(json)
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let d_data = json.value(forKey: "data") as? NSArray{
                            self.doctorlist = d_data
                        }
                    }
                }
            } catch {
                print("catch")
            }
        }
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
                    } else {
                        Utilities.shared.removecentermsg()
                    }
                    self.tableview.reloadData()
                    Utilities.shared.RemoveLoaderView()
                    
//                    if self.Prescriptiondata.count > 0 {
//                        self.tableview.scrollToRow(at: IndexPath(row: self.Prescriptiondata.count - 1, section: 0), at: .bottom, animated: true)
//                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.ActionToast(text: "Something Went Wrong", actionTitle: "Retry", actionHandler: {
                        self.fetchPrescription()
                    })
                }
            }
        })
    }

}
extension PrescriptionViewController: UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Prescriptiondata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Precell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionTableViewCell") as! PrescriptionTableViewCell
       // Precell.accessoryType = .disclosureIndicator
        let d = self.Prescriptiondata.object(at: indexPath.row) as! NSDictionary
        let patient_problem = d.value(forKey: "patient_problem") as! String
        let created_at = d.value(forKey: "created_at") as! String
        let doctor_id = d.value(forKey: "doctor_id") as? Int
        Precell.addedby.text = ""
        if doctor_id == 0 {
            Precell.addedby.text = "Added by Me"
            let p_added_by_patient = d.value(forKey: "p_added_by_patient") as? String
            if let strarr = p_added_by_patient?.convertIntoStringArray() {
                if strarr[0].contains(find: ".pdf") {
                    Precell.prescription_pdf.image = #imageLiteral(resourceName: "pdf.png")
                } else {
                    print("strarr:\(strarr)")
                    let url = URL(string: "http://13.234.38.193/medoc_doctor_api/\(strarr[0])")
                    Precell.prescription_pdf.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
                }
            }
        } else {
            Precell.prescription_pdf.image = #imageLiteral(resourceName: "pdf.png")
        }
        
        if patient_problem == "" || patient_problem == "NF" {
            Precell.patient_problem.text = "Not Mentioned"
        } else {
            Precell.patient_problem.text = patient_problem//"Chief Complain: \(patient_problem)"
        }
        //Precell.date.text = "Date:\(created_at)"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: created_at)
        
        let df1 = DateFormatter()
        df1.dateFormat = "dd MMM yyyy HH:mm:ss"
        let datestr = df1.string(from: date!)

        let dateSeparate = datestr.components(separatedBy: .whitespaces)
        
        Precell.date.text = dateSeparate[0]
        Precell.month.text = dateSeparate[1]
        Precell.year.text = dateSeparate[2]
        Precell.time.text = dateSeparate[3]

        return Precell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.Prescriptiondata.object(at: indexPath.row) as! NSDictionary
        let prescription_pdf = data.value(forKey: "prescription_pdf") as! String
        let patient_id = data.value(forKey: "patient_id") as! String
        let doctor_id = data.value(forKey: "doctor_id") as? Int
        
        if doctor_id == 0 {
            let p_added_by_patient = data.value(forKey: "p_added_by_patient") as? String
            if let strarr = p_added_by_patient?.convertIntoStringArray() {
                print("strarr:\(strarr)")
                if strarr[0].contains(find: ".pdf") {
                    let url = URL(string: "http://13.234.38.193/medoc_doctor_api/\(strarr[0])")
                    Utilities.shared.go_to_pdfviewer(vc: self, title: nil, pdfurl: url!)
                } else {
                    let zoomvc = self.storyboard?.instantiateViewController(withIdentifier: "ZoomImagesCollectionViewController") as! ZoomImagesCollectionViewController
                    zoomvc.imagesinstr = strarr.map { $0.replacingOccurrences(of: "uploads/", with: "") }
                    navigationController?.pushViewController(zoomvc, animated: true)
                }
            }
        } else {
            if prescription_pdf == "NF"{
                Utilities.shared.showToast(text: "No PDF Added", duration: 3.0)
            } else {
                let url = URL(string: "http://13.234.38.193/medoc_doctor_api/prescription_pdf/\(patient_id)/\(prescription_pdf)")
                Utilities.shared.go_to_pdfviewer(vc: self, title: nil, pdfurl: url!)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utilities.shared.ShowLoaderView(view: Utilities.shared.pdfVC.view, Message: "")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utilities.shared.RemoveLoaderView()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utilities.shared.RemoveLoaderView()
    }
}
