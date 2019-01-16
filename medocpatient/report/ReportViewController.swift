//
//  ReportViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit
class ReportViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

   // var items : [Reports] = []
    var dict = NSDictionary()
    var reportdata = NSArray()
    var reports = [report]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddAction))
        self.navigationItem.rightBarButtonItem = add
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reload(){
        self.fetchreport()
      //  self.tableview.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchreport()
//        let appdel = UIApplication.shared.delegate as! AppDelegate
//        let context = appdel.persistentContainer.viewContext
//
//        do{
//            items = try context.fetch(Reports.fetchRequest())
//            self.tableview.reloadData()
//        } catch {
//
//        }
    }
    @objc func AddAction(){
        let addReportVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReportViewController") as! AddReportViewController
        self.present(addReportVC, animated: true, completion: nil)
    }
    func fetchreport(){
        SwiftLoader.show(title: "Please Wait..", animated: true)
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "reports", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                print(ApiServices.shared.data)
                self.dict = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(self.dict)
                if let msg = self.dict.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let r_data = self.dict.value(forKey: "data") as? NSArray{
                            self.reportdata = r_data
                        } else {
                            DispatchQueue.main.async {
                                self.view.showToast("No Data Found", position: .bottom, popTime: 5, dismissOnTap: true)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.showToast("No Data Found", position: .bottom, popTime: 5, dismissOnTap: true)
                        }
                    }
                }
//                let decode = try JSONDecoder().decode(report.self, from: ApiServices.shared.data)
//                self.reports = [decode]
//                print(self.reports)
                DispatchQueue.main.sync {
                    self.tableview.reloadData()
                    SwiftLoader.hide()
                }
            } catch {
                print("catch")
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
}
extension ReportViewController: UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reportdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reportcell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! ReportTableViewCell
        reportcell.accessoryType = .disclosureIndicator
        let d = reportdata.object(at: indexPath.row) as! NSDictionary
        let tag = d.value(forKey: "tag") as? String ?? ""
        let created_at = d.value(forKey: "created_at") as? String ?? ""
        let prescription_id = d.value(forKey: "prescription_id") as? String ?? ""
        if let image = d.value(forKey: "image_name") as? String{
            print("image-\(image)")
            if image.contains(find: "["){
                reportcell.images.image = #imageLiteral(resourceName: "placeholder.jpg")
                if image.contains(find: "[{") {
                    let substr = image.slice(from: ":\"", to: "\",")
                    let url = URL(string: "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(substr!)")!
                    print("substrurl-\(url)")
                    reportcell.images.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder.jpg"), options: .continueInBackground, completed: nil)
                }
            }
            else if image.contains(find: ".pdf"){
                reportcell.images.image = #imageLiteral(resourceName: "placeholder--pdf.png")
            }
            else {
                let url = URL(string: "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(image)")!
                print(url)
                reportcell.images.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder.jpg"), options: .continueInBackground, completed: nil)
            }
        }
        reportcell.pre.text = "Selected Prescription: \(prescription_id)"
        reportcell.remark.text = "About Report: \(tag)"
        reportcell.date.text = "date: \(created_at)"

//        reportcell.pre.text = "Selected Prescription: \(items[indexPath.row].selectedPrescription!)"
//        reportcell.images.image = UIImage(data: items[indexPath.row].reportimage!)
//        reportcell.remark.text = "About Report: \(items[indexPath.row].aboutReport!)"
//        reportcell.date.text = "date: \(items[indexPath.row].date!)"
        
        return reportcell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = reportdata.object(at: indexPath.row) as! NSDictionary
        if let image = d.value(forKey: "image_name") as? String{
            var urlstr = ""
            if image.contains(find: "[{") {
                let substr = image.slice(from: ":\"", to: "\",")
                urlstr = "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(substr!)"
            }
            else {
                urlstr = "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(image)"
            }
            
            let webView = WKWebView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64))
            let urlRequest = URLRequest(url: URL(string: urlstr)!)
            webView.navigationDelegate = self
            webView.load(urlRequest)
            
            let pdfVC = UIViewController()
            pdfVC.view.addSubview(webView)
            self.navigationController?.pushViewController(pdfVC, animated: true)
        }
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
