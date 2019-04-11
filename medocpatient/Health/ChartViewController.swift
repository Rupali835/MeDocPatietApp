//
//  ChartViewController.swift
//  medocpatient
//
//  Created by iAM on 10/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

    @IBOutlet weak var lineviewChart: LineChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    @IBOutlet var tableview: UITableView!
    @IBOutlet var intervalSegment: UISegmentedControl!
    var dataarr = NSArray()
    var selectedtitle = ""
    
    var charttype = [String]()
    var chartvalue = [Double]()
    
    let dayPoint = ["12A","3","6","9","12P","3","6","9"]
    let weekPoint = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    let monthPoint = ["1","7","14","21","28"]
    let yearPoint = ["J","F","M","A","M","J","J","A","S","O","N","D"]

    var attr = ""
    var timeinterval = "d"
    var fromdate = "0"
    var todate = "0"
    
    var headertitle = "All Recorded Data"
    
    let startWeek = Date().startOfWeek
    let endWeek = Date().endOfWeek
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineviewChart.noDataText = "No Data"

        axisFormatDelegate = self
        tableview.tableFooterView = UIView(frame: .zero)
        intervalSegment.addTarget(self, action: #selector(changeintervalSegment), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = selectedtitle
        if selectedtitle == "Blood Pressure"{
            attr = "bp"
        }
        else if selectedtitle == "Height"{
            attr = "h"
        }
        else if selectedtitle == "Weight"{
            attr = "w"
        }
        else if selectedtitle == "Temperature"{
            attr = "t"
        }
        else {
            print("none")
        }
        fetchhealthdata()
    }
    @objc func changeintervalSegment(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            timeinterval = "d"
            fromdate = "0"
            todate = "0"
            charttype = dayPoint
            fetchhealthdata()
        }
        else if sender.selectedSegmentIndex == 1{
            timeinterval = "w"
            let df = DateFormatter()
            df.dateFormat = "YYYY-MM-DD"
            fromdate = df.string(from: startWeek!)
            todate = df.string(from: endWeek!)
            charttype = weekPoint
            fetchhealthdata()
        }
        else if sender.selectedSegmentIndex == 2{
            timeinterval = "m"
            fromdate = "0"
            todate = "0"
            charttype = monthPoint
            fetchhealthdata()
        }
        else if sender.selectedSegmentIndex == 3{
            timeinterval = "y"
            fromdate = "0"
            todate = "0"
            charttype = yearPoint
            fetchhealthdata()
        }
    }
    func fetchhealthdata(){
        SwiftLoader.show(title: "Loading", animated: true)
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "viewhealthdata/\(attr)/\(timeinterval)/\(fromdate)/\(todate)", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success"{
                        if let data = json.value(forKey: "data") as? NSArray{
                            self.dataarr = data
                            if data.count > 0 {
                                self.headertitle = "All Recorded Data"
                                self.charttype = self.dayPoint
                                self.chartvalue.removeAll()
                                
                                for (index,_) in self.dataarr.enumerated() {
                                    let d = self.dataarr.object(at: index) as! NSDictionary
                                    let created_at = d.value(forKey: "created_at") as! String

                                    if self.selectedtitle == "Blood Pressure"{
                                        
                                    }
                                    else if self.selectedtitle == "Height"{
                                        let height = d.value(forKey: "height") as! String
                                        self.chartvalue.append(Double(height)!)
                                    }
                                    else if self.selectedtitle == "Weight"{
                                        let weight = d.value(forKey: "weight") as! String
                                        self.chartvalue.append(Double(weight)!)
                                    }
                                    else if self.selectedtitle == "Temperature"{
                                        let temperature = d.value(forKey: "temperature") as! String
                                        self.chartvalue.append(Double(temperature)!)
                                    }
                                }
                                
                                self.charttype = self.dayPoint
                                self.setChart(dataPoints: self.charttype, values: self.chartvalue)
                                self.lineviewChart.data?.notifyDataChanged()
                                self.lineviewChart.notifyDataSetChanged()
                            }
                            else{
                                self.headertitle = "No Recorded Data"
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                        SwiftLoader.hide()
                    }
                }
                print(json)
            } catch {
                print("catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for (i,_) in dataPoints.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: selectedtitle)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineviewChart.data = lineChartData
        let xAxisValue = lineviewChart.xAxis
        lineviewChart.xAxis.granularityEnabled = true
        lineviewChart.xAxis.granularity = 1.0
        lineviewChart.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
        lineviewChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        lineviewChart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        lineviewChart.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        lineChartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 10)
        xAxisValue.valueFormatter = axisFormatDelegate
    }
}
extension ChartViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return charttype[Int(value)]
    }
}
extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showdatacell = tableView.dequeueReusableCell(withIdentifier: "ShowDataCell") as! ShowDataTableViewCell
        let d = self.dataarr.object(at: indexPath.row) as! NSDictionary
        let created_at = d.value(forKey: "created_at") as! String
        if selectedtitle == "Blood Pressure"{
            let blood_pressure = d.value(forKey: "blood_pressure") as! String
            showdatacell.firstdata.text = "Systolic:\(blood_pressure):Diastolic"
            showdatacell.seconddata.text = ""
            showdatacell.date.text = "Date: \(created_at)"
        }
        else if selectedtitle == "Height"{
            let height = d.value(forKey: "height") as! String
            showdatacell.firstdata.text = "\(selectedtitle): \(height) Cm"
            showdatacell.seconddata.text = ""
            showdatacell.date.text = "Date: \(created_at)"
        }
        else if selectedtitle == "Weight"{
            let weight = d.value(forKey: "weight") as! String
            showdatacell.firstdata.text = "\(selectedtitle): \(weight) Kg"
            showdatacell.seconddata.text = ""
            showdatacell.date.text = "Date: \(created_at)"
        }
        else if selectedtitle == "Temperature"{
            let temperature = d.value(forKey: "temperature") as! String
            showdatacell.firstdata.text = "\(selectedtitle): \(temperature)"
            showdatacell.seconddata.text = ""
            showdatacell.date.text = "Date: \(created_at)"
        }
        else {
            print("none")
        }
        
        return showdatacell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headertitle
    }
}
