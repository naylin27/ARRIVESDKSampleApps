//
//  AppDelegate.swift
//  TransmitApp
//
//  Created by Radwar on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside
import CoreLocation

let kSessionValidatedNotificationName = "SessionValidatedNotificationName"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Transmit Client
        let sdkSession = CSUserSession.createSession(withUsageToken: "YOUR_USAGE_TOKEN", delegate: nil)
        
        // Call sessions method application:didFinishLaunchingWithOptions:
        sdkSession.application(UIApplication.shared, didFinishLaunchingWithOptions: launchOptions)
        
        // Request always authorization
        locationManager.requestAlwaysAuthorization()
        
        return true
    }
    
}

