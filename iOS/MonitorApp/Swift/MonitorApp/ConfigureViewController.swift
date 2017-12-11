//
//  ConfigureViewController.swift
//  MonitorApp
//
//  Created by Hon Chen on 9/7/17.
//  Copyright © 2017 curbside. All rights reserved.
//

import UIKit

class ConfigureViewController: UIViewController {
    
    @IBOutlet var siteIdentifierTextField: UITextField!
    @IBOutlet var trackingIdentifierTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var startUpdatesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        startUpdatesButton.layer.cornerRadius = 4.0
        siteIdentifierTextField.delegate = self
        trackingIdentifierTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func startUpdates(_ sender: Any) {
        let trackingIdentifer = trackingIdentifierTextField.text ?? ""
        let siteIdentifier = siteIdentifierTextField.text ?? ""
        
        if trackingIdentifer.characters.count == 0 {
            errorLabel.text = "Please enter a valid tracking identifier."
            return
        }
        
        if siteIdentifier.characters.count == 0 {
            errorLabel.text = "Please enter a valid site identifier."
            return;
        }
        
        // We are good. Set defaults and exit.
        let userDefaults = UserDefaults.standard
        userDefaults.set(trackingIdentifer, forKey: kTrackingIdentifierKey)
        userDefaults.set(siteIdentifier, forKey: kSiteIdentifierKey)
        userDefaults.synchronize()
        
        dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension ConfigureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == trackingIdentifierTextField {
            siteIdentifierTextField.becomeFirstResponder()
        } else if textField == siteIdentifierTextField {
            dismissKeyboard()
            startUpdates(self)
        } else {
            dismissKeyboard()
        }
        return true
    }
}
