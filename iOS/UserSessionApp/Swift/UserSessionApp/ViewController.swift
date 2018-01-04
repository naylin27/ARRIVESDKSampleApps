//
//  ViewController.swift
//  UserSessionApp
//
//  Created by Radwar on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside
import UserNotifications

class ViewController: UIViewController, CSUserSessionDelegate {
    
    private var isStartTrack = true
    private var hasTrackingID = false
    
    @IBOutlet var tidTextField: UITextField!
    @IBOutlet var trackTokenField: UITextField!
    @IBOutlet var siteIdentierField: UITextField!
    @IBOutlet var errorTitleLabel: UILabel!
    @IBOutlet var errorDescriptionLabel: UILabel!
    @IBOutlet var errorSolutionLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var trackingIdentifierButton: UIButton!
    @IBOutlet var trackingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = ""
        isStartTrack = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.sessionValidated(notification:)), name: NSNotification.Name.init(rawValue: kSessionValidatedNotificationName), object: nil)
        resetError()
        CSUserSession.current().delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func sessionValidated(notification: Notification) {
        if let trackingIdentifier = CSUserSession.current().trackingIdentifier, !(trackingIdentifier.characters.isEmpty) {
            tidTextField.text = trackingIdentifier
            hasTrackingID = true
        } else {
            hasTrackingID = false
        }
        updateButtons()
    }
    
    private func resetError() {
        errorTitleLabel.text = ""
        errorDescriptionLabel.text = ""
        errorSolutionLabel.text = ""
    }
    
    @IBAction func updateTrackingIdentifier(_ sender: Any) {
        let newTrackingIdentifier = tidTextField.text
        if hasTrackingID {
            CSUserSession.current().trackingIdentifier = nil
            tidTextField.text = ""
            hasTrackingID = false
        } else {
            CSUserSession.current().trackingIdentifier = newTrackingIdentifier
            hasTrackingID = true
        }
        updateButtons()
    }
    
    private func updateButtons() {
        trackingIdentifierButton.setTitle(hasTrackingID ? "Unregister Tracking Identfier" : "Set Tracking Identifier", for: .normal)
        trackingButton.setTitle(isStartTrack ? "Start Tracking Site" : "Stop Tracking Site", for: .normal)
    }

    @IBAction func startTracking(_ sender: Any) {
        resetError()
        let trackingIdentifier = tidTextField.text ?? ""
        let trackToken = trackTokenField.text ?? ""
        let siteIdentifier = siteIdentierField.text ?? ""
        
        if isStartTrack {
            if (trackingIdentifier.characters.count == 0) {
                errorTitleLabel.text = "Empty Tracking Identifier.";
                return;
            }
            
            if (trackToken.characters.count == 0) {
                errorTitleLabel.text = "Empty track token.";
                return;
            }
            
            if (siteIdentifier.characters.count == 0) {
                errorTitleLabel.text = "Empty site Identifier.";
                return;
            }
            CSUserSession.current().startTripToSite(withIdentifier: siteIdentifier, trackToken: trackToken)
        } else {
            let trackToken = trackTokenField.text
            CSUserSession.current().cancelTripToSite(withIdentifier: siteIdentifier, trackToken: trackToken)
            
            siteIdentierField.text = nil
            trackTokenField.text = nil
            isStartTrack = true
            
        }
        updateButtons()
    }
    
    func showLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body;
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "AlertIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = (error as NSError?) {
                print("Something went wrong: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - CSUserSessionDelegate
    
    func session(_ session: CSSession, changedState newState: CSSessionState) {
        if newState == .valid {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kSessionValidatedNotificationName), object: nil)
        }
        print("Session changed state to: \(newState.rawValue)")
    }
    
    func session(_ session: CSUserSession, canNotifyMonitoringSessionUserAt site: CSSite) {
        print("Session can notify associate at: \(site.siteIdentifier)")
    }
    
    func session(_ session: CSUserSession, userArrivedAt site: CSSite) {
        guard let trackingIdentifier = CSUserSession.current().trackingIdentifier else { return }
        statusLabel.text = "\(trackingIdentifier) arrived at site \(site.siteIdentifier)"
        
        showLocalNotification(title: "Arrival Notificaton!", body: "Arrived at site \(site.siteIdentifier)")
        
        // Complete the trip.
        session.completeTripToSite(withIdentifier: site.siteIdentifier, trackToken: nil)
    }
    
    func session(_ session: CSUserSession, userApproachingSite site: CSSite) {
        guard let trackingIdentifier = CSUserSession.current().trackingIdentifier else { return }
        statusLabel.text = "\(trackingIdentifier) approaching at site \(site.siteIdentifier)"
        
        showLocalNotification(title: "Approaching Notificaton!", body: "Approaching site \(site.siteIdentifier)")
    }
    
    func session(_ session: CSUserSession, encounteredError error: Error, forOperation customerSessionAction: CSUserSessionAction) {
        guard let error = (error as NSError?),
            let userInfo = error.userInfo as? [String : Any] else { return }
        
        errorTitleLabel.text = userInfo[NSLocalizedDescriptionKey] as? String
        errorDescriptionLabel.text = userInfo[NSLocalizedFailureReasonErrorKey] as? String
        errorSolutionLabel.text = userInfo[NSLocalizedRecoverySuggestionErrorKey] as? String
    }
    
    func session(_ session: CSUserSession, updatedTrackedSites trackedSites: Set<CSSite>) {
        // We will just show the first one for now. It is in dispatch_async because we are making changes in the UI
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if trackedSites.isEmpty {
                strongSelf.isStartTrack = true
            } else {
                let site = trackedSites.first!
                strongSelf.siteIdentierField.text = site.siteIdentifier
                if let firstTrackToken = site.tripInfos?.first?.trackToken {
                    strongSelf.trackTokenField.text = firstTrackToken
                } else {
                    strongSelf.trackTokenField.text = ""
                }
                strongSelf.isStartTrack = false
            }
            strongSelf.updateButtons()
        }
    }
}
