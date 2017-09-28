//
//  CustomerTableViewCell.swift
//  SiteOpsClient
//
//  Created by Hon Chen on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside

let kCustomerTableViewCellIdentifier = "kCustomerTableViewCellIdentifier"

class CustomerTableViewCell: UITableViewCell {

    var userLocationUpdate: CSUserLocationUpdate? {
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
        guard let userLocationUpdate = userLocationUpdate else {
            customerNameTIDLabel.text = nil
            distanceValueLabel.text = nil
            etaValueLabel.text = nil
            dateValueLabel.text = nil
            statusLabel.text = nil
            return
        }
        
        // set customer name TID
        if userLocationUpdate.customerInfo != nil, let customerName = userLocationUpdate.customerInfo.fullName, !(customerName.characters.isEmpty) {
            customerNameTIDLabel.text = customerName
        } else {
            customerNameTIDLabel.text = userLocationUpdate.trackingIdentifier
        }
        
        // set distance
        distanceValueLabel.text = FormatDistance(Float(userLocationUpdate.distanceFromSite))
        
        // set eta
        let eta = userLocationUpdate.estimatedTimeOfArrival
        etaValueLabel.text = eta > 0 ? FormatSeconds(eta) : "-"
        
        // set date
        dateValueLabel.text = FormatDate(userLocationUpdate.lastUpdateTimestamp)
        
        // set user status
        switch userLocationUpdate.userStatus {
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
        if let trackingIdentifier = userLocationUpdate?.trackingIdentifier {
            CSSiteArrivalTracker.shared().stopTrackingArrival(forTrackingIdentifier: trackingIdentifier)
        }
    }
    
    @IBAction func cancelTrip(_ sender: Any) {
        if let trackingIdentifier = userLocationUpdate?.trackingIdentifier {
            CSSiteArrivalTracker.shared().cancelTrackingArrival(forTrackingIdentifier: trackingIdentifier)
        }
    }

}
