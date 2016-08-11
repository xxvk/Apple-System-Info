//
//  NetworkInfo.swift
//  store_killer_ios
//
//  Created by 樊半缠 on 16/7/12.
//  Copyright © 2016年 reformation.tech All rights reserved.
//

import Foundation
import CFNetwork
import CoreTelephony
import SystemConfiguration
import NetworkExtension
import FooPrivates

//  MARK: - Network:网络
public class NetworkInfo{
    //  MARK:  networkStatus:网络连接状态(NotReachable/ReachableViaWiFi/ReachableViaWWAN)
    public class var status: NetReachability.NetworkStatus {
        get{
            return NetReachability.currentReachabilityStatus()
        }
    }
    
    //  MARK: carrier:运营商(e.g 中国联通)
    public class var carrier: String {
        get{
            let tNetwork = CTTelephonyNetworkInfo()
            let carrier  = tNetwork.subscriberCellularProvider
            var carrier_name : String?
            var carrier_code : String?
            
            carrier_name = carrier!.carrierName ?? ""
            carrier_code = carrier!.mobileNetworkCode ?? ""
            
            return carrier_name!
        }
    }
    
    // MARK:  IP Address
    public class func IPAddress(completionHandler: (String?) -> Void)-> Void {
        // Get the current IP Address\
        let SERVICE_BASE_URL = "https://freegeoip.net/json/"
        let session = NSURLSession.sharedSession()
        var currentIPAddress = "0.0.0.0"
        completionHandler(currentIPAddress)
        switch self.status {
        case .NotReachable :
            completionHandler(currentIPAddress)
            break
        // WiFi is in use
        case .ReachableViaWiFi,.ReachableViaWWAN:
            session.dataTaskWithURL(NSURL(string: SERVICE_BASE_URL)!, completionHandler: { (data, response, error) -> Void in
                if data != nil{
                    let rawData: NSData! = data
                    let json = try? NSJSONSerialization.JSONObjectWithData(rawData!, options: .AllowFragments)
                    if let dictionary = json as? NSDictionary {
                        if let title = dictionary["ip"] as? String {
                            currentIPAddress = title
                        }
                    }
                }else{
                    
                }
                
                
                defer{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(currentIPAddress)
                    })
                }
            }).resume()
            break
        }
    }
    //  MARK: .usage : 数据使用量
    public class usage {
        //number of one MB contains some bytes
        private static let MB_contains_byte : Int = 1024 * 1024
        
        //  MARK: usage.total_MB : 全部 使用量
        public class var total_MB: Int {
            get{
                let bar = self.total_raw / MB_contains_byte
                
                return bar
            }
        }
        public class var total_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_total()
                
                return sum
            }
        }
        //  MARK: usage.total_uploaded ／ total_downloaded : 全部 上传／下载 量
        public class var total_uploaded_MB: Int {
            get{
                let bar = self.total_uploaded_raw / MB_contains_byte
                
                return bar
            }
        }
        public class var total_uploaded_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_sent()
                
                return sum
            }
        }
        public class var total_downloaded_MB: Int {
            get{
                let bar = self.total_downloaded_raw / MB_contains_byte
                
                return bar
            }
        }
        public class var total_downloaded_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_received()
                
                return sum
            }
        }
        //  MARK: usage.WiFi : Wi-Fi 使用量
        public class var WiFi_MB: Int {
            get{
                let bar = self.WiFi_raw / MB_contains_byte
                
                return bar
            }
        }
        public class var WiFi_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_WiFi()
                
                return sum
            }
        }
        //  MARK: usage.WWAN : 蜂窝数据 使用量
        public class var WWAN_MB: Int {
            get{
                let bar = self.WWAN_raw / MB_contains_byte
                
                return bar
            }
        }
        public class var WWAN_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_WWAN()
                
                return sum
            }
        }
    }
}

private struct NetUsage{
    let WiFiSent: Int
    let WiFiReceived: Int
    let WWANSent: Int
    let WWANReceived: Int
    
    init(){
        let baz = FooPrivates.ExtraNetwork.getDataCounters()
        defer{
            print(baz.count)
        }
        if baz.count >= 4
        {
            self.WiFiSent = Int.init(baz[0])
            self.WiFiReceived = Int.init(baz[1])
            self.WWANSent = Int.init(baz[2])
            self.WWANReceived = Int.init(baz[3])
        }else{
            self.WiFiSent = 0
            self.WiFiReceived = 0
            self.WWANSent = 0
            self.WWANReceived = 0
        }
    }
    
    func sum_WiFi() -> Int {
        return self.WiFiReceived + self.WiFiSent
    }
    
    func sum_WWAN() -> Int {
        return self.WWANReceived + self.WWANSent
    }
    
    func sum_total() -> Int {
        return self.sum_WiFi() + self.sum_WWAN()
    }
    
    func sum_sent() -> Int {
        return self.WiFiSent + self.WWANSent
    }
    
    func sum_received() -> Int {
        return self.WiFiReceived + self.WWANReceived
    }
}
public class NetReachability {
    class var flags : SCNetworkReachabilityFlags{
        get{
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            
            let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }
            var foo = SCNetworkReachabilityFlags()
            
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &foo) {
                //Success
            }else{
                //no Network
            }
            return foo
        }
    }
    
    class func isConnectedToNetwork() -> Bool {
        
        let isReachable :Bool =
            0 != (flags.rawValue & UInt32(kSCNetworkFlagsReachable))
        
        let needsConnection =
            0 != (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired))
        
        return (isReachable && !needsConnection)
    }
    
    public enum NetworkStatus: CustomStringConvertible {
        
        case NotReachable, ReachableViaWiFi, ReachableViaWWAN
        
        public var description: String {
            switch self {
            case .ReachableViaWWAN:
                return "Cellular"
            case .ReachableViaWiFi:
                return "WiFi"
            case .NotReachable:
                return "No Connection"
            }
        }
    }
    private class func isOnWWAN() -> Bool {
        #if os(iOS)
            return self.flags.contains(.IsWWAN)
        #else
            return false
        #endif
    }
    class func currentReachabilityStatus() -> NetworkStatus {
        if isConnectedToNetwork() {
            if isOnWWAN() {
                return .ReachableViaWWAN
            }else{
                return .ReachableViaWiFi
            }
        }else{
            return .NotReachable
        }
    }
}