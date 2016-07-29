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

//  MARK: - Network:网络
public class NetworkInfo{
    //  MARK:  networkStatus:网络连接状态(NotReachable/ReachableViaWiFi/ReachableViaWWAN)
    class var status: NetReachability.NetworkStatus {
        get{
            return NetReachability.currentReachabilityStatus()
        }
    }
    
    //  MARK: carrier:运营商(e.g 中国联通)
    class var carrier: String {
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
    class func IPAddress(completionHandler: (String?) -> Void)-> Void {
        // Get the current IP Address\
        let SERVICE_BASE_URL = "https://freegeoip.net/json/"
        let session = NSURLSession.sharedSession()
        var currentIPAddress = "0.0.0.0"
        completionHandler(currentIPAddress)
        switch self.status {
        case .NotReachable :
//            currentIPAddress = "0.0.0.0"
            completionHandler(currentIPAddress)
            break
        // WiFi is in use
        case .ReachableViaWiFi,.ReachableViaWWAN:
            session.dataTaskWithURL(NSURL(string: SERVICE_BASE_URL)!, completionHandler: { (data, response, error) -> Void in
//                let json = JSON(data: data!)
//                currentIPAddress = json["ip"].string!
                let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let dictionary = json as? NSDictionary {
                    if let title = dictionary["ip"] as? String {
                        currentIPAddress = title
                    }
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