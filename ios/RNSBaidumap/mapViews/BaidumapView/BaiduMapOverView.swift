//
//  BaiduMapBaseVIew.swift
//  reactNativeSBaiduMap
//
//  Created by Arno on 2019/7/15.
//  Copyright © 2019年 Facebook. All rights reserved.
//
import UIKit

class BaiduMapOverView: BMKMapView, BMKMapViewDelegate{
  
  @objc public var onMapClick: RCTBubblingEventBlock!
  @objc public var onMapLongClick: RCTBubblingEventBlock!
  @objc public var onMapDoubleClick: RCTBubblingEventBlock!
  @objc public var onMapPoiClick: RCTBubblingEventBlock!
  @objc public var onMapStatusChangeStart: RCTBubblingEventBlock!
  @objc public var onMapStatusChange: RCTBubblingEventBlock!
  @objc public var onMapStatusChangeFinish: RCTBubblingEventBlock!
  @objc public var onMapLoaded: RCTBubblingEventBlock!
  @objc public var onMarkerDragStart: RCTBubblingEventBlock!
  @objc public var onMarkerDrag: RCTBubblingEventBlock!
  @objc public var onMarkerDragEnd: RCTBubblingEventBlock!
  @objc public var onMarkerClick: RCTBubblingEventBlock!
  
  lazy var userLocation: BMKUserLocation = {
    return BMKUserLocation()
  }()
  
  lazy var locationViewDisplayParam: BMKLocationViewDisplayParam = {
    return BMKLocationViewDisplayParam()
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: CGRect.zero)
    self.delegate = self;
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  func setZoom(_ zoom: Float) -> Void {
    self.zoomLevel = zoom
  }
  
  @objc
  func setZoomMaxLevel(_ zoom: Float) -> Void {
    self.maxZoomLevel = zoom
  }
  
  @objc
  func setZoomMinLevel(_ zoom: Float) -> Void {
    self.minZoomLevel = zoom
  }
  
  @objc
  func setIsTrafficEnabled(_ trafficEnabled: Bool) -> Void {
    self.isTrafficEnabled = trafficEnabled;
  }
  
  @objc
  func setIsBaiduHeatMapEnabled(_ isBaiduHeatMapEnabled: Bool) -> Void {
    self.isBaiduHeatMapEnabled = isBaiduHeatMapEnabled;
  }
  
  @objc
  func setBaiduMapType(_ type: NSNumber) -> Void {
    var mapType: BMKMapType;
    switch type {
    case 1:
      //设置当前地图类型为标准地图
      mapType = BMKMapType.standard
    case 2:
      //设置当前地图类型为卫星地图
      mapType = BMKMapType.satellite
    default:
      //设置当前地图类型为空白地图
      mapType = BMKMapType.none
      break;
    }
    self.mapType = mapType;
  }
  
  @objc
  func setCenterLatLng(_ center: NSDictionary!) -> Void {
    let lat:Double = center?["latitude"] as! Double;
    let lng:Double = center?["longitude"] as! Double;
    self.centerCoordinate = CLLocationCoordinate2DMake(lat, lng);
  }
  
  @objc
  func setZoomControlsVisible(_ zoomControlsVisible: Bool) -> Void {
    self.showMapScaleBar = zoomControlsVisible;
  }

  //设置地图使显示区域显示所有annotations,如果数组中只有一个则直接设置地图中心为annotation的位置
  @objc
  func setZoomToSpanMarkers(_ annotations: NSArray!) -> Void {
    self.showAnnotations(self.annotations, animated: true)
  }
  
  @objc
  func setMapCenter(_ center: NSDictionary!) -> Void {
    let lat:Double = center?["latitude"] as! Double;
    let lng:Double = center?["longitude"] as! Double;
    self.centerCoordinate = CLLocationCoordinate2DMake(lat, lng);
  }
  
  @objc
  func setZoomGesturesEnabled(_ zoomGesturesEnabled: Bool) -> Void {
    self.isZoomEnabledWithTap = zoomGesturesEnabled;
  }
  
  @objc
  func setScrollGesturesEnabled(_ scrollGesturesEnabled: Bool) -> Void {
    self.isScrollEnabled = scrollGesturesEnabled;
  }
  
