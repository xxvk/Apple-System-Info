//
//  NetworkInfo.swift
//  store_killer_ios
//
//  Created by 樊半缠 on 16/7/12.
//  Copyright © 2016年 樊半缠. All rights reserved.
//

import Foundation
import CFNetwork
import Alamofire
//  MARK: - Network:网络
public class NetworkInfo{
    //  MARK:  networkType:网络连接状态(NotReachable/EthernetOrWiFi/WWAN)
    // TODO:
    public class func networkType() -> String {
        let networkReachabilityManager : NetworkReachabilityManager = NetworkReachabilityManager.init()!
        var foo = ""
        switch networkReachabilityManager.networkReachabilityStatus {
        case .Unknown : foo = "Unknown"; break
        case .NotReachable : foo = "NotReachable";break
        case .Reachable(.EthernetOrWiFi):foo = "EthernetOrWiFi";break
        case .Reachable(.WWAN):foo = "WWAN";break
        }
        return foo
        //        do{
        //            let  networktype = try Reachability.reachabilityForInternetConnection().currentReachabilityStatus;
        //            return networktype.description
        //        }catch{
        //            return "No Connection"
        //            print(error)
        //        }
    }
    //  MARK: carrierType:运营商(e.g 中国联通)
    // TODO:
    public class func carrierType() -> String {
        return "中国联通"
    }
    // MARK:  IP Address
    // TODO:
    class func IPAddress()-> String {
        // Get the current IP Address
        let networkReachabilityManager : NetworkReachabilityManager = NetworkReachabilityManager.init()!
        var currentIPAddress = ""
        
        //        Reachability.reachabilityForInternetConnection()
        
        switch networkReachabilityManager.networkReachabilityStatus {
        case .Unknown : currentIPAddress = "0.0.0.0"; break
        case .NotReachable : currentIPAddress = "0.0.0.0";break
        // WiFi is in use
        case .Reachable(.EthernetOrWiFi):
            //            currentIPAddress = [self wiFiIPAddress];
            break
        case .Reachable(.WWAN):
            //            currentIPAddress = [self cellIPAddress];
            break
        }
        return currentIPAddress
    }
}