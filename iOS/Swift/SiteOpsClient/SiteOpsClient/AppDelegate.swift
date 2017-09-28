//
//  AppDelegate.swift
//  SiteOpsClient
//
//  Created by Radwar on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CSSessionDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Site Ops Clients
        let sdksession = CSSiteOpsSession.createSession(withAPIKey: "YOUR_API_KEY", secret: "YOUR_SECRET_KEY", delegate: self)
        
        // Call sessions method application:didFinishLaunchingWithOptions:
        sdksession?.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        return true
    }

    // MARK: - CSSessionDelegate
    
    func session(_ session: CSSession!, changedState newState: CSSessionState) {
        print("Session changed state to: \(newState.rawValue)")
    }
}

