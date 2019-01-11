//
//  ChartViewController.swift
//  medocpatient
//
//  Created by iAM on 10/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLineChart()
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
}