  @objc
  func setOverlookingGesturesEnabled(_ overlookingGesturesEnabled: Bool) -> Void {
    self.isOverlookEnabled = overlookingGesturesEnabled;
  }
  
  @objc
  func setRotateGesturesEnabled(_ rotateGesturesEnabled: Bool) -> Void {
    self.isRotateEnabled = rotateGesturesEnabled;
  }
  
  @objc
  func setMapCustomStyleFileName(_ mapCustomStyleFileName: String!) -> Void {
    let isEnable = mapCustomStyleFileName != "";
    if(isEnable){
      //设置在线个性化地图样式
      let option: BMKCustomMapStyleOption = BMKCustomMapStyleOption()
      //请输入您的在线个性化样式ID
  //    option.customMapStyleID = customMapStyleID
      //获取本地个性化地图模板文件路径
      let customPath: String = Bundle.main.path(forResource: mapCustomStyleFileName, ofType:"json")!
      //在线样式ID加载失败后会加载此路径的文件
      option.customMapStyleFilePath = customPath;
      self.setCustomMapStyleWith(option, preLoad: { (path) in
          print(path as Any)
      }, success: { (path) in
          print(path as Any)
      }) { (error, path) in
          print(error as Any)
      }
    };
    self.setCustomMapStyleEnable(isEnable)
  }
  
  @objc
  func setLocationEnabled(_ locationEnabled: Bool) -> Void {
    self.showsUserLocation = locationEnabled;
  }
  
  @objc
  func setMyLocationData(_ myLocationData: Dictionary<String, Any>!) -> Void {
    if(myLocationData["latitude"] != nil && myLocationData["longitude"] != nil) {
      let latitude: Double = myLocationData?["latitude"] as! Double;
      let longitude: Double = myLocationData?["longitude"] as! Double;
      userLocation.location = CLLocation(latitude: latitude, longitude: longitude);
      self.updateLocationData(userLocation)
      if(myLocationData["locationMode"] != nil) {
//        var fillColor: String = "";
//        var strokeColor: String = "";
        let locationMode: Int = myLocationData?["locationMode"] as! Int;
        var userTrackingMode = BMKUserTrackingModeNone;
        switch locationMode {
        case 1:
          userTrackingMode = BMKUserTrackingModeFollow
        case 2:
          userTrackingMode = BMKUserTrackingModeFollowWithHeading
        default:
          userTrackingMode = BMKUserTrackingModeNone;
        }
        self.userTrackingMode = userTrackingMode
        
//        if(myLocationData["fillColor"] != nil) {
//          fillColor = myLocationData["fillColor"] as! String;
//          //设置精度圈填充颜色
//          locationViewDisplayParam.accuracyCircleFillColor = UIColor.colorWithHex(hexStr: fillColor);
//        }
//        if(myLocationData["strokeColor"] != nil) {
//          strokeColor = myLocationData["strokeColor"] as! String;
//          //设置精度圈填充颜色
//          locationViewDisplayParam.accuracyCircleStrokeColor = UIColor.colorWithHex(hexStr: strokeColor);
//        }
//        locationViewDisplayParam.isAccuracyCircleShow = true;
//        self.updateLocationView(with: locationViewDisplayParam)
      }
    }
  }
  
