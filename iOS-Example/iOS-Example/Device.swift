//
//  Device.swift
//  iOS-Example
//
//  Created by 樊半缠 on 16/8/4.
//  Copyright © 2016年 reformation.tech. All rights reserved.
//

import UIKit
import Apple_System_Info

class Device: UITableViewController {
    @IBOutlet var Name: UILabel!

    @IBOutlet var OSVersion: UILabel!
    
    @IBOutlet var Model: UILabel!
    
    @IBOutlet var IsJailbreak: UILabel!
    
    @IBOutlet var IDFA: UILabel!
    
    @IBOutlet var IDFV: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.Name.text = Apple_System_Info.DeviceInfo.name
        self.OSVersion.text = Apple_System_Info.DeviceInfo.OSVersion
        self.Model.text = Apple_System_Info.DeviceInfo.model
        self.IsJailbreak.text = Apple_System_Info.DeviceInfo.isJailbreak.description
        
        self.IDFA.text = Apple_System_Info.DeviceInfo.IDFA
        self.IDFV.text = Apple_System_Info.DeviceInfo.IDFV
    }
}

class HardwareContainer: UIViewController {
    private var timer: NSTimer?
    /// timer间隔时间,默认2.0秒
    var timeInterval: NSTimeInterval = 1.0 {
        didSet{
            
        }
    }
    
    @IBOutlet var cpu_Dashboard: Dashboard!
    
    @IBOutlet var ram_Dashboard: Dashboard!
    @IBOutlet var diskSpace_Label: UILabel!
    
    @IBOutlet var diskSpace_Container: UIView!
    @IBOutlet var diskSpace_Progress: NSLayoutConstraint!
    //  MARK: - life cycle:
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cpu_Dashboard.title = "CPU"
        ram_Dashboard.title = "RAM"
        self.cpu_Dashboard.setupDefaultValue()
        self.ram_Dashboard.setupDefaultValue()
        
        
        self.diskSpace_Label.text = DeviceInfoFormatter.diskSpace_statu_Description
        self.reloadData()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue()) {
            self.diskSpace_Progress.constant = self.diskSpace_Container.bounds.width * DeviceInfoFormatter.diskSpace_free_Percent
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.startTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
}
extension HardwareContainer{
    //  MARK: - timer:
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
        self.cpu_Dashboard.change(DeviceInfoFormatter.cpu_usage_Value,
                                  total: 100.0,
                                  suffix: "%")
        self.ram_Dashboard.change(DeviceInfoFormatter.ram_used_Value ,
                                  total: DeviceInfoFormatter.ram_total_Value,
                                  suffix: "MB")
    }
}
public class DeviceInfoFormatter {
    //  MARK: - logic_for系统信息:SystemInfo
    public class var diskSpace_statu_Description : String{
        get{
            return "存储空间:\(Apple_System_Info.DeviceInfo.totalDiskSpace_Description())  已用:\(Apple_System_Info.DeviceInfo.usedDiskSpace_Description())  空闲:\(Apple_System_Info.DeviceInfo.freeDiskSpace_Description())"
        }
    }
    public class var diskSpace_used_Description : String{
        get{
            return "已用:\(Apple_System_Info.DeviceInfo.usedDiskSpace_Description())"
        }
    }
    public class var diskSpace_free_Description : String{
        get{
            return "空闲:\(Apple_System_Info.DeviceInfo.freeDiskSpace_Description())"
        }
    }
    public class var diskSpace_total_Description : String{
        get{
            return "存储空间:\(Apple_System_Info.DeviceInfo.totalDiskSpace_Description())"
        }
    }
    public class var diskSpace_free_Percent : CGFloat{
        get{
            return (CGFloat.init(Apple_System_Info.DeviceInfo.freeDiskSpaceInBytes)  / CGFloat.init(Apple_System_Info.DeviceInfo.totalDiskSpaceInBytes))
        }
    }
    public class var ram_used_Value : CGFloat{
        get{
            return CGFloat.init(Apple_System_Info.DeviceInfo.totalMemory() - Apple_System_Info.DeviceInfo.freeMemory())
        }
    }
    public class var ram_total_Value : CGFloat{
        get{
            return CGFloat.init(Apple_System_Info.DeviceInfo.totalMemory())
        }
    }
    //  MARK: CPU:中央处理器
    class var cpu_usage_Description : String {
        get{
            return "\(Int.init(Apple_System_Info.DeviceInfo.cpuUsage))%"
        }
    }
    //MARK: cpuUsage raw value
    public class var cpu_usage_Value:CGFloat{
        get{
            return CGFloat.init(Apple_System_Info.DeviceInfo.cpuUsage)
        }
    }
    //  MARK: - :
    public class var device_model_Value : String{
        get{
            return Apple_System_Info.DeviceInfo.model
        }
    }
    public class var device_name_Value : String{
        get{
            return Apple_System_Info.DeviceInfo.name
        }
    }
    public class var OS_version_Value : String{
        get{
            return Apple_System_Info.DeviceInfo.OSVersion
        }
    }
    public class var isJailbreak_Description : String{
        get{
            return Apple_System_Info.DeviceInfo.isJailbreak.description
        }
    }
}
