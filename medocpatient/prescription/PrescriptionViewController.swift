//
//  PromotionViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import CoreData

class PrescriptionViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    @IBOutlet var cancel : UIButton!
    @IBOutlet var heightofCancel : NSLayoutConstraint!
    var status = "0"
    var selected = ""
    
    var data = ["Blood Pressure","Diabetes","Asthma","Flu (Influenza)"]
    
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
        
    }
    

}
extension PrescriptionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Precell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell") as! PrescriptionTableViewCell
        Precell.title.text = data[indexPath.row]
        return Precell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if status == "1"{
            NotificationCenter.default.post(name: NSNotification.Name("change"), object: self, userInfo: ["title" : data[indexPath.row]])
            self.dismiss(animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
