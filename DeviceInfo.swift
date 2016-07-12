//
//  SystemInfo.swift
//  store_killer_ios
//
//  Created by 樊半缠 on 16/6/30.
//  Copyright © 2016年 樊半缠. All rights reserved.
//
import UIKit
import SystemConfiguration
import MachO
import AdSupport
//  MARK: - Device:硬件
public class DeviceInfo {
    //  MARK:  deviceModel:设备型号
    //(e.g iPhone5,3)
    class var deviceModel: String {
        var systemInfo : UnsafeMutablePointer<utsname> = UnsafeMutablePointer<utsname>.alloc(1);
        let foo : Int32 = uname(systemInfo)
        print(foo)
        let machine = withUnsafePointer(&systemInfo.memory.machine, { (ptr) -> String? in
            
            let int8Ptr = unsafeBitCast(ptr, UnsafePointer<Int8>.self)
            return String.fromCString(int8Ptr)
        })
        
        let deviceModel = String(CString: machine!, encoding: NSUTF8StringEncoding)
        return deviceModel!
    }
    //  MARK:  iOSVersion:系统版本
    ///(e.g 8.1 ， 9.3 ， 10.0)
    class var OSVersion: String {
        return UIDevice.currentDevice().systemVersion
    }
    //  MARK: deviceName:设备名称
    //(e.g "my iPhone")
    class var deviceName: String {
        get{
            return UIDevice.currentDevice().name
        }
    }
    //  MARK: isJailbreak: 是否越狱
    //(e.g bool)
    class var isJailbreak: Bool {
        get{
            var isJailBroken = false;
            
            let cydiaPath = "/Applications/Cydia.app";
            let aptPath = "/private/var/lib/apt/";
            if NSFileManager.defaultManager().fileExistsAtPath(cydiaPath)
            {
                isJailBroken = true;
            }
            
            if NSFileManager.defaultManager().fileExistsAtPath(aptPath)
            {
                isJailBroken = true;
            }
            
            let url = NSURL.init(string:"cydia://package/com.example.package")
            let cydiaJailBroken = UIApplication.sharedApplication().canOpenURL(url!)
            
            return isJailBroken || cydiaJailBroken;
        }
    }
    //  MARK: IDFA:广告标示符
    class var IDFA: String {
        get{
            return  ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
        }
    }
    //  MARK: IDFV:Vendor标示符
    class var IDFV: String {
        get{
            return  UIDevice.currentDevice().identifierForVendor!.UUIDString
        }
    }
    //  MARK:  RAM:内存
    public class func freeMemory() -> Double {
        // Set up the variables
        var freeMemory : Double  = 0.00
        var vmStats : vm_statistics_data_t = vm_statistics_data_t.init()
        
        var infoCount : mach_msg_type_number_t = UInt32.init(sizeof(vm_statistics_data_t)/sizeof(integer_t))
        //        HOST_VM_INFO_COUNT
        //        public func host_statistics(host_priv: host_t,
        //                                    _ flavor: host_flavor_t,
        //                                      _ host_info_out: host_info_t,
        //                                        _ host_info_outCnt: UnsafeMutablePointer<mach_msg_type_number_t>) -> kern_return_t
        let vmStatsPtr : UnsafeMutablePointer<integer_t> = UnsafeMutablePointer<integer_t>.alloc(128)
        var vmStats_free_count = Int32.init(vmStats.free_count)
        vmStatsPtr.initialize(vmStats_free_count)
        //        let infoCountPtr : UnsafeMutablePointer<mach_msg_type_number_t> = UnsafeMutablePointer<mach_msg_type_number_t>.alloc(128)
        //        infoCountPtr.initialize(infoCount)
        let kernReturn : kern_return_t  = host_statistics(mach_host_self(), HOST_VM_INFO, vmStatsPtr, &infoCount);
        
        if(kernReturn != KERN_SUCCESS) {
            return -1;
        }
        
        // Not in percent
        // Total Memory (formatted)
        VM_PAGE_QUERY_PAGE_REF
        freeMemory = ((Double.init(vm_page_size) * Double.init(vmStatsPtr.memory)) / 1024.0) / 1024.0;
        
        // Check to make sure it's valid
        if (freeMemory <= 0) {
            // Error, invalid memory value
            return -1;
        }
        
        // Completed Successfully
        return freeMemory
    }
    
    class func freeMemory_Description() -> String {
        return ""
    }
    
    class func totalMemory() -> Double {
        // Find the total amount of memory
        do {
            // Set up the variables
            
            var TotalMemory : Double = 0.00
            let AllMemory : UInt64 = NSProcessInfo.processInfo().physicalMemory
            let AllMemoryDouble : Double = Double.init(AllMemory)
            
            // Total Memory (formatted)
            TotalMemory = (AllMemoryDouble / 1024.0) / 1024.0;
            
            // Round to the nearest multiple of 256mb - Almost all RAM is a multiple of 256mb (I do believe)
            let toNearest : Int = 256
            let toNearestDouble : Double = Double.init(toNearest)
            let remainder : Int = Int.init(TotalMemory % toNearestDouble)
            
            if remainder >= (toNearest / 2) {
                // Round the final number up
                TotalMemory = (TotalMemory - Double.init(remainder)) + 256
            } else {
                // Round the final number down
                TotalMemory = TotalMemory - Double.init(remainder)
            }
            
            // Check to make sure it's valid
            if (TotalMemory <= 0) {
                // Error, invalid memory value
                return -1
            }
            // Completed Successfully
            return TotalMemory
        } catch  {
            // Error
            print(error)
            return -1
        }
    }
    class func totalMemory_Description() -> String {
        return ""
    }
    //Get raw value
    
    //  MARK:  Disk:储存
    // Get String Values
    class func totalDiskSpace_Description()->String {
        return NSByteCountFormatter.stringFromByteCount(totalDiskSpaceInBytes, countStyle: NSByteCountFormatterCountStyle.Binary)
    }
    
    class func freeDiskSpace_Description()->String {
        return NSByteCountFormatter.stringFromByteCount(freeDiskSpaceInBytes, countStyle: NSByteCountFormatterCountStyle.Binary)
    }
    
    class func usedDiskSpace_Description()->String {
        return NSByteCountFormatter.stringFromByteCount(usedDiskSpaceInBytes, countStyle: NSByteCountFormatterCountStyle.Binary)
    }
    
    //Get raw value
    class var totalDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try NSFileManager.defaultManager().attributesOfFileSystemForPath(NSHomeDirectory() as String)
                let space = (systemAttributes[NSFileSystemSize] as? NSNumber)?.longLongValue
                return space!
            } catch {
                return 0
            }
        }
    }
    
    class var freeDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try NSFileManager.defaultManager().attributesOfFileSystemForPath(NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[NSFileSystemFreeSize] as? NSNumber)?.longLongValue
                return freeSpace!
            } catch {
                return 0
            }
        }
    }
    
    class var usedDiskSpaceInBytes:Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }
    // Tool : Formatter MB only
    class func MBFormatter(bytes: Int64) -> String {
        let formatter = NSByteCountFormatter()
        formatter.allowedUnits = NSByteCountFormatterUnits.UseMB
        formatter.countStyle = NSByteCountFormatterCountStyle.Decimal
        formatter.includesUnit = false
        return formatter.stringFromByteCount(bytes) as String
    }
    
    //  MARK: CPU:中央处理器
    class func cpuUsage_Description() -> String {
        return "\(self.cpuUsage)%"
    }
    //MARK: cpuUsage raw value
    class var cpuUsage:Double{
        get{
            var kr = kern_return_t()
            
            let tinfo : task_info_t = task_info_t.alloc(Int.init(TASK_INFO_MAX))
            var task_info_count = mach_msg_type_number_t()
            
            task_info_count = UInt32.init(TASK_INFO_MAX);

            kr = task_info(mach_task_self_, UInt32.init(TASK_BASIC_INFO_32), tinfo, &task_info_count);
            if (kr != KERN_SUCCESS)
            {
                //"CPU计算错误"
                return 0;
            }
            
            var basic_info = task_basic_info_t.alloc(Int.init(TASK_BASIC_INFO))
            
            var thread_list = thread_array_t.alloc(32)
            var thread_count = mach_msg_type_number_t()
            //origion is thread_info_data_t
            var thinfo : thread_info_t = thread_info_t.alloc(Int.init(THREAD_INFO_MAX))
            //
            var thread_info_count = UnsafeMutablePointer<mach_msg_type_number_t>.alloc(128)

            var basic_info_th = thread_basic_info_t()
            
            var stat_thread = UInt32.init(0)// Mach threads
            
            basic_info = withUnsafePointer(&tinfo.memory, { (ptr) -> task_basic_info_t in
                let int8Ptr = unsafeBitCast(ptr, task_basic_info_t.self)
                return int8Ptr
            }) //task_basic_info_t()tinfo;
            
            // get threads in the task
            kr = task_threads(mach_task_self_, &thread_list, &thread_count);
            if (kr != KERN_SUCCESS)
            {//"CPU计算错误"
                return 0;
            }
            if thread_count > 0{
                stat_thread += thread_count;
            }
            
            
            var tot_sec : Int32 = 0;
            var tot_usec : Int32 = 0;
            var tot_cpu : CFloat = 0;
            var j : UInt32;
            
            for (j = 0; j < thread_count; j += 1)
            {
                thread_info_count.memory = UInt32.init(THREAD_INFO_MAX);
                let j_Int = Int.init(j)
                kr = thread_info(thread_list[j_Int] ,thread_flavor_t.init(THREAD_BASIC_INFO),
                                 /*(thread_info_t)*/thinfo, thread_info_count);
                if (kr != KERN_SUCCESS)
                {
                    return 0;
                }
                basic_info_th = withUnsafePointer(&thinfo.memory, { (ptr) -> thread_basic_info_t in
                    let int8Ptr = unsafeBitCast(ptr, thread_basic_info_t.self)
                    return int8Ptr
                })
//                basic_info_th = /*(thread_basic_info_t)*/thinfo;
                
                if (!Bool.init(Int.init(basic_info_th.memory.flags & TH_FLAGS_IDLE)))
                {
                    tot_sec = tot_sec + basic_info_th.memory.user_time.seconds + basic_info_th.memory.system_time.seconds;
                    tot_usec = tot_usec + basic_info_th.memory.system_time.microseconds + basic_info_th.memory.system_time.microseconds;
                    
                    tot_cpu = tot_cpu + CFloat.init(basic_info_th.memory.cpu_usage) / CFloat.init(TH_USAGE_SCALE) * 100.0;
                }
                
            } // for each thread
            
            kr = vm_deallocate(mach_task_self_, /*(vm_offset_t)*/ thread_list.memory, thread_count * UInt32.init(sizeof(thread_t)));
            assert(kr == KERN_SUCCESS);
            
            return Double.init(tot_cpu) ;
        }
    }
}




