//
//  AppDelegate.swift
//  UserSessionApp
//
//  Created by Radwar on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside
import CoreLocation
import UserNotifications

let kSessionValidatedNotificationName = "SessionValidatedNotificationName"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let sdkSession = CSUserSession.createSession(withUsageToken: "YOUR_USAGE_TOKEN", delegate: nil)
        
        // Call sessions method application:didFinishLaunchingWithOptions:
        sdkSession.application(UIApplication.shared, didFinishLaunchingWithOptions: launchOptions)
        
        // Request always authorization
        locationManager.requestAlwaysAuthorization()
        
        // Request authorization to show notifications
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [UNAuthorizationOptions.alert, UNAuthorizationOptions.sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if (!granted) {
                print("Something went wrong");
            }
        }
        
        return true
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert])
    }
}

