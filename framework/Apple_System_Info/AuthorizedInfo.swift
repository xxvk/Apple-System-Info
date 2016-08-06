//
//  AuthorizedInfo.swift
//  store_killer_ios
//
//  Created by 樊半缠 on 16/7/12.
//  Copyright © 2016年 reformation.tech. All rights reserved.
//

import Foundation
import CoreLocation

//  MARK: - Authorized:权限
public class AuthorizedInfo{
    //  MARK: isLocationAuthorized:地理位置是否可用(e.g bool)
    class var Location: Bool {
        get{
            let  status : CLAuthorizationStatus = CLLocationManager.authorizationStatus();
            if (status == CLAuthorizationStatus.NotDetermined
                ||
                status == CLAuthorizationStatus.Restricted
                ||
                status == CLAuthorizationStatus.Denied)
            {
                return false;
            }else{
                return true;
            }
        }
    }
}
