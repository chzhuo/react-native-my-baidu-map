//
//  RCTMarkerView.swift
//  reactNativeSBaiduMap
//
//  Created by Arno on 2019/7/16.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation

@objc(RCTPolylineView)
class RCTPolylineView: RCTViewManager{
  
  
  override func view() -> UIView? {
    return RCTPolylineOverView()
  }
  
  override class func requiresMainQueueSetup() -> Bool {
    return false;
  }
  
}
