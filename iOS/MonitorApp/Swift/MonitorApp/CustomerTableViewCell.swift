//
//  CustomerTableViewCell.swift
//  MonitorApp
//
//  Created by Hon Chen on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside

let kCustomerTableViewCellIdentifier = "kCustomerTableViewCellIdentifier"

class CustomerTableViewCell: UITableViewCell {

    var userStatusUpdate: CSUserStatusUpdate? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet var customerNameTIDLabel: UILabel!
    @IBOutlet var etaValueLabel: UILabel!
    @IBOutlet var distanceValueLabel: UILabel!
    @IBOutlet var dateValueLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var endTripButton: UIButton!
    @IBOutlet var cancelTripButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        endTripButton.layer.cornerRadius = 4.0
        cancelTripButton.layer.cornerRadius = 4.0
    }
    
    private func updateUI() {
        guard let userStatusUpdate = userStatusUpdate else {
            customerNameTIDLabel.text = nil
            distanceValueLabel.text = nil
            etaValueLabel.text = nil
            dateValueLabel.text = nil
            statusLabel.text = nil
            return
        }
        
        // set customer name TID
        if let customerName = userStatusUpdate.userInfo?.fullName, !(customerName.characters.isEmpty) {
            customerNameTIDLabel.text = customerName
        } else {
            customerNameTIDLabel.text = userStatusUpdate.trackingIdentifier
        }
        
        // set distance
        distanceValueLabel.text = FormatDistance(Float(userStatusUpdate.distanceFromSite))
        
        // set eta
        let eta = userStatusUpdate.estimatedTimeOfArrival
        etaValueLabel.text = eta > 0 ? FormatSeconds(eta) : "-"
        
        // set date
        dateValueLabel.text = FormatDate(userStatusUpdate.lastUpdateTimestamp)
        
        // set user status
        switch userStatusUpdate.userStatus {
        case .arrived:
            statusLabel.text = "Arrived"
        case .inTransit:
            statusLabel.text = "In Transit"
        case .approaching:
            statusLabel.text = "Approaching Site"
        case .userInitiatedArrived:
            statusLabel.text = "Customer Initiated Arrived"
        case .unknown:
            statusLabel.text = "Unknown"
        }
    }
    
    @IBAction func endTrip(_ sender: Any) {
        if let trackingIdentifier = userStatusUpdate?.trackingIdentifier {
            CSMonitoringSession.current().completeTrip(forTrackingIdentifier: trackingIdentifier, trackTokens: nil)
        }
    }
    
    @IBAction func cancelTrip(_ sender: Any) {
        if let trackingIdentifier = userStatusUpdate?.trackingIdentifier {
            CSMonitoringSession.current().cancelTrip(forTrackingIdentifier: trackingIdentifier, trackTokens: nil)
        }
    }

}
