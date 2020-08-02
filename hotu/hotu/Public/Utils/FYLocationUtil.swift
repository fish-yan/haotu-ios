
//
//  FYLocationUtil.swift
//  joint-operation
//
//  Created by Yan on 2018/12/7.
//  Copyright © 2018 Yan. All rights reserved.
//

import UIKit
import CoreLocation

class FYLocationUtil: NSObject {
    
    static let share = FYLocationUtil()
    
    var locationManager = CLLocationManager()
    
    var currentPlace:CLPlacemark?
        
    private var complete: ((CLPlacemark?) -> Void)!
    
    func startLocation(complete: @escaping (CLPlacemark?) -> Void) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.complete = complete
        if checkAuthorization() {
            locationManager.startUpdatingLocation()
        } else {
            HTUserInfo.share.province = "上海市"
            HTUserInfo.share.city = "上海市"
            HTUserInfo.share.area = "浦东新区"
            HTUserInfo.share.address = "世博大道"
            HTUserInfo.share.latitude = 31.188738
            HTUserInfo.share.longitude = 121.493188
            self.complete(self.currentPlace)
        }
    }
    
    private func checkAuthorization() -> Bool {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return true
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return true
        }
        
        if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "定位未开启", message: "为了更好的体验,请到设置->隐私->定位服务中开启【好兔】定位服务,已便获取附近信息!", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "手动选择", style: .cancel, handler: nil)
            let action2 = UIAlertAction(title: "去开启", style: .default) { (action) in
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.addAction(action1)
            alert.addAction(action2)
            visibleViewController?.present(alert, animated: true, completion: nil)
            return false
        }
        return false
    }
    
    func geocodeLocation(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let place = placemarks?.first {
                if place.administrativeArea == nil && place.locality != nil {
                    HTUserInfo.share.province = place.locality ?? "上海市"
                } else {
                    HTUserInfo.share.province = place.administrativeArea ?? "上海市"
                }
                HTUserInfo.share.city = place.locality ?? "上海市"
                HTUserInfo.share.area = place.subLocality ?? "浦东新区"
                HTUserInfo.share.address = place.subLocality ?? "世博大道"
                HTUserInfo.share.latitude = place.location?.coordinate.latitude ?? 31.188738
                HTUserInfo.share.longitude = place.location?.coordinate.longitude ?? 121.493188
                self.currentPlace = place
                self.complete(self.currentPlace)
            } else {
                HTUserInfo.share.province = "上海市"
                HTUserInfo.share.city = "上海市"
                HTUserInfo.share.area = "浦东新区"
                HTUserInfo.share.address = "世博大道"
                HTUserInfo.share.latitude = 31.188738
                HTUserInfo.share.longitude = 121.493188
                self.complete(self.currentPlace)
                print("定位失败：\(String(describing: error?.localizedDescription))")
            }
        }
    }
    
}

extension FYLocationUtil: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            geocodeLocation(location)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.complete(self.currentPlace)
        print("定位失败：\(error.localizedDescription)")
        self.locationManager.stopUpdatingLocation()
    }
}

