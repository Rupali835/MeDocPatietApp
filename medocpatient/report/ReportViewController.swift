//
//  ReportViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    
    var items : [Reports] = []
    var dict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddAction))
        self.navigationItem.rightBarButtonItem = add
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reload(){
        self.tableview.reloadData()
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
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "reports", parameter: "", onSuccessCompletion: {
            do {
                print(ApiServices.shared.data)
                self.dict = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(self.dict)
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
extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reportcell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! ReportTableViewCell
        reportcell.pre.text = "Selected Prescription: \(items[indexPath.row].selectedPrescription!)"
        reportcell.images.image = UIImage(data: items[indexPath.row].reportimage!)
        reportcell.remark.text = "About Report: \(items[indexPath.row].aboutReport!)"
        reportcell.date.text = "date: \(items[indexPath.row].date!)"
        return reportcell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
