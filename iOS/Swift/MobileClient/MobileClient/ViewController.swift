//
//  ViewController.swift
//  MobileClient
//
//  Created by Radwar on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside

class ViewController: UIViewController, CSTrackerDelegate {
    
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
        CSTracker.shared().delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func sessionValidated(notification: Notification) {
        if let trackingIdentifier = CSMobileSession.current().trackingIdentifier, !(trackingIdentifier.characters.isEmpty) {
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
            CSMobileSession.current().trackingIdentifier = nil
            tidTextField.text = ""
            hasTrackingID = false
        } else {
            CSMobileSession.current().trackingIdentifier = newTrackingIdentifier
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
            
            let site = CSUserSite.init(siteIdentifier: siteIdentifier, trackTokens: [trackToken])
            CSTracker.shared().startTrackingUserSite(site)
        } else {
            var trackTokens = [String]()
            if let trackToken = trackTokenField.text, !trackToken.characters.isEmpty {
                trackTokens = [trackToken]
            }
            let site = CSUserSite.init(siteIdentifier: siteIdentifier, trackTokens: trackTokens)
            CSTracker.shared().stopTrackingUserSite(site)
            
            siteIdentierField.text = nil
            trackTokenField.text = nil
            isStartTrack = true
            
        }
        updateButtons()
    }

    // MARK: - CSTrackerDelegate
    
    func tracker(_ tracker: CSTracker!, userArrivedAt site: CSUserSite!) {
        guard let trackingIdentifier = CSMobileSession.current().trackingIdentifier else { return }
        statusLabel.text = "\(trackingIdentifier) arrived at site \(site.siteIdentifier)"
        
    }
    
    func tracker(_ tracker: CSTracker!, userApproachingSite site: CSUserSite!) {
        guard let trackingIdentifier = CSMobileSession.current().trackingIdentifier else { return }
        statusLabel.text = "\(trackingIdentifier) approaching at site \(site.siteIdentifier)"
    }
    
    func tracker(_ tracker: CSTracker!, encounteredError error: Error!, forOperation trackerAction: CSTrackerAction) {
        guard let error = error as NSError?,
        let userInfo = error.userInfo as? [String : Any] else { return }
        
        errorTitleLabel.text = userInfo[NSLocalizedDescriptionKey] as? String
        errorDescriptionLabel.text = userInfo[NSLocalizedFailureReasonErrorKey] as? String
        errorSolutionLabel.text = userInfo[NSLocalizedRecoverySuggestionErrorKey] as? String
    }
    
    func tracker(_ tracker: CSTracker!, updatedTrackedSites trackedSites: Set<AnyHashable>!) {
        guard let trackedSites = trackedSites as? Set<CSUserSite> else { return }
        // We will just show the first one for now. It is in dispatch_async because we are making changes in the UI
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if trackedSites.isEmpty {
                strongSelf.isStartTrack = true
            } else {
                let site = trackedSites.first!
                strongSelf.siteIdentierField.text = site.siteIdentifier
                if site.trackTokens != nil, let firstTrackToken = site.trackTokens.first as? String {
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
