//
//  ViewController.swift
//  SiteOpsClient
//
//  Created by Radwar on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit
import Curbside

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CSSiteArrivalTrackerDelegate {
    
    @IBOutlet var customersTableView: UITableView!
    var trackingIdentifier: String?
    var siteIdentifier: String?
    var customerLocationUpdates = [CSUserLocationUpdate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        customersTableView.delegate = self
        customersTableView.dataSource = self
        
        let customerCellProtoNib = UINib.init(nibName: "CustomerTableViewCell", bundle: Bundle.main)
        customersTableView.register(customerCellProtoNib, forCellReuseIdentifier: kCustomerTableViewCellIdentifier)
        customersTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CSSiteArrivalTracker.shared().delegate = self
        
        // Do we have a Site in preferences?
        readFromDefaults()
        if trackingIdentifier != nil && siteIdentifier != nil {
            startUpdates()
            title = siteIdentifier
        } else {
            showSetupViewController()
        }
    }
    
    @IBAction func close(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: kTrackingIdentifierKey)
        userDefaults.removeObject(forKey: kSiteIdentifierKey)
        userDefaults.synchronize()
        
        CSSiteArrivalTracker.shared().stopTrackingArrivals()
        showSetupViewController()
    }
    
    private func readFromDefaults() {
        let userDefaults = UserDefaults.standard
        trackingIdentifier = userDefaults.string(forKey: kTrackingIdentifierKey)
        siteIdentifier = userDefaults.string(forKey: kSiteIdentifierKey)
    }
    
    private func startUpdates() {
        CSSiteOpsSession.current().trackingIdentifier = trackingIdentifier
        let site = CSSite.init(siteIdentifier: siteIdentifier)
        let siteArrivalTracker = CSSiteArrivalTracker.shared()
        siteArrivalTracker?.startTrackingArrivals(for: site)
        siteArrivalTracker?.locationUpdateHandler = { [weak self] userLocationUpdates in
            guard let strongSelf = self else { return }
            guard let userLocationUpdates = userLocationUpdates as? [CSUserLocationUpdate] else { return  }
            strongSelf.customerLocationUpdates = userLocationUpdates
            strongSelf.customersTableView.reloadData()
            strongSelf.title = "\(strongSelf.siteIdentifier ?? "") @ \(FormatDate(Date.init()) ?? "")"
        }
        
    }
    
    private func showSetupViewController() {
        let vc = ConfigureViewController()
        present(vc, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerLocationUpdates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCustomerTableViewCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        if let customerCell = cell as? CustomerTableViewCell {
            customerCell.userLocationUpdate = customerLocationUpdates[indexPath.row]
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell at row: \(indexPath.row)")
    }

    // MARK: - CSSiteArrivalTrackerDelegate
    
    func siteArrivalTracker(_ tracker: CSSiteArrivalTracker!, encounteredError error: Error!) {
        guard let error = error as NSError? else { return }
        print("Encountered Error: \(error.description)")
        let alertController = UIAlertController.init(title: "Error", message: error.description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

