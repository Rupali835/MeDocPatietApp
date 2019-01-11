//
//  HealthViewController.swift
//  medocpatient
//
//  Created by iAM on 09/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class HealthViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    let list = ["Blood Pressure","Weight","Height"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    

}
extension HealthViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthcell") as! HealthListTableViewCell
        cell.title.text = self.list[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartvc = self.storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController
        self.navigationController?.pushViewController(chartvc, animated: true)
    }
}
