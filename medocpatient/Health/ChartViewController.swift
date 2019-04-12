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

    @IBOutlet weak var viewChart: ScatterChartView!
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
    
    let startWeek = Date().startOfWeek
    let endWeek = Date().endOfWeek
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        axisFormatDelegate = self
        tableview.tableFooterView = UIView(frame: .zero)
        intervalSegment.addTarget(self, action: #selector(changeintervalSegment), for: .valueChanged)
        // Do any additional setup after loading the view.
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
        Utilities.shared.ShowLoaderView(view: self.view, Message: "")
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "viewhealthdata/\(attr)/\(timeinterval)/\(fromdate)/\(todate)", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success"{
                        if let data = json.value(forKey: "data") as? NSArray{
                            self.dataarr = data
                            if data.count > 0 {
                                self.chartvalue.removeAll()

                                DispatchQueue.main.async {
                                    if self.intervalSegment.selectedSegmentIndex == 0{
                                        self.charttype = self.dayPoint
                                    }
                                    else if self.intervalSegment.selectedSegmentIndex == 1{
                                        self.charttype = self.weekPoint
                                    }
                                    else if self.intervalSegment.selectedSegmentIndex == 2{
                                        self.charttype = self.monthPoint
                                    }
                                    else if self.intervalSegment.selectedSegmentIndex == 3{
                                        self.charttype = self.yearPoint
                                    }
                                }
                                var appendvalue = [Double]()
                                var appendvalue2 = [Double]()

                                for (index,_) in self.dataarr.enumerated() {
                                    let d = self.dataarr.object(at: index) as! NSDictionary
                                    let created_at = d.value(forKey: "created_at") as! String
                                    let blood_pressure = d.value(forKey: "blood_pressure") as? String
                                    let height = d.value(forKey: "height") as? String
                                    let weight = d.value(forKey: "weight") as? String
                                    let temperature = d.value(forKey: "temperature") as? String
                                    
                                    let dateformatter = DateFormatter()
                                    dateformatter.dateFormat = ""
                                    
                                    if self.selectedtitle == "Blood Pressure"{
                                        let arr = blood_pressure?.split(separator: "/")
                                        let systolic = arr?[0]
                                        let diastolic = arr?[1]
                                        appendvalue.append(Double(systolic!)!)
                                        appendvalue2.append(Double(diastolic!)!)
                                    }
                                    else if self.selectedtitle == "Height"{
                                        appendvalue.append(Double(height!)!)
                                    }
                                    else if self.selectedtitle == "Weight"{
                                        appendvalue.append(Double(weight!)!)
                                    }
                                    else if self.selectedtitle == "Temperature"{
                                        appendvalue.append(Double(temperature!)!)
                                    }
                                }
                                
                                self.chartvalue = appendvalue
                                
                                if appendvalue.count > 0 {
                                    self.setChart(dataPoints: self.charttype, values: self.chartvalue, values2: appendvalue2)
                                } else {
                                    self.setChart(dataPoints: self.charttype, values: self.chartvalue, values2: nil)
                                }
                                DispatchQueue.main.async {
                                    self.tableview.isHidden = false
                                    Utilities.shared.removecentermsg()
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    Utilities.shared.centermsg(msg: "No Data Available", view: self.view)
                                    self.tableview.isHidden = true
                                }
                            }
                        }
                    }
                }
                print(json)
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    Utilities.shared.RemoveLoaderView()
                    self.viewChart.data?.notifyDataChanged()
                    self.viewChart.notifyDataSetChanged()
                }
            } catch {
                print("catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
    func setChart(dataPoints: [String], values: [Double], values2: [Double]?) {
        
        var dataEntries: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        
        for (i,_) in values.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        if values2 != nil{
            for (i,_) in values2!.enumerated() {
                let dataEntry = ChartDataEntry(x: Double(i), y: values2![i])
                dataEntries2.append(dataEntry)
            }
        }
        var ChartData = ScatterChartData()
        var ChartDataSet = ScatterChartDataSet()
        var ChartDataSet2 = ScatterChartDataSet()
        
        if self.selectedtitle == "Blood Pressure" {
            ChartDataSet = ScatterChartDataSet(values: dataEntries, label: "Systolic")
            ChartDataSet2 = ScatterChartDataSet(values: dataEntries2, label: "Diastolic")
            ChartDataSet.setScatterShape(.chevronDown)
            ChartDataSet.setColor(UIColor.red)
            ChartDataSet2.setScatterShape(.chevronUp)
            ChartData = ScatterChartData(dataSets: [ChartDataSet,ChartDataSet2])
        } else {
            ChartDataSet = ScatterChartDataSet(values: dataEntries, label: selectedtitle)
            ChartDataSet.setScatterShape(.circle)
            ChartData = ScatterChartData(dataSet: ChartDataSet)
        }
        viewChart.data = ChartData
        viewChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        viewChart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        viewChart.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        ChartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 10)
        ChartDataSet2.valueFont = UIFont.boldSystemFont(ofSize: 10)

//        let xAxisValue = viewChart.xAxis
//        viewChart.xAxis.granularityEnabled = true
//        viewChart.xAxis.granularity = 1.0
//        viewChart.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
//        xAxisValue.valueFormatter = axisFormatDelegate
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
            showdatacell.firstdata.text = "\(selectedtitle): \(temperature) ºC"
            showdatacell.seconddata.text = ""
            showdatacell.date.text = "Date: \(created_at)"
        }
        else {
            print("none")
        }
        
        return showdatacell
    }
}
