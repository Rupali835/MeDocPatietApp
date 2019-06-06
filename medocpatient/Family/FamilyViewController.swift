//
//  FamilyViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 5/6/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class FamilyViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    var familydetaildata = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        getRelationship()
        // Do any additional setup after loading the view.
    }
    func getRelationship(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "get-relationships", bearertoken: bearertoken!) {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print("json: \(json)")
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let data = json.value(forKey: "data") as? NSArray {
                            self.familydetaildata = data
                            print("data: \(data)")
                            DispatchQueue.main.async {
                                self.tableview.reloadData()
                            }
                        }
                    }
                }
            } catch {
                print("catch")
            }
        }
    }

}
extension FamilyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.familydetaildata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyTableViewCell") as! FamilyTableViewCell
        let d = self.familydetaildata.object(at: indexPath.row) as! NSDictionary
        let name = d.value(forKey: "name") as? String ?? ""
        let relation = d.value(forKey: "relationship") as? String ?? ""
        cell.lbl_name.text = "Name: \(name)"
        cell.lbl_relationship.text = "Relationship: \(relation)"
        cell.lbl_cheif_complain.text = ""//Cheif Complain: "
        cell.lbl_hospital_name.text = ""//Hospital Name: "
        return cell
    }
}
