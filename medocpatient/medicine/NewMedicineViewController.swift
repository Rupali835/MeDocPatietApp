//
//  NewMedicineViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 6/5/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class NewMedicineViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        
        tableview.sectionHeaderHeight = UITableView.automaticDimension
        tableview.estimatedSectionHeaderHeight = 50;
        // Do any additional setup after loading the view.
    }
    
}
extension NewMedicineViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "headercell") as! headercell
        return header
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicinecell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineTableViewCell
        return medicinecell
    }
}

