//
//  Network.swift
//  iOS-Example
//
//  Created by 樊半缠 on 16/8/4.
//  Copyright © 2016年 reformation.tech. All rights reserved.
//

import UIKit
import Apple_System_Info

class Network: UITableViewController {
//sec 1
    @IBOutlet var Uploading: UILabel!
    
    @IBOutlet var Downloading: UILabel!
    
    @IBOutlet var WiFiHistory: UILabel!
    
    @IBOutlet var WWANHistory: UILabel!
    
//sec 2
    @IBOutlet var Status: UILabel!
    
    @IBOutlet var Carrier: UILabel!
    
    @IBOutlet var IPAddress: UILabel!
    
    //  MARK: life cycle :
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.WiFiHistory.text = NetworkInfoFormatter.WiFiHistory_MB
        self.WWANHistory.text = NetworkInfoFormatter.WWANHistory_MB
        
        let currentStatus = Apple_System_Info.NetworkInfo.status.description
        self.Status.text = currentStatus
//        self.title = currentStatus
        
        self.Carrier.text = Apple_System_Info.NetworkInfo.carrier
        
        Apple_System_Info.NetworkInfo.IPAddress({ (ipString) in
            self.IPAddress.text = ipString
        })
    }
}

class DataUsageContainer: UIViewController {
    @IBOutlet var graph: ScrollableGraphView!
    
    var parent : Network? //parentViewController
    
    //store raw for caculate network speed
    lazy var upload_1: Int! = {
        return Apple_System_Info.NetworkInfo.usage.total_uploaded_raw
    }()
    lazy var download_1: Int! = {
        return Apple_System_Info.NetworkInfo.usage.total_downloaded_raw
    }()
    
    let numberOfDataItems = 15
    var historySpeed: [Double]! = []{
        didSet{
            if historySpeed.count > numberOfDataItems{
                let subtractRange =  historySpeed.startIndex.advancedBy(numberOfDataItems) ..< historySpeed.endIndex
                
                historySpeed.removeRange(subtractRange)
            }
        }
    }
    
    var labels: [String]! = []{
        didSet{
            if labels.count > numberOfDataItems{
                let subtractRange = labels.startIndex.advancedBy(numberOfDataItems) ..< labels.endIndex
                
                labels.removeRange(subtractRange)
            }
        }
    }
    func addSpeedPoint(speed: Int) -> Void {
        //historySpeed
        let waldo = Double.init(speed)
        
        self.historySpeed.insert(waldo, atIndex: 0)
        
        //labels
        let date = NSDate()
        let foo = NSDateFormatter.init()
        foo.dateStyle = .ShortStyle
        
        let baz = foo.stringFromDate(date)
        
        self.labels.insert(baz, atIndex: 0)
    }
    
    private var timer: NSTimer?
    /// timer间隔时间,默认1.0秒
    var timeInterval: NSTimeInterval = 1.0 {
        didSet{
            
        }
    }
    
    
    //  MARK: life cycle :
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.parent = (self.parentViewController as! Network)
        
        self.setup_Graph()
        self.addSpeedPoint(0)
        
        self.upload_1 = Apple_System_Info.NetworkInfo.usage.total_uploaded_raw
        self.download_1 = Apple_System_Info.NetworkInfo.usage.total_downloaded_raw
        
        self.startTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
    
    //  MARK: configure :
    func setup_Graph() -> Void {
        graph.backgroundFillColor = UIColor.colorFromHex("#333333")
        
        graph.lineWidth = 1
        graph.lineColor = UIColor.colorFromHex("#777777")
        graph.lineStyle = ScrollableGraphViewLineStyle.Smooth
        
        graph.shouldFill = true
        graph.fillType = ScrollableGraphViewFillType.Gradient
        graph.fillColor = UIColor.colorFromHex("#555555")
        graph.fillGradientType = ScrollableGraphViewGradientType.Linear
        graph.fillGradientStartColor = UIColor.colorFromHex("#555555")
        graph.fillGradientEndColor = UIColor.colorFromHex("#444444")
        
        graph.dataPointSpacing = 80
        graph.dataPointSize = 2
        graph.dataPointFillColor = UIColor.whiteColor()
        
        graph.referenceLineLabelFont = UIFont.boldSystemFontOfSize(8)
        graph.referenceLineColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        graph.referenceLineLabelColor = UIColor.whiteColor()
        graph.numberOfIntermediateReferenceLines = 5
        graph.dataPointLabelColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        graph.shouldAnimateOnStartup = true
        graph.shouldAdaptRange = true
        graph.adaptAnimationType = ScrollableGraphViewAnimationType.Elastic
        graph.animationDuration = 1.5
        graph.rangeMax = 50
        graph.shouldRangeAlwaysStartAtZero = true
        
        graph.setData(self.historySpeed, withLabels: self.labels)
        
//        graph.setNeedsUpdateConstraints()
//        graph.layoutSubviews()
        
        self.graph.translatesAutoresizingMaskIntoConstraints = false
    }
}
//  MARK: extension DataUsageContainer : time controller
extension DataUsageContainer{
    
    //  MARK:  timer:
    private func startTimer() -> Void
    {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        timer = WeakTimer.timerWith(timeInterval, target: self){ [unowned self] _ in
            self.reloadData()
        }
    }
    private func stopTimer() -> Void
    {
        timer?.invalidate()
        timer = nil
    }
    private func reloadData() -> Void
    {
        self.parent!.WiFiHistory.text = NetworkInfoFormatter.WiFiHistory_MB
        self.parent!.WWANHistory.text = NetworkInfoFormatter.WWANHistory_MB
        
        let uploaded_quiz: NetworkInfoFormatter.synchrotron = NetworkInfoFormatter.this_second_uploaded_KBS(self.upload_1)
        
        let downloaded_quiz: NetworkInfoFormatter.synchrotron = NetworkInfoFormatter.this_second_downloaded_KBS(self.download_1)
        
        //图标数组
        let usage_last_second = uploaded_quiz.delta + downloaded_quiz.delta
        
        self.addSpeedPoint(usage_last_second)
        
        defer{
            self.parent!.Uploading.text = uploaded_quiz.descript
            self.upload_1 = uploaded_quiz.recursionValue
            
            self.parent!.Downloading.text = downloaded_quiz.descript
            self.download_1 = downloaded_quiz.recursionValue
            //更新图表
            graph.updateConstraintsIfNeeded()
            graph.setData(self.historySpeed, withLabels: self.labels)
        }
    }
}
//  MARK: - make raw data format suit for application :
private class NetworkInfoFormatter {
    static let KB_contains_bytes: Int = 1024
    //  MARK: calculater for values speed per second
    struct synchrotron {
        let descript : String
        let delta : Int
        let recursionValue : Int
        
        init(descript : String,
             delta : Int,
             recursionValue : Int)
        {
            self.descript = descript
            self.delta = delta
            self.recursionValue = recursionValue
        }
    }
    private class func this_second_uploaded_KBS( x_1: Int ) -> (synchrotron) {
        let x_2 = Apple_System_Info.NetworkInfo.usage.total_uploaded_raw
        
        let x_delta = x_2 - x_1
        
        //result : kb/s
        let foo = x_delta / KB_contains_bytes
        
        return synchrotron.init(descript: foo.description + " kb/s", delta: x_delta, recursionValue: x_2)
    }
    
    private class func this_second_downloaded_KBS( x_1: Int ) -> (synchrotron) {
        let x_2 = Apple_System_Info.NetworkInfo.usage.total_downloaded_raw
        
        let x_delta = x_2 - x_1
        
        //result : kb/s
        let foo = x_delta / KB_contains_bytes
        
        return synchrotron.init(descript: foo.description + " kb/s", delta: x_delta, recursionValue: x_2)
    }
    
    private class var WiFiHistory_MB: String {
        get{
            return Apple_System_Info.NetworkInfo.usage.WiFi_MB.description + " MB"
        }
    }
    private class var WWANHistory_MB: String {
        get{
            return Apple_System_Info.NetworkInfo.usage.WWAN_MB.description + " MB"
        }
    }
}