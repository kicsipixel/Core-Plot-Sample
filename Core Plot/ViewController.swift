//
//  ViewController.swift
//  Core Plot
//
//  Created by Szabolcs Toth on 4/6/17.
//  Copyright © 2017 purzelbaum.hu. All rights reserved.
//

import Cocoa
import CorePlot

class ViewController: NSViewController {

@IBOutlet weak var hostView: CPTGraphHostingView!
    
    let mobileOS: [String] = ["Android", "iOS", "Other OS"]
    let marketShare: [Float] = [0.807, 0.177,  0.016]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        initPlot()
    }
    
    func initPlot() {
        configureHostView()
        configureGraph()
        configureChart()
        configureLegend()
    }
    
    func configureHostView() {
    }
    
    func configureGraph() {
        // 1 - Create and configure the graph
        let graph = CPTXYGraph(frame: hostView.bounds)
        hostView.hostedGraph = graph
        graph.paddingLeft = 0.0
        graph.paddingTop = 0.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 0.0
        graph.axisSet = nil
        
        // 2 - Create text style
        let textStyle: CPTMutableTextStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.fontName = "HelveticaNeue-Light"
        textStyle.fontSize = 14.0
        textStyle.textAlignment = .center
        
        // 3 - Set graph title and text style
        graph.title = "Worldwide smartphone sales in the fourth quarter of 2016."
        graph.titleTextStyle = textStyle
        graph.titlePlotAreaFrameAnchor = CPTRectAnchor.top
    }
    
    func configureChart() {
        // 1 - Get a reference to the graph
        let graph = hostView.hostedGraph!
        
        // 2 - Create the chart
        let pieChart = CPTPieChart()
        pieChart.delegate = self
        pieChart.dataSource = self
        pieChart.pieRadius = (min(hostView.bounds.size.width, hostView.bounds.size.height) * 0.7) / 2
        pieChart.identifier = NSString(string: graph.title!)
        pieChart.startAngle = CGFloat(M_PI_4)
        pieChart.sliceDirection = .clockwise
        pieChart.labelOffset = -0.6 * pieChart.pieRadius
        
        // 3 - Configure border style
        let borderStyle = CPTMutableLineStyle()
        borderStyle.lineColor = CPTColor.white()
        borderStyle.lineWidth = 2.0
        pieChart.borderLineStyle = borderStyle
        
        // 4 - Configure text style
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.white()
        textStyle.textAlignment = .center
        pieChart.labelTextStyle = textStyle
        
        // 5 - Add chart to graph
        graph.add(pieChart)
    }
    
    func configureLegend() {
    }

}

extension ViewController: CPTPieChartDataSource, CPTPieChartDelegate {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(mobileOS.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        return marketShare[Int(idx)]
    }
    
    func dataLabel(for plot: CPTPlot, record idx: UInt) -> CPTLayer? {
        let layer = CPTTextLayer(text: String(format: "\(mobileOS[Int(idx)])\n%.2f", marketShare[Int(idx)]))
        layer.textStyle = plot.labelTextStyle
        return layer
    }
    
    func sliceFill(for pieChart: CPTPieChart, record idx: UInt) -> CPTFill? {
        switch idx {
        case 0:   return CPTFill(color: CPTColor(componentRed:0.92, green:0.28, blue:0.25, alpha:1.00))
        case 1:   return CPTFill(color: CPTColor(componentRed:0.06, green:0.80, blue:0.48, alpha:1.00))
        case 2:   return CPTFill(color: CPTColor(componentRed:0.22, green:0.33, blue:0.49, alpha:1.00))
        default:  return nil
        }
    }
    
    func legendTitle(for pieChart: CPTPieChart, record idx: UInt) -> String? {
        return nil
    }  
}
