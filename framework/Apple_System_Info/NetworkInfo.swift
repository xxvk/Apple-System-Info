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
open class NetworkInfo{
    //  MARK:  networkStatus:网络连接状态(NotReachable/ReachableViaWiFi/ReachableViaWWAN)
    open class var status: NetReachability.NetworkStatus {
        get{
            return NetReachability.currentReachabilityStatus()
        }
    }
    
    //  MARK: carrier:运营商(e.g 中国联通)
    open class var carrier: String {
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
    open class func IPAddress(_ completionHandler: @escaping (String?) -> Void)-> Void {
        // Get the current IP Address\
        let SERVICE_BASE_URL = "https://freegeoip.net/json/"
        let session = URLSession.shared
        var currentIPAddress = "0.0.0.0"
        completionHandler(currentIPAddress)
        switch self.status {
        case .notReachable :
            completionHandler(currentIPAddress)
            break
        // WiFi is in use
        case .reachableViaWiFi,.reachableViaWWAN:
            session.dataTask(with: URL(string: SERVICE_BASE_URL)!, completionHandler: { (data, response, error) -> Void in
                if data != nil{
                    let rawData: Data! = data
                    let json = try? JSONSerialization.jsonObject(with: rawData!, options: .allowFragments)
                    if let dictionary = json as? NSDictionary {
                        if let title = dictionary["ip"] as? String {
                            currentIPAddress = title
                        }
                    }
                }else{
                    
                }
                
                
                defer{
                    DispatchQueue.main.async(execute: { () -> Void in
                        completionHandler(currentIPAddress)
                    })
                }
            }).resume()
            break
        }
    }
    //  MARK: .usage : 数据使用量
    open class usage {
        //number of one MB contains some bytes
        fileprivate static let MB_contains_byte : Int = 1024 * 1024
        
        //  MARK: usage.total_MB : 全部 使用量
        open class var total_MB: Int {
            get{
                let bar = self.total_raw / MB_contains_byte
                
                return bar
            }
        }
        open class var total_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_total()
                
                return sum
            }
        }
        //  MARK: usage.total_uploaded ／ total_downloaded : 全部 上传／下载 量
        open class var total_uploaded_MB: Int {
            get{
                let bar = self.total_uploaded_raw / MB_contains_byte
                
                return bar
            }
        }
        open class var total_uploaded_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_sent()
                
                return sum
            }
        }
        open class var total_downloaded_MB: Int {
            get{
                let bar = self.total_downloaded_raw / MB_contains_byte
                
                return bar
            }
        }
        open class var total_downloaded_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_received()
                
                return sum
            }
        }
        //  MARK: usage.WiFi : Wi-Fi 使用量
        open class var WiFi_MB: Int {
            get{
                let bar = self.WiFi_raw / MB_contains_byte
                
                return bar
            }
        }
        open class var WiFi_raw: Int {
            get{
                let foo = NetUsage.init()
                
                let sum = foo.sum_WiFi()
                
                return sum
            }
        }
        //  MARK: usage.WWAN : 蜂窝数据 使用量
        open class var WWAN_MB: Int {
            get{
                let bar = self.WWAN_raw / MB_contains_byte
                
                return bar
            }
        }
        open class var WWAN_raw: Int {
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
            print(baz?.count)
        }
        if (baz?.count)! >= 4
        {
            self.WiFiSent = Int.init((baz?[0])!)
            self.WiFiReceived = Int.init((baz?[1])!)
            self.WWANSent = Int.init((baz?[2])!)
            self.WWANReceived = Int.init((baz?[3])!)
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
open class NetReachability {
    class var flags : SCNetworkReachabilityFlags{
        get{
//            var zeroAddress = sockaddr_in()
            var zeroAddress = sockaddr()
            zeroAddress.sa_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sa_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = SCNetworkReachabilityCreateWithAddress( nil, &zeroAddress)
//            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//            }
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
        
        case notReachable, reachableViaWiFi, reachableViaWWAN
        
        public var description: String {
            switch self {
            case .reachableViaWWAN:
                return "Cellular"
            case .reachableViaWiFi:
                return "WiFi"
            case .notReachable:
                return "No Connection"
            }
        }
    }
    fileprivate class func isOnWWAN() -> Bool {
        #if os(iOS)
            return self.flags.contains(.isWWAN)
        #else
            return false
        #endif
    }
    class func currentReachabilityStatus() -> NetworkStatus {
        if isConnectedToNetwork() {
            if isOnWWAN() {
                return .reachableViaWWAN
            }else{
                return .reachableViaWiFi
            }
        }else{
            return .notReachable
        }
    }
}
