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
import SwiftyJSON

//  MARK: - Network:网络
public class NetworkInfo{
    //  MARK:  networkStatus:网络连接状态(NotReachable/ReachableViaWiFi/ReachableViaWWAN)
    // TODO:
    public class func status() -> Reachability.NetworkStatus {
        do{
            let  networktype = try Reachability.reachabilityForInternetConnection().currentReachabilityStatus;
            return networktype
        }catch{
            print(error)
            return .NotReachable
        }
    }
    
    //  MARK: carrier:运营商(e.g 中国联通)
    public class func carrier() -> String {
        let tNetwork = CTTelephonyNetworkInfo()
        let carrier  = tNetwork.subscriberCellularProvider
        var carrier_name : String?
        var carrier_code : String?
        
        carrier_name = carrier!.carrierName ?? ""
        carrier_code = carrier!.mobileNetworkCode ?? ""
        
        return carrier_name!
    }
    
    // MARK:  IP Address
    class func IPAddress(completionHandler: (String?) -> Void)-> Void {
        // Get the current IP Address\
        let SERVICE_BASE_URL = "https://freegeoip.net/json/"
        let session = NSURLSession.sharedSession()
        var currentIPAddress = "0.0.0.0"
        
        switch self.status() {
        case .NotReachable :
            currentIPAddress = "0.0.0.0"
            completionHandler(currentIPAddress)
            break
        // WiFi is in use
        case .ReachableViaWiFi,.ReachableViaWWAN:
            session.dataTaskWithURL(NSURL(string: SERVICE_BASE_URL)!, completionHandler: { (data, response, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let json = JSON(data: data!)
                    currentIPAddress = json["ip"].string!
                    completionHandler(currentIPAddress)
                })
            }).resume()
            break
        }
    }
}