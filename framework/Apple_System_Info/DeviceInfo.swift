//
//  SystemInfo.swift
//  store_killer_ios
//
//  Created by 樊半缠 on 16/6/30.
//  Copyright © 2016年 reformation.tech. All rights reserved.
//
import UIKit
import SystemConfiguration
import MachO
import AdSupport
//  MARK: - Device:硬件
open class DeviceInfo {
    //  MARK:  model:设备型号
    //(e.g iPhone5,3)
    open class var model: String {
        let systemInfo : UnsafeMutablePointer<utsname> = UnsafeMutablePointer<utsname>.allocate(capacity: 1);
        let foo : Int32 = uname(systemInfo)
        print(foo)
        let machine = withUnsafePointer(to: &systemInfo.pointee.machine, { (ptr) -> String? in
            
            let int8Ptr = unsafeBitCast(ptr, to: UnsafePointer<Int8>.self)
            return String(cString: int8Ptr)
        })
        
        
        let deviceModel = String.init(describing: machine?.utf8)
        //let deviceModelString(CString: machine!, encoding: String.Encoding.utf8)
        return deviceModel
    }
    //  MARK:  OSVersion:系统版本
    ///(e.g 8.1 ， 9.3 ， 10.0)
    open class var OSVersion: String {
        return UIDevice.current.systemVersion
    }
    //  MARK: name:设备名称
    //(e.g "my iPhone")
    open class var name: String {
        get{
            return UIDevice.current.name
        }
    }
    //  MARK: isJailbreak: 是否越狱
    //(e.g bool)
    open class var isJailbreak: Bool {
        get{
            var isJailBroken = false;
            
            let cydiaPath = "/Applications/Cydia.app";
            let aptPath = "/private/var/lib/apt/";
            if FileManager.default.fileExists(atPath: cydiaPath)
            {
                isJailBroken = true;
            }
            
            if FileManager.default.fileExists(atPath: aptPath)
            {
                isJailBroken = true;
            }
            
            let url = URL.init(string:"cydia://package/com.example.package")
            let cydiaJailBroken = UIApplication.shared.canOpenURL(url!)
            
            return isJailBroken || cydiaJailBroken;
        }
    }
    //  MARK: IDFA:广告标示符
    open class var IDFA: String {
        get{
            return  ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
    }
    //  MARK: IDFV:Vendor标示符
    open class var IDFV: String {
        get{
            return  UIDevice.current.identifierForVendor!.uuidString
        }
    }
    //  MARK:  RAM:内存
    open class func freeMemory() -> Double {
        // Set up the variables
        var freeMemory : Double  = 0.00
        let vmStats : vm_statistics_data_t = vm_statistics_data_t.init()
        
        var infoCount : mach_msg_type_number_t = UInt32.init(MemoryLayout<vm_statistics_data_t>.size/MemoryLayout<integer_t>.size)
        //        HOST_VM_INFO_COUNT
        //        public func host_statistics(host_priv: host_t,
        //                                    _ flavor: host_flavor_t,
        //                                      _ host_info_out: host_info_t,
        //                                        _ host_info_outCnt: UnsafeMutablePointer<mach_msg_type_number_t>) -> kern_return_t
        let vmStatsPtr : UnsafeMutablePointer<integer_t> = UnsafeMutablePointer<integer_t>.allocate(capacity: 128)
        let vmStats_free_count = Int32.init(vmStats.free_count)
        vmStatsPtr.initialize(to: vmStats_free_count)
        //        let infoCountPtr : UnsafeMutablePointer<mach_msg_type_number_t> = UnsafeMutablePointer<mach_msg_type_number_t>.alloc(128)
        //        infoCountPtr.initialize(infoCount)
        let kernReturn : kern_return_t  = host_statistics(mach_host_self(), HOST_VM_INFO, vmStatsPtr, &infoCount);
        
        if(kernReturn != KERN_SUCCESS) {
            return -1;
        }
        
        // Not in percent
        // Total Memory (formatted)
        VM_PAGE_QUERY_PAGE_REF
        freeMemory = ((Double.init(vm_page_size) * Double.init(vmStatsPtr.pointee)) / 1024.0) / 1024.0;
        
        // Check to make sure it's valid
        if (freeMemory <= 0) {
            // Error, invalid memory value
            return -1;
        }
        
        // Completed Successfully
        return freeMemory
    }
    
    open class func totalMemory() -> Double {
        // Find the total amount of memory
        do {
            // Set up the variables
            
            var TotalMemory : Double = 0.00
            let AllMemory : UInt64 = ProcessInfo.processInfo.physicalMemory
            let AllMemoryDouble : Double = Double.init(AllMemory)
            
            // Total Memory (formatted)
            TotalMemory = (AllMemoryDouble / 1024.0) / 1024.0;
            
            // Round to the nearest multiple of 256mb - Almost all RAM is a multiple of 256mb (I do believe)
            let toNearest : Int = 256
            let toNearestDouble : Double = Double.init(toNearest)
            let remainder : Int = Int.init(TotalMemory.truncatingRemainder(dividingBy: toNearestDouble))
            
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

    //Get raw value
    
    //  MARK:  Disk:储存
    // Get String Values
    
    open class func totalDiskSpace_Description() -> String {
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
    }
    
    open class func freeDiskSpace_Description() -> String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
    }
    
    open class func usedDiskSpace_Description() -> String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
    }
    
    //Get raw value
    open class var totalDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return 0
            }
        }
    }
    
    open class var freeDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return 0
            }
        }
    }
    
    open class var usedDiskSpaceInBytes:Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }
    // Tool : Formatter MB only
    fileprivate class func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
    
    //  MARK: CPU:中央处理器
    open class func cpuUsage_Description() -> String {
        return "\(self.cpuUsage)%"
    }
    //MARK: cpuUsage raw value
    open class var cpuUsage:Double{
        get{
            var kr = kern_return_t()
            
            let tinfo : task_info_t = task_info_t.allocate(capacity: Int.init(TASK_INFO_MAX))
            var task_info_count = mach_msg_type_number_t()
            
            task_info_count = UInt32.init(TASK_INFO_MAX);

            kr = task_info(mach_task_self_, UInt32.init(TASK_BASIC_INFO_32), tinfo, &task_info_count);
            if (kr != KERN_SUCCESS)
            {
                //"CPU计算错误"
                return 0;
            }
            
            var basic_info = task_basic_info_t.allocate(capacity: Int.init(TASK_BASIC_INFO))
            
//            var thread_list = thread_array_t.allocate(capacity: 32)
            var thread_list: thread_act_array_t? = nil
            var thread_count = mach_msg_type_number_t()
            //origion is thread_info_data_t
            var thinfo : thread_info_t = thread_info_t.allocate(capacity: Int.init(THREAD_INFO_MAX))
            //
            var thread_info_count = UnsafeMutablePointer<mach_msg_type_number_t>.allocate(capacity: 128)

            var basic_info_th: thread_basic_info_t? = nil
            
            var stat_thread = UInt32.init(0)// Mach threads
            
            basic_info = withUnsafePointer(to: &tinfo.pointee, { (ptr) -> task_basic_info_t in
                let int8Ptr = unsafeBitCast(ptr, to: task_basic_info_t.self)
                return int8Ptr
            }) //task_basic_info_t()tinfo;
            
            // get threads in the task
            kr = task_threads(mach_task_self_, &(thread_list), &thread_count);
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
            
            for j in 0..<thread_count {
                thread_info_count.pointee = UInt32.init(THREAD_INFO_MAX);
                let j_Int = Int.init(j)
                kr = thread_info(thread_list![j_Int] ,thread_flavor_t.init(THREAD_BASIC_INFO),
                                 /*(thread_info_t)*/thinfo, thread_info_count);
                if (kr != KERN_SUCCESS)
                {
                    return 0;
                }
                basic_info_th = withUnsafePointer(to: &thinfo.pointee, { (ptr) -> thread_basic_info_t in
                    let int8Ptr = unsafeBitCast(ptr, to: thread_basic_info_t.self)
                    return int8Ptr
                })
                //                basic_info_th = /*(thread_basic_info_t)*/thinfo;
                let foo = basic_info_th!.pointee.flags & TH_FLAGS_IDLE
                let number = NSNumber.init(value: foo)
                if (!Bool.init(number))
                {
                    tot_sec = tot_sec + basic_info_th!.pointee.user_time.seconds + basic_info_th!.pointee.system_time.seconds;
                    tot_usec = tot_usec + basic_info_th!.pointee.system_time.microseconds + basic_info_th!.pointee.system_time.microseconds;
                    
                    tot_cpu = tot_cpu + CFloat.init(basic_info_th!.pointee.cpu_usage) / CFloat.init(TH_USAGE_SCALE) * 100.0;
                }
            }// for each thread
//            for (j = 0; j < thread_count; j += 1){}
            let krsize = thread_count * UInt32.init(MemoryLayout<thread_t>.size)
            kr = vm_deallocate(mach_task_self_, /*(vm_offset_t)*/ vm_address_t(thread_list!.pointee), vm_size_t(krsize));
            assert(kr == KERN_SUCCESS);
            
            return Double.init(tot_cpu) ;
        }
    }
}




