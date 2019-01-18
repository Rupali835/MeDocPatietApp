//
//  FAQViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
enum CellState {
    case expanded
    case collapsed
}
class FAQViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    var faq = [FAQDataModal]()
    var cellstate: [CellState]?
    
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    let imagearr = [#imageLiteral(resourceName: "blood.png"),#imageLiteral(resourceName: "cardiogram.png"),#imageLiteral(resourceName: "chart.png"),#imageLiteral(resourceName: "chat.png")]
    let imagename = ["blood.png","cardiogram.png","chart.png","chat.png"]
    var pdfurl = URL(string: "NF")!
    override func viewDidLoad() {
        super.viewDidLoad()
        data()
        self.tableview.reloadData()
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    func multipleimage(){
//        for (i,img) in imagearr.enumerated() {
//            print(imagename[i])
            SwiftLoader.show(title: "adding image", animated: true)
            ApiServices.shared.FetchMultiformDataWithImageFromUrl(vc: self, withOutBaseUrl: "add_files", parameter: ["":""], bearertoken: bearertoken!, image: #imageLiteral(resourceName: "blood.png"), filename: "blood.png", filePathKey: "images[]", pdfurl: pdfurl, onSuccessCompletion: {
                do {
                    let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                    }
                    print("image\(json)")
                } catch {
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                    }
                    print("image catch")
                }
            }) { () -> (Dictionary<String, Any>) in
                [:]
            }
      //  }
        
    }
}
extension FAQViewController: UITableViewDataSource , UITableViewDelegate , FAQTableViewCelldelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faq.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let faqcell = tableView.dequeueReusableCell(withIdentifier: "FAQCell") as! FAQTableViewCell
        faqcell.question.text = faq[indexPath.row].Question
        faqcell.answer.text = faq[indexPath.row].Answer
        faqcell.delegate = self
        
        if let cellstates = cellstate{
            faqcell.answer.numberOfLines = (cellstates[indexPath.row] == .expanded) ? 0 : 3
        }
        return faqcell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func expand(cell: FAQTableViewCell) {
        if let indexpath = tableview.indexPath(for: cell){
            tableview.beginUpdates()
            cell.answer.numberOfLines = (cell.answer.numberOfLines == 0) ? 3 : 0
            self.cellstate?[indexpath.row] = (cell.answer.numberOfLines == 0) ? .expanded : .collapsed
            if (cell.answer.numberOfLines == 0){
                cell.morebutton.setTitle("Less", for: .normal)
            } else {
                cell.morebutton.setTitle("More", for: .normal)
            }
            tableview.endUpdates()
        }
    }
}
