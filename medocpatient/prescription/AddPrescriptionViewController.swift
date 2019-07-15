//
//  AddPrescriptionViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 15/7/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import DropDown
extension Array {
    func dictionary<K: Hashable, V>() -> [K: V] where Element == Dictionary<K, V>.Element {
        var dictionary = [K: V]()
        for element in self {
            dictionary[element.key] = element.value
        }
        return dictionary
    }
}
class AddPrescriptionViewController: UIViewController {

    @IBOutlet var close : UIButton!

    @IBOutlet var tf_doctorname: UITextField!
    @IBOutlet var tf_doctortype: UITextField!
    @IBOutlet var tf_patientproblem: UITextField!
    
    @IBOutlet var btn_clickPrescriptionImages : UIButton!
    @IBOutlet var btn_selectMedicine : UIButton!
    @IBOutlet var btn_Done : UIButton!
    
    var doctortypelist = [[String:String]]()
    var filter_doctortypelist = [[String:String]]()
    let dropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tf_doctortype.addTarget(self, action: #selector(handle_tf_doctortype), for: .editingChanged)
        
        dropdown.anchorView = tf_doctortype
        
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 15)
        dropdown.width = self.tf_doctortype.frame.width
        
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tf_doctortype.text = item
            print("Selected item: \(item) at index: \(index)")
        }
        
        fetchDoctorType()
        // Do any additional setup after loading the view.
    }
    func fetchDoctorType(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.medocDoctorUrl + "type_of_doctors", bearertoken: "") {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = json.value(forKey: "msg") as? String
                if msg == "success" {
                    if let data = json.value(forKey: "data") as? [[String:String]] {
                        self.doctortypelist = data
                        self.filter_doctortypelist = self.doctortypelist
                        print(data.count)
                    }
                }
            } catch {
                print("catch")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    @objc func closeAction(){
        // self.dismiss(animated: true, completion: nil)
        navigationController?.popViewControllerWithFlipAnimation(Self: self)
    }
    @objc func handle_tf_doctortype(){
        if (self.tf_doctortype.text?.isEmpty)! {
            dropdown.hide()
            filter_doctortypelist = self.doctortypelist
            self.dropdown.dataSource = self.filter_doctortypelist.map { $0["name"]! }
            print(self.dropdown.dataSource.count)
            self.dropdown.reloadAllComponents()
        } else {
            dropdown.show()
            filter_doctortypelist = self.doctortypelist.filter { $0["name"]!.contains(find: tf_doctortype.text!) }.map { $0 }
//            filter_doctortypelist = self.doctortypelist.map { $0 }.filter({ (filterdata) -> Bool in
//                self.dropdown.reloadAllComponents()
//                let text = tf_doctortype.text!
//                let singlevalue = filterdata.compactMap { $0.key["name"] }
//                return singlevalue.hasPrefixCheck(prefix: text, isCaseSensitive: false)
//                // return filterdata.localizedCaseInsensitiveContains(text)
//            })
            dropdown.dataSource = self.filter_doctortypelist.map { $0["name"]! }
            self.dropdown.reloadAllComponents()
        }
    }
}
