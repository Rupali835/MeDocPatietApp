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

    @IBOutlet weak var viewChart: LineChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    @IBOutlet var tableview: UITableView!
    @IBOutlet var type_imageview: UIImageView!
    
    var dataarr = NSArray()
    var selectedtitle = ""
    var typeimage : UIImage?
    
    var xAxisValue = [String]()
    var chartvalue = [Double]()
    
    let color = UIColor.black
    let skyblue = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedtitle
        self.type_imageview.image = typeimage
        axisFormatDelegate = self
        updateChart()
        tableview.tableFooterView = UIView(frame: .zero)
        viewChart.noDataText = "No Data Found to Show on Graph"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        } else {
            // Fallback on earlier versions
            UIApplication.shared.statusBarStyle = .default
        }
       // UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    @IBAction func close(){
        self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
    }
    func updateChart(){
        if self.dataarr.count > 0 {
            self.chartvalue.removeAll()
            self.xAxisValue.removeAll()
            
            var appendvalue = [Double]()
            var appendvalue2 = [Double]()
            
            for (index,_) in self.dataarr.enumerated() {
                let d = self.dataarr.object(at: index) as! NSDictionary
                let created_at = d.value(forKey: "created_at") as! String
                var blood_pressure = d.value(forKey: "blood_pressure") as? String ?? "0/0"
                let height = d.value(forKey: "height") as? String
                let weight = d.value(forKey: "weight") as? String
                let temperature = d.value(forKey: "temperature") as? Int ?? 0
                
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = df.date(from: created_at)
                
                let dateformatter2 = DateFormatter()
                dateformatter2.dateFormat = "d MMM"
                let datestr = dateformatter2.string(from: date!)
                
                if blood_pressure == "NF" || blood_pressure == "" {
                    blood_pressure = "0/0"
                }
                
                if self.selectedtitle == "Blood Pressure"{
                    let arr = blood_pressure.split(separator: "/")
                    if arr.count > 1 {
                        let systolic = arr[0]
                        let diastolic = arr[1]
                        if blood_pressure != "0/0" {
                            appendvalue.append(Double(systolic)!)
                            appendvalue2.append(Double(diastolic)!)
                            xAxisValue.append(datestr)
                        }
                    }
                }
                else if self.selectedtitle == "Height"{
                    if height != "NF" || height != ""{
                        let a1 = height?.first
                        if let a2 = height?.slice(from: "Feet ", to: " Inch") {
                            if let height = "\(a1!).\(a2)".toDouble() {
                                appendvalue.append(Double(height))
                                xAxisValue.append(datestr)
                            }
                        }
                    }
                }
                else if self.selectedtitle == "Weight"{
                    if weight != "NF" || weight != ""{
                        if let w = weight?.toDouble() {
                            appendvalue.append(w)
                            xAxisValue.append(datestr)
                        }
                    }
                }
                else if self.selectedtitle == "Temperature"{
                    if temperature != 0{
                        appendvalue.append(Double(temperature))
                        xAxisValue.append(datestr)
                    }
                }
            }
            
            self.chartvalue = appendvalue
            
            if appendvalue.count > 0 {
                self.setChart(dataPoints: self.xAxisValue, values: self.chartvalue, values2: appendvalue2)
            } else {
                self.setChart(dataPoints: self.xAxisValue, values: self.chartvalue, values2: nil)
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
    func setChart(dataPoints: [String], values: [Double], values2: [Double]?) {
        
        var dataEntries: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        
        for (i,_) in values.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i],data: dataPoints as AnyObject)
            dataEntries.append(dataEntry)
        }
        if values2 != nil{
            for (i,_) in values2!.enumerated() {
                let dataEntry = ChartDataEntry(x: Double(i), y: values2![i],data: dataPoints as AnyObject)
                dataEntries2.append(dataEntry)
            }
        }
        var chartData = ChartData()
        var chartDataSet = LineChartDataSet()
        var chartDataSet2 = LineChartDataSet()
        
        if self.selectedtitle == "Blood Pressure" {
            chartDataSet = LineChartDataSet(values: dataEntries, label: "Systolic")
            chartDataSet2 = LineChartDataSet(values: dataEntries2, label: "Diastolic")
            
            chartDataSet.setColor(UIColor.red)
            chartDataSet.setCircleColor(UIColor.red.withAlphaComponent(0.5))
            chartDataSet.circleHoleColor = UIColor.red.withAlphaComponent(0.5)
            
            chartDataSet2.setColor(skyblue)
            chartDataSet2.setCircleColor(skyblue.withAlphaComponent(0.5))
            chartDataSet2.circleHoleColor = skyblue.withAlphaComponent(0.5)
            
            chartData = LineChartData(dataSets: [chartDataSet,chartDataSet2])
        } else {
            if self.selectedtitle == "Height"{
                chartDataSet = LineChartDataSet(values: dataEntries, label: selectedtitle + " in ft")
            }
            else if self.selectedtitle == "Weight"{
                chartDataSet = LineChartDataSet(values: dataEntries, label: selectedtitle + " in kg")
            }
            else if self.selectedtitle == "Temperature"{
                chartDataSet = LineChartDataSet(values: dataEntries, label: selectedtitle + " in ºC")
            }
            chartDataSet.setColor(skyblue)
            chartDataSet.setCircleColor(skyblue.withAlphaComponent(0.5))
            chartDataSet.circleHoleColor = skyblue.withAlphaComponent(0.5)
            chartData = LineChartData(dataSet: chartDataSet)
        }
        if values.count == 0 {
            viewChart.data = nil
        }
        else {
            viewChart.data = chartData
        }
        viewChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        viewChart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        viewChart.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        chartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 10)
        chartDataSet2.valueFont = UIFont.boldSystemFont(ofSize: 10)
        
        viewChart.xAxis.labelTextColor = color
        viewChart.leftAxis.labelTextColor = color
        viewChart.rightAxis.labelTextColor = color
        chartDataSet.valueTextColor = color
        chartDataSet2.valueTextColor = color
        
        let xAxisValue = viewChart.xAxis
        xAxisValue.granularityEnabled = true
        xAxisValue.granularity = 1.0
        xAxisValue.spaceMin = 0.5
        xAxisValue.spaceMax = 0.5
        xAxisValue.labelPosition = .bottom
        viewChart.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
        xAxisValue.valueFormatter = axisFormatDelegate
    }
}
extension ChartViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xAxisValue[Int(value) % xAxisValue.count]
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
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: created_at)
        
        let df1 = DateFormatter()
        df1.dateFormat = "dd MMM yyyy HH:mm:ss"
        let datestr = df1.string(from: date!)
        
        let dateSeparate = datestr.components(separatedBy: .whitespaces)
        
        showdatacell.date.text = dateSeparate[0]
        showdatacell.month.text = dateSeparate[1]
        showdatacell.year.text = dateSeparate[2]
        showdatacell.time.text = dateSeparate[3]
        
        if selectedtitle == "Blood Pressure"{
            let blood_pressure = d.value(forKey: "blood_pressure") as? String ?? "0/0"
            if blood_pressure == "NF" || blood_pressure == "" {
                //showdatacell.value.text = "Systolic: NF :Diastolic"
                showdatacell.value.text = "NF"
            } else {
                //showdatacell.value.text = "Systolic: \(blood_pressure) :Diastolic"
                showdatacell.value.text = blood_pressure
            }
        }
        else if selectedtitle == "Height"{
            if let height = d.value(forKey: "height") as? String {
                if height == "NF" || height == ""{
                    //showdatacell.value.text = "\(selectedtitle): NF"
                    showdatacell.value.text = "NF"
                } else {
                    //showdatacell.value.text = "\(selectedtitle): \(height)"
                    showdatacell.value.text = height
                }
            }
        }
        else if selectedtitle == "Weight"{
            if let weight = d.value(forKey: "weight") as? String {
                if weight == "NF" || weight == ""{
                  //  showdatacell.value.text = "\(selectedtitle): NF"
                    showdatacell.value.text = "NF"
                } else {
                   // showdatacell.value.text = "\(selectedtitle): \(weight) Kg"
                    showdatacell.value.text = "\(weight) Kg"
                }
            }
        }
        else if selectedtitle == "Temperature"{
            if let temperature = d.value(forKey: "temperature") as? Int {
                if temperature == 0{
                   // showdatacell.value.text = "\(selectedtitle): NF"
                    showdatacell.value.text = "NF"
                } else {
                   // showdatacell.value.text = "\(selectedtitle): \(temperature) ºC"
                    showdatacell.value.text = "\(temperature) ºC"
                }
            }
            else if let temperature = d.value(forKey: "temperature") as? String {
                //showdatacell.value.text = "\(selectedtitle): \(temperature)"
                showdatacell.value.text = "\(temperature) ºC"
            }
        }
        else {
            print("none")
        }
        
        return showdatacell
    }
}