  public func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
    self.onMapClick(["latitude": coordinate.latitude, "longitude":coordinate.longitude]);
  }
  
  public func mapview(_ mapView: BMKMapView!, onLongClick coordinate: CLLocationCoordinate2D) {
    self.onMapLongClick(["latitude": coordinate.latitude, "longitude":coordinate.longitude]);
  }
  
  public func mapview(_ mapView: BMKMapView!, onDoubleClick coordinate: CLLocationCoordinate2D) {
    self.onMapDoubleClick(["latitude": coordinate.latitude, "longitude":coordinate.longitude]);
  }
  
  public func mapView(_ mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
    let data = [
      "name": mapPoi.text!,
      "id": mapPoi.uid!,
      "latitude": mapPoi.pt.latitude,
      "longitude": mapPoi.pt.longitude
      ] as [String : Any];
    self.onMapPoiClick(data);
  }
  
  public func mapStatusDidChanged(_ mapView: BMKMapView!) {
    let latlng: CLLocationCoordinate2D! = mapView.getMapStatus().targetGeoPt;
    let data = [
      "latitude": latlng.latitude,
      "longitude": latlng.longitude,
      "zoomLevel": self.zoomLevel
      ] as [String : Any];
    if(self.onMapStatusChange != nil) {
      self.onMapStatusChange(data);
    }
  }
  
  public func mapView(_ mapView: BMKMapView!, regionWillChangeAnimated animated: Bool) {
    let latlng: CLLocationCoordinate2D! = mapView.getMapStatus().targetGeoPt;
    let data = [
      "latitude": latlng.latitude,
      "longitude": latlng.longitude,
      "zoomLevel": self.zoomLevel
      ] as [String : Any];
    self.onMapStatusChangeStart(data);
  }
  
  public func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool, reason: BMKRegionChangeReason) {
    let latlng: CLLocationCoordinate2D! = mapView.getMapStatus().targetGeoPt;
    let data = [
      "latitude": latlng.latitude,
      "longitude": latlng.longitude,
      "zoomLevel": self.zoomLevel
      ] as [String : Any];
     self.onMapStatusChangeFinish(data);
  }
  
  public func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
    let data = [:] as [String : Any];
    self.onMapLoaded(data)
  }
  
  public func mapView(_ mapView: BMKMapView!, annotationView view: BMKAnnotationView!, didChangeDragState newState: UInt, fromOldState oldState: UInt) {
    let latlng: CLLocationCoordinate2D! = view.annotation.coordinate;
    let data = [
      "latitude": latlng.latitude,
      "longitude": latlng.longitude
      ] as [String : Any];
    if(newState == BMKAnnotationViewDragStateStarting && self.onMarkerDragStart != nil) {
      self.onMarkerDragStart(data)
    }else if(newState == BMKAnnotationViewDragStateDragging && self.onMarkerDrag != nil) {
      self.onMarkerDrag(data)
    }else{
      //BMKAnnotationViewDragStateEnding
      if(self.onMarkerDragEnd != nil) {
        self.onMarkerDragEnd(data)
      }
    }
  }
    
  func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
    self.onMarkerClick(["latitude": view.annotation.coordinate.latitude, "longitude":view.annotation.coordinate.longitude]);
  }
  
  //MARK:BMKMapViewDelegate
  /**
   根据anntation生成对应的annotationView
   @param mapView 地图View
   @param annotation 指定的标注
   @return 生成的标注View
   */
  public func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
    let newAnnotation = annotation as? CustomAnnotation;
    let annotationViewIdentifier = "com.Baidu.BMKPinAnnotation";
    var annotationView: BMKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier) as? BMKPinAnnotationView
    if annotationView == nil {
      annotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: annotationViewIdentifier)
      //设置mark图片
//      annotationView?.image = UIImage(named: newAnnotation?.icon ?? "")
      annotationView?.image = newAnnotation?.icon
      //当设为YES并实现了setCoordinate:方法时，支持将annotationView在地图上拖动
      annotationView?.isDraggable = newAnnotation!.draggable
      //默认为NO,当为YES时为会弹出气泡
      annotationView?.isSelected = newAnnotation!.active
      //当为YES时，view被选中时会弹出气泡，annotation必须实现了title这个方法
      annotationView?.canShowCallout = newAnnotation!.active;
      //当选中其他annotation时，当前annotation的泡泡是否隐藏，默认值为NO
      annotationView?.hidePaopaoWhenSelectOthers = false
      //当选中其他annotation时，当前annotation的泡泡是否隐藏，默认值为NO
      annotationView?.calloutOffset = CGPoint(x: 0, y: Int(truncating: newAnnotation!.infoWindowYOffset));
      //annotationView展示优先级
      annotationView?.displayPriority = BMKFeatureDisplayPriority(truncating: newAnnotation!.zIndex)
      //保存当前annotationView，用以刷新视图
      newAnnotation?.annotationView = annotationView;
      return annotationView
    }
    return nil
  }
  
