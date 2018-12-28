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
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let context = appdel.persistentContainer.viewContext
        
        do{
            items = try context.fetch(Reports.fetchRequest())
            self.tableview.reloadData()
        } catch {
            
        }
    }
    @objc func AddAction(){
        let addReportVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReportViewController") as! AddReportViewController
        self.present(addReportVC, animated: true, completion: nil)
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
