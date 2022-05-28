//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 23/04/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    let weather = WeatherService(URLSession.shared)

    override func viewDidLoad() {
        super.viewDidLoad()
        activityindicator.isHidden = true
        updateButton.round()
        weather.viewDelegate = self
        weather.updateWeatherInformation()
    }

    @IBOutlet weak var newYorkTextField: UITextView!
    @IBOutlet weak var brevalTextField: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!

    @IBAction func tappedUdateButton() {
        weather.updateWeatherInformation()
    }
}

// MARK: - Extension

extension WeatherViewController: WeatherDelegate {

    /**
     This function refreshes the New York Text Field  with a message.
     
     - parameter value: String with the message to be displayed.
     */
    func refreshNewYorkTextFieldWith(_ value: String) {
        newYorkTextField.text = value
    }

    /**
     This function refreshes the Breval Text Field  with a message.
     
     - parameter value: String with the message to be displayed.
     */
    func refreshBrevalTextFieldWith(_ value: String) {
        brevalTextField.text = value
    }

    /**
     This function displays an alert to the user.
     
     - parameter message: String with the message to be displayed in the alert.
     */
    func warningMessage(_ message: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }

     /**
      This function hides or displays the Update button and the activity indicator.
      
      - parameter shown: True to show or False to hide.
      */
     func toogleActivityIndicator(shown: Bool) {
        updateButton.isHidden = shown
        activityindicator.isHidden = !shown
    }
}
