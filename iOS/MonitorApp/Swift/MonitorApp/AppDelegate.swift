//
//  AppDelegate.swift
//  MonitorApp
//
//  Created by Radwar on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Monitor Client
        let sdksession = CSMonitoringSession.createSession(withAPIKey: "YOUR_API_KEY", secret: "YOUR_SECRET_KEY", delegate: nil)
        
        // Call sessions method application:didFinishLaunchingWithOptions:
        sdksession.application(UIApplication.shared, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
}

