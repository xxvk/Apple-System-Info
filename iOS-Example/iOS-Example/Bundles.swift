//
//  Bundles.swift
//  iOS-Example
//
//  Created by ea on 16/8/8.
//  Copyright © 2016年 vk. All rights reserved.
//

import UIKit
//  MARK: - Spliter
class BundlesSpliter: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitView_setup()
    }
    func splitView_setup() {
        self.presentsWithGesture = false
        self.preferredDisplayMode = .allVisible
        self.minimumPrimaryColumnWidth = 320
        self.maximumPrimaryColumnWidth = 500
        self.preferredPrimaryColumnWidthFraction = 0.3
    }
}
//  MARK: - Master
class Bundles: UITableViewController {
    
}
//  MARK: - Detail
class BundlesDetail: UITableViewController {
    
}
