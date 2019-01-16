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
    
    @IBOutlet weak var lineviewChart: LineChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    @IBOutlet var tableview: UITableView!
    var selectedtitle = ""
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setLineChart()
        axisFormatDelegate = self
        tableview.tableFooterView = UIView(frame: .zero)
        setChart(dataPoints: months, values: unitsSold)
        
        // Do any additional setup after loading the view.
    }
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
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineviewChart.data = lineChartData
        let xAxisValue = lineviewChart.xAxis
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showdatacell = tableView.dequeueReusableCell(withIdentifier: "ShowDataCell") as! ShowDataTableViewCell
        if selectedtitle == "Blood Pressure"{
            showdatacell.firstdata.text = "Systolic: \(120)"
            showdatacell.seconddata.text = "Diastolic: \(80)"
            let fmt = DateFormatter()
            fmt.dateFormat = "dd/MM/yyyy"
            let date = fmt.string(from: Date())
            showdatacell.date.text = "Date: \(date)"
        }
        else if selectedtitle == "Height"{
            showdatacell.firstdata.text = "\(selectedtitle): \(150) Cm"
            showdatacell.seconddata.text = ""
            let fmt = DateFormatter()
            fmt.dateFormat = "dd/MM/yyyy"
            let date = fmt.string(from: Date())
            showdatacell.date.text = "Date: \(date)"
        }
        else if selectedtitle == "Weight"{
            showdatacell.firstdata.text = "\(selectedtitle): \(60.5) Kg"
            showdatacell.seconddata.text = ""
            let fmt = DateFormatter()
            fmt.dateFormat = "dd/MM/yyyy"
            let date = fmt.string(from: Date())
            showdatacell.date.text = "Date: \(date)"
        }
        else if selectedtitle == "Temperature"{
            showdatacell.firstdata.text = "\(selectedtitle): \(120)"
            showdatacell.seconddata.text = ""
            let fmt = DateFormatter()
            fmt.dateFormat = "dd/MM/yyyy"
            let date = fmt.string(from: Date())
            showdatacell.date.text = "Date: \(date)"
        }
        else {
            print("none")
        }
        
        return showdatacell
    }
    
}
