//
//  AppInfo.swift
//  store_killer_ios
//
//  Created by 樊半缠 on 16/7/12.
//  Copyright © 2016年 樊半缠. All rights reserved.
//

import Foundation

//  MARK: - AppInfo:软件
public class BundleInfo{
    //  MARK: appVersion:app版本
    //(e.g 1.7)
    class var appVersion: String {
        get{
            let dicInfo : Dictionary<String , Any> = NSBundle.mainBundle().infoDictionary!
            
            let strAppVer : String = dicInfo["CFBundleShortVersionString"] as! String
            
            return strAppVer
        }
    }
    //  MARK: appBuild:appBuild号码
    //(e.g )
    class var appBuild: String {
        get{
            let dicInfo : Dictionary<String , Any> = NSBundle.mainBundle().infoDictionary!
            
            let strAppBuild : String = dicInfo["CFBundleVersion"] as! String
            
            return strAppBuild
        }
    }
    
    
}