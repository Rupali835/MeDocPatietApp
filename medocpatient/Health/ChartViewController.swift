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
    var months = ["Jan","Feb","Mar","Apr","May","Jun"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    var attr = ""
    var timeinterval = "d"
    var headertitle = "All Recorded Data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setLineChart()
        setChart(dataPoints: months, values: unitsSold)

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
//            fetchhealthdata()
//            months = ["Today"]
//
//            lineviewChart.data?.notifyDataChanged()
//            lineviewChart.notifyDataSetChanged()
        }
        else if sender.selectedSegmentIndex == 1{
            timeinterval = "w"
           // fetchhealthdata()
        }
        else if sender.selectedSegmentIndex == 2{
            timeinterval = "m"
            //fetchhealthdata()
//            months = ["Jan","Feb","Mar","Apr","May","Jun"]
//            setChart(dataPoints: months, values: unitsSold)
//
//            lineviewChart.data?.notifyDataChanged()
//            lineviewChart.notifyDataSetChanged()
        }
        else if sender.selectedSegmentIndex == 3{
            timeinterval = "y"
           // fetchhealthdata()
        }
    }
    func fetchhealthdata(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "viewhealthdata/\(attr)/\(timeinterval)", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success"{
                        if let data = json.value(forKey: "data") as? NSArray{
                            self.dataarr = data
                            if data.count == 0{
                                self.headertitle = "No Recorded Data"
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
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
        
        for i in 0..<dataPoints.count {
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
        return months[Int(value)]
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
/*
 
 private func setLineChart() -> PNLineChart {
 let lineChart = PNLineChart(frame: CGRect(x: 0, y: 135, width: 320, height: 320))
 lineChart.yLabelFormat = "%1.1f"
 lineChart.showLabel = true
 lineChart.backgroundColor = UIColor.clear
 lineChart.xLabels = ["Sep 1", "Sep 2", "Sep 3", "Sep 4", "Sep 5", "Sep 6", "Sep 7"]
 lineChart.showCoordinateAxis = true
 lineChart.center = self.view.center
 
 let dataArr = [60.1, 160.1, 126.4, 232.2, 186.2, 127.2, 176.2]
 let data = PNLineChartData()
 data.color = PNGreen
 data.itemCount = dataArr.count
 data.inflexPointStyle = .Cycle
 data.getData = ({
 (index: Int) -> PNLineChartDataItem in
 let yValue = CGFloat(dataArr[index])
 let item = PNLineChartDataItem(y: yValue)
 return item
 })
 
 lineChart.chartData = [data]
 lineChart.strokeChart()
 lineChart.showLabel = true
 // self.view.addSubview(lineChart)
 return lineChart
 }
 */
