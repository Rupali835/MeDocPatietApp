//
//  SelectionViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 16/4/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

enum TypeSelection {
    case food_allergies
    case drug_allergies
    case Environmental_allergies
    case family_history
    case known_conditions
    case genetic_disorders
    case none
}
protocol PassSelectionData: class {
    func checkmarkdata(type: TypeSelection,Array: [String])
}
class SelectionViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    @IBOutlet var tf_addnew: UITextField!
    @IBOutlet var btn_add: UIButton!
    @IBOutlet var btn_cancel: UIButton!
    @IBOutlet var btn_save: UIButton!
    @IBOutlet var navtitle: UILabel!
    
    var data = [String]()
    var selected = TypeSelection.food_allergies
    var selectedrowdata = [String]()
    
    weak var delegate: PassSelectionData!
    
    let food_allergies = ["Cheese","Curd","Egg","Garlic","Gluten","Lemon","Meat","Milk","Nuts","Oats","Other Fruits","Peanut","Peppers","Preserved Foods","Shellfish/Fish","Soya","Synthetic Colouring","Tamarind","Wheat"]
    
    let drug_allergies = ["Antibiotics","Carbamazepine (Tegretol)","Cardiovascular Drugs","Contrast Dye","Local Anaesthetics (Xylocaine,Lignocaine)","NSAIDS","Oral Contraceptives","PainKillers","Penicillin","Phenytoin (Eptoin)","Psychiatric Drugs","Sedatives","Sulfa Drugs","Vaccines"]
    
    let Environmental_allergies = ["Cat,Dog,Pet Hair","Chemicals","Cosmetics","Detergents","Dust","Dust Mites","Gold","Hair Dye","Insect Sting","Insecticides","Latex","Medical Spirit","Metals","Mold","Perfume","Pollen","Smoke","Soap","Sunlight","Tattoo Ink"]
    
    let family_history = ["Alcohol Intake","Allergy","Alzheimer's Disease/Dementia","Arthritis","Asthma","Blood Clots","Cancer","Depression","Diabetes","Epilepsy","Heart Disease","High Blood Pressure","High Cholesterol","Liver Disease","Mental Health History","Pregnancy Losses and Birth Defects","Retinitis Pigmentosa","Smoking","Stroke"]
    
    let known_conditions = ["Arthritis","Asthma","Chest Pain","Diabetes","Epilepsy","Gout","HIV","High Cholesterol","Hypertension","Mental Health History","Metal Implant","Pacemaker","Previous Long Term illness","Previous Surgery","Retroviral Disease","Stroke","Substance Abuse","Tuberculosis"]
    
    let genetic_disorders = ["Colour Blindness","Cystic Fibrosis","Down's Syndrome","G6PD Deficiency","Haemochromatosis","Haemophilia","Klinefelter's Syndrome","Muscular Dystrophy","Neurofibromatosis","Phenylketonuria","Retintis Pigmentosa","Sickle Cell Anaemia","Thalassemia","Turner Syndrome"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.tableview.allowsMultipleSelection = true
        
        btn_add.addTarget(self, action: #selector(Action_Add), for: .touchUpInside)
        btn_save.addTarget(self, action: #selector(Action_Save), for: .touchUpInside)
        btn_cancel.addTarget(self, action: #selector(Action_Cancel), for: .touchUpInside)

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(food_allergies, forKey: "food_allergies")
            UserDefaults.standard.set(drug_allergies, forKey: "drug_allergies")
            UserDefaults.standard.set(Environmental_allergies, forKey: "Environmental_allergies")
            UserDefaults.standard.set(family_history, forKey: "family_history")
            UserDefaults.standard.set(known_conditions, forKey: "known_conditions")
            UserDefaults.standard.set(genetic_disorders, forKey: "genetic_disorders")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        switch selected{
        case .food_allergies:
            self.data = UserDefaults.standard.array(forKey: "food_allergies") as! [String]
            self.navtitle.text = "Food Allergies"
            break;
        case .drug_allergies:
            self.data = UserDefaults.standard.array(forKey: "drug_allergies") as! [String]
            self.navtitle.text = "Drug Allergies"
            break;
        case .Environmental_allergies:
            self.data = UserDefaults.standard.array(forKey: "Environmental_allergies") as! [String]
            self.navtitle.text = "Environmental Allergies"
            break;
        case .family_history:
            self.data = UserDefaults.standard.array(forKey: "family_history") as! [String]
            self.navtitle.text = "Family History"
            break;
        case .known_conditions:
            self.data = UserDefaults.standard.array(forKey: "known_conditions") as! [String]
            self.navtitle.text = "Known Conditions"
            break;
        case .genetic_disorders:
            self.data = UserDefaults.standard.array(forKey: "genetic_disorders") as! [String]
            self.navtitle.text = "Genetic Disorders"
            break;
        default:
            self.data.removeAll()
            self.navtitle.text = ""
            break;
        }
        for item in self.selectedrowdata {
            if !self.data.contains(item){
                self.data.append(item)
                self.tableview.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    @objc func Action_Add(){
        if tf_addnew.text?.isEmpty == true{
            Utilities.shared.showToast(text: "Empty Textfield", duration: 3.0)
        }
        else {
            self.data.append(tf_addnew.text!)
            self.tableview.beginUpdates()
            let indexpath = IndexPath(row: self.data.count - 1, section: 0)
            self.tableview.insertRows(at: [indexpath], with: .automatic)
            self.selectedrowdata.append(tf_addnew.text!)
            self.tableview.reloadData()
            self.tableview.endUpdates()
            Utilities.shared.showToast(text: "New Added & Selected Succesfully", duration: 3.0)
            self.tf_addnew.text = ""
            self.tableview.scrollToRow(at: indexpath, at: .bottom, animated: false)
        }
    }
    @objc func Action_Save(){
        switch selected{
        case .food_allergies:
            UserDefaults.standard.set(self.data, forKey: "food_allergies")
            break;
        case .drug_allergies:
            UserDefaults.standard.set(self.data, forKey: "drug_allergies")
            break;
        case .Environmental_allergies:
            UserDefaults.standard.set(self.data, forKey: "Environmental_allergies")
            break;
        case .family_history:
            UserDefaults.standard.set(self.data, forKey: "family_history")
            break;
        case .known_conditions:
            UserDefaults.standard.set(self.data, forKey: "known_conditions")
            break;
        case .genetic_disorders:
            UserDefaults.standard.set(self.data, forKey: "genetic_disorders")
            break;
        default:
            break;
        }
        UserDefaults.standard.synchronize()
        delegate.checkmarkdata(type: self.selected, Array: self.selectedrowdata)
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
    }
    @objc func Action_Cancel(){
        let str = self.selectedrowdata.joined(separator: " , ")
        print(str)
        self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
       // self.dismiss(animated: true, completion: nil)
    }
}

extension SelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
        cell.selectionStyle = .none
        cell.name.text = data[indexPath.row]
        for item in selectedrowdata {
            if item == data[indexPath.row]{
                cell.accessoryType = .checkmark
                break
            }
            else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                let findindex = self.selectedrowdata.firstIndex(of: data[indexPath.row])
                self.selectedrowdata.remove(at: findindex!)
            } else {
                cell.accessoryType = .checkmark
                self.selectedrowdata.append(data[indexPath.row])
            }
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            let findindex = self.selectedrowdata.firstIndex(of: data[indexPath.row])
            self.selectedrowdata.remove(at: findindex!)
        }
    }
}
