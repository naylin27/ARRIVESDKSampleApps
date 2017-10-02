//
//  AppDelegate.swift
//  MobileClient
//
//  Created by Radwar on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside
import CoreLocation

let kSessionValidatedNotificationName = "SessionValidatedNotificationName"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CSMobileSessionDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Mobile Clients
        let sdkSession = CSMobileSession.createSession(withUsageToken: "YOUR_USAGE_TOKEN", delegate: self)
        
        // Call sessions method application:didFinishLaunchingWithOptions:
        sdkSession.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        // Request always authorization
        locationManager.requestAlwaysAuthorization()
        
        return true
    }
    
    // MARK: - CSMobileSessionDelegate

    func session(_ session: CSSession, changedState newState: CSSessionState) {
        if newState == .valid {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kSessionValidatedNotificationName), object: nil)
        }
        print("Session changed state to: \(newState.rawValue)")
    }
    
    func session(_ session: CSMobileSession, canNotifyAssociateAt site: CSSite) {
        print("Session can notify associate at: \(site.siteIdentifier)")
    }
    
    func session(_ session: CSMobileSession!, statusUpdatedFor siteOpsNotification: CSSiteOpsNotification!) {
        print("Session status updated for site ops notification: \(siteOpsNotification.description)")
    }
}

