//
//  Authorized.swift
//  iOS-Example
//
//  Created by ea on 16/8/8.
//  Copyright © 2016年 vk. All rights reserved.
//

import UIKit
import Apple_System_Info
import CoreLocation

//  MARK: - Spliter
class AuthorizedSpliter: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitView_setup()
    }
    
    func splitView_setup() {
        self.presentsWithGesture = false
        self.preferredDisplayMode = .AllVisible
        self.minimumPrimaryColumnWidth = 320
        self.maximumPrimaryColumnWidth = 500
        self.preferredPrimaryColumnWidthFraction = 0.3
        
    }
}
struct AuthorizeElement {
    let selector: Selector
//    let type: AnyObject.Type
    let possibleValues: [Any]
    
//    private let _timer: NSTimer
    
    init(selector: Selector, possibleValues: [AnyObject]){
        self.selector = selector
//        self.type = 
        self.possibleValues = possibleValues
        
//        self._timer = NSTimer(timeInterval: 0.25, target: UIApplication.sharedApplication(), selector: selector, userInfo: nil, repeats: false)
    }
    
    func fire() -> Unmanaged<AnyObject>! {
//        self._timer.fire()
        return UIApplication.sharedApplication().performSelector(self.selector)
    }
}

class DataSources {
    
    @objc static let function = { return Apple_System_Info.AuthorizedInfo.Location}
    
    let taype = function().self
    
//    let sel = #selector(function)
//    print()
//    
//    
//    let ptr = UnsafePointer.init()
//
//    let quizs = [CLAuthorizationStatus.NotDetermined, CLAuthorizationStatus.Restricted,CLAuthorizationStatus.Denied, CLAuthorizationStatus.AuthorizedAlways, CLAuthorizationStatus.AuthorizedWhenInUse]
//    
//    let foo = AuthorizeElement.init(selector: sel, possibleValues: quizs)
//    
//    
//    class var locationElement: AuthorizeElement!{
//        get{
//            
//            return foo
//        }
//    }
}
//  MARK: - Master
class Authorized: UITableViewController {
    var Elements: [AuthorizeElement] = []
}
//  MARK: - Detail
class AuthorizedDetail: UITableViewController {
    var aElement: AuthorizeElement!
    
    
    
}