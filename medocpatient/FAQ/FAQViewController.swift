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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data()
        self.tableview.reloadData()
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
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
