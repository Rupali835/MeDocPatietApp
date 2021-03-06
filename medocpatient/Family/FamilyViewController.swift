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
    @objc func ActionAdd(){
        let addfamilyvc = self.storyboard?.instantiateViewController(withIdentifier: "AddFamilyMemberVC") as! AddFamilyMemberVC
        addfamilyvc.callback = { self.getRelationship() }
        let d = self.familydetaildata.object(at: 0) as! NSDictionary
        let name = d.value(forKey: "name") as? String ?? ""
        addfamilyvc.name_relationship = name
        navigationController?.pushViewControllerWithFlipAnimation(Self: self, pushVC: addfamilyvc)
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
                                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.ActionAdd))
                                self.tableview.reloadData()
                            }
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.ActionToast(text: "Something Went Wrong", actionTitle: "Retry", actionHandler: {
                        self.getRelationship()
                    })
                }
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
        let relation = d.value(forKey: "relationship") as? String ?? "Not Mentioned"
        cell.lbl_name.text = "Name: \(name)"
        if relation == "" || relation == "NF" {
            cell.lbl_relationship.text = "Relationship: Not Mentioned"
        } else {
            cell.lbl_relationship.text = "Relationship: \(relation)"
        }
        let gender = d.value(forKey: "gender") as? Int
        
        switch gender {
        case 1:
            cell.lbl_Gender.text = "Gender: Male"
        case 2:
            cell.lbl_Gender.text = "Gender: Female"
        case 3:
            cell.lbl_Gender.text = "Gender: Others"
        default:
            print("none gender")
        }
        
        let patient_id = d.value(forKey: "patient_id") as? String ?? ""
        cell.lbl_Patient_id.text = "Patient id: \(patient_id)"

        return cell
    }
}
