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

class Reports {
    var created_at : String!
    var created_by : String!
    var image_name : [[String:String]]!
    var patient_id : String!
    var prescription_id : String!
    var report_id : String!
    var tag : String!
    
    init(created_at: String,created_by: String,image_name: [[String:String]],patient_id: String,prescription_id: String,report_id: String,tag: String) {
        self.created_at = created_at
        self.created_by = created_by
        self.image_name = image_name
        self.patient_id = patient_id
        self.prescription_id = prescription_id
        self.report_id = report_id
        self.tag = tag
    }
}

class ReportViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    let pdfVC = UIViewController()

    var dict = NSDictionary()
    var reportdata = [Reports]()
    var idarray = [String]()
    var problemArray = [String]()
    var prescriptionsgeneral = [PrescriptionsGeneral]()
    var prescriptionsgeneraldata = [PrescriptionsGeneralData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddAction))
        self.tableview.estimatedRowHeight = 80.0
        
        NetworkManager.isReachable { _ in
            self.fetchPrescription()
            self.fetchreport()
            self.navigationItem.rightBarButtonItem = add
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchPrescription()
            self.fetchreport()
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
            self.reportdata.removeAll()
            self.fetchreport()
        }
    }
    @objc func AddAction(){
        let addReportVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReportViewController") as! AddReportViewController
        addReportVC.idarray = self.idarray
        addReportVC.problemArray = self.problemArray
        navigationController?.pushViewControllerWithFlipAnimation(Self: self, pushVC: addReportVC)
        //self.present(addReportVC, animated: true, completion: nil)
    }
    func fetchreport(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait...")
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "reports", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                print(ApiServices.shared.data)
                self.dict = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(self.dict)
                if let msg = self.dict.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let data = self.dict.value(forKey: "data") as? NSArray{
                            self.filterdata(r_data: data)
                            Utilities.shared.removecentermsg()
                        }
                    } else {
                        DispatchQueue.main.async {
                            Utilities.shared.centermsg(msg: "No reports found.", view: self.view)
                        }
                    }
                }
                DispatchQueue.main.sync {
                    self.tableview.reloadData()
                    Utilities.shared.RemoveLoaderView()
                }
            } catch {
                print("catch")
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.ActionToast(text: "Something Went Wrong", actionTitle: "Retry", actionHandler: {
                        self.fetchPrescription()
                        self.fetchreport()
                    })
                }
            }
        })
    }
    func filterdata(r_data: NSArray){
        self.reportdata.removeAll()
        for (index,_) in r_data.enumerated() {
            let data = r_data.object(at: index) as! NSDictionary
            if let image = data.value(forKey: "image_name") as? String {
                if image == "NF" || image == "" || image == "[]"{
                    print("NF")
                } else {
                    let created_at = data.value(forKey: "created_at") as! String
                    let created_by = data.value(forKey: "created_by") as! Int
                    let patient_id = data.value(forKey: "patient_id") as! String
                    let prescription_id = data.value(forKey: "prescription_id") as! Int
                    let report_id = data.value(forKey: "report_id") as! Int
                    let tag = data.value(forKey: "tag") as! String
                    
                    if let jsonArray = image.convertIntoJsonStringAny() {
                        if jsonArray.count > 0 {
                            let report = Reports(created_at: created_at, created_by: "\(created_by)", image_name: jsonArray, patient_id: patient_id, prescription_id: "\(prescription_id)", report_id: "\(report_id)", tag: tag)
                            self.reportdata.append(report)
                        }
                    }
                    
                }
            }
        }
    }
    func fetchPrescription(){
        self.idarray.removeAll()
        self.problemArray.removeAll()
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "prescriptionsgeneral", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let decode = try JSONDecoder().decode(PrescriptionsGeneral.self, from: ApiServices.shared.data)
                self.prescriptionsgeneral = [decode]
                DispatchQueue.global(qos: .userInteractive).async {
                    for item in self.prescriptionsgeneral {
                        self.prescriptionsgeneraldata = item.data ?? [PrescriptionsGeneralData]()
                    }
                    for item in self.prescriptionsgeneraldata{
                        self.idarray.append("\(item.prescription_id!)")
                        self.problemArray.append(item.patientProblem!)
                    }
                }
                DispatchQueue.main.sync {
                    self.tableview.reloadData()
                }
            } catch {
                print("catch")
            }
        })
    }
}
extension ReportViewController: UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reportdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reportcell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! ReportTableViewCell
      //  reportcell.accessoryType = .disclosureIndicator
        let data = self.reportdata[indexPath.row]
        reportcell.pre.text = ""
      //  reportcell.date.text = "date: \(data.created_at!)"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: data.created_at)
        
        let df1 = DateFormatter()
        df1.dateFormat = "dd MMM yyyy HH:mm:ss"
        let datestr = df1.string(from: date!)
        
        let dateSeparate = datestr.components(separatedBy: .whitespaces)
        
        reportcell.date.text = dateSeparate[0]
        reportcell.month.text = dateSeparate[1]
        reportcell.year.text = dateSeparate[2]
        reportcell.time.text = dateSeparate[3]
        
        reportcell.remark.text = data.image_name[0]["dataTag"]//"Report name: \(data.dataTag!)"
        for item in self.prescriptionsgeneraldata {
            if "\(item.prescription_id!)" == data.prescription_id {
                reportcell.pre.text = item.patientProblem!//"Prescription: \(item.patientProblem!)"
                break;
            } else {
                reportcell.pre.text = "Not Selected"//"No Prescription Selected"
            }
        }
        if (data.image_name[0]["dataName"]?.contains(find: ".pdf"))! {
            reportcell.images.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "pdf"), options: .continueInBackground, completed: nil)
        } else {
            reportcell.images.sd_setImage(with: URL(string: "\(ApiServices.shared.imageorpdfUrl)\(data.image_name[0]["dataName"]!)"), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
        }
        return reportcell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableview.cellForRow(at: indexPath) as! ReportTableViewCell
        let data = self.reportdata[indexPath.row]
        
        if (data.image_name[0]["dataName"]?.contains(find: ".pdf"))! {
            let urlstr = "\(ApiServices.shared.imageorpdfUrl)\(data.image_name[0]["dataName"]!)"
            let webView = WKWebView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64))
            print("url:\(urlstr)")
            let urlRequest = URLRequest(url: URL(string: urlstr)!)
            webView.navigationDelegate = self
            webView.load(urlRequest)
            pdfVC.navigationItem.title = "Pdf Viewer"
            pdfVC.view.addSubview(webView)
            self.navigationController?.pushViewController(pdfVC, animated: true)
        } else {
            if cell.images.image != #imageLiteral(resourceName: "placeholder.jpg"){
                //Utilities.shared.go_to_zoomimageview(vc: self, image: cell.images.image!)
                let zoomvc = self.storyboard?.instantiateViewController(withIdentifier: "ZoomImagesCollectionViewController") as! ZoomImagesCollectionViewController
                zoomvc.imagesinstr = data.image_name.map { $0["dataName"]! }
                navigationController?.pushViewController(zoomvc, animated: true)
            }
        }
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
extension String {
    func convertIntoJsonArray()->NSArray?{
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: self.data(using: .utf8)!, options : .allowFragments) as? NSArray {
                return jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    func convertIntoJsonStringAny()->[[String:String]]?{
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: self.data(using: .utf8)!, options : .allowFragments) as? [[String:String]] {
                return jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    func convertIntoStringArray()->[String]?{
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: self.data(using: .utf8)!, options : .allowFragments) as? [String] {
                return jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