//MARK:BMKMapViewDelegate
/**
 根据overlay生成对应的BMKOverlayView
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
  public func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
    if overlay.isKind(of: BMKPolyline.self) {
      let newOverlay = overlay as! CustomBMKPolyline
      //初始化一个overlay并返回相应的BMKPolylineView的实例
      let polylineView = BMKPolylineView(polyline: overlay as? BMKPolyline)
      //设置polylineView的画笔颜色
      polylineView?.strokeColor = UIColor.colorWithHex(hexStr: newOverlay.color)
      //设置polylineView的画笔宽度为32
      polylineView?.lineWidth = newOverlay.width as! CGFloat
      newOverlay.polylineView = polylineView!;
      return polylineView
    } else if overlay.isKind(of: BMKArcline.self) {
      let newOverlay = overlay as! CustomBMKArcline
      //初始化一个overlay并返回相应的BMKArclineView的实例
      let arclineView = BMKArclineView(arcline: overlay as? BMKArcline)
      //设置arclineView的画笔颜色
      arclineView?.strokeColor = UIColor.colorWithHex(hexStr: newOverlay.color)
      //设置arclineView的画笔宽度为32
      arclineView?.lineWidth = newOverlay.width as! CGFloat
      newOverlay.arclineView = arclineView!;
      return arclineView
    } else if overlay.isKind(of: BMKCircle.self) {
      let newOverlay = overlay as! CustomBMKCircle
      //初始化一个overlay并返回相应的BMKCircleView的实例
      let circleView: BMKCircleView = BMKCircleView(circle: overlay as? BMKCircle)
      //设置circleView的填充色
      circleView.fillColor = UIColor.colorWithHexAlpha(hexStr: newOverlay.fillColor, alpha: newOverlay.fillColorAlpha)
      //设置circleView的画笔（边框）颜色
      circleView.strokeColor = UIColor.colorWithHex(hexStr: newOverlay.color)
      //设置circleView的轮廓宽度
      circleView.lineWidth = newOverlay.width as! CGFloat
      newOverlay.circleView = circleView;
      return circleView
    }else if overlay.isKind(of: BMKPolygon.self) {
      let newOverlay = overlay as! CustomBMKPolygon
      //初始化一个overlay并返回相应的BMKPolygonView的实例
      let polygonView = BMKPolygonView(polygon: overlay as? BMKPolygon)
      //设置polygonView的填充色
      polygonView?.fillColor = UIColor.colorWithHexAlpha(hexStr: newOverlay.fillColor, alpha: newOverlay.fillColorAlpha)
      //设置polygonView的画笔（边框）颜色
      polygonView?.strokeColor = UIColor.colorWithHex(hexStr: newOverlay.color)
      //设置polygonView的轮廓宽度
      polygonView?.lineWidth = newOverlay.width as! CGFloat
      newOverlay.polygonView = polygonView;
      return polygonView
    }
    return nil
  }
  
  open override func didAddSubview(_ subview: UIView) {
    if(subview is RCTMarkerOverView) {
      let _subview = subview as? RCTMarkerOverView;
      _subview?.addToMap(self)
    }else if(subview is RCTPolylineOverView) {
      let _subview = subview as? RCTPolylineOverView;
      _subview?.addToMap(self)
    }else if(subview is RCTArcOverView) {
      let _subview = subview as? RCTArcOverView;
      _subview?.addToMap(self)
    }else if(subview is RCTCircleOverView) {
      let _subview = subview as? RCTCircleOverView;
      _subview?.addToMap(self)
    }else if(subview is RCTPolygonOverView) {
      let _subview = subview as? RCTPolygonOverView;
      _subview?.addToMap(self)
    }
  }
  
  open override func willRemoveSubview(_ subview: UIView) {
      if(subview is RCTMarkerOverView) {
        let _subview = subview as? RCTMarkerOverView;
        self.removeAnnotation(_subview?.annotation)
      }else if(subview is RCTPolylineOverView) {
        let _subview = subview as? RCTPolylineOverView;
        self.remove(_subview?.polyline)
      }else if(subview is RCTArcOverView) {
        let _subview = subview as? RCTArcOverView;
        self.remove(_subview?.arcline)
      }else if(subview is RCTCircleOverView) {
        let _subview = subview as? RCTCircleOverView;
        self.remove(_subview?.circle)
      }else if(subview is RCTPolygonOverView) {
        let _subview = subview as? RCTPolygonOverView;
        self.remove(_subview?.polygon)
      }
  }
  
//  override func willMove(toWindow newWindow: UIWindow?) {
//    super.willMove(toSuperview: newWindow)
//    if(newWindow == nil) {
//      //当mapView即将被隐藏的时候调用，存储当前mapView的状态
//      self.viewWillDisappear()
//      self.delegate = nil
//    }
//  }

}
