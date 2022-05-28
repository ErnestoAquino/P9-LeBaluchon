//
//  CurrencyConverterViewController.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 23/04/2022.
//

import UIKit

class CurrencyConverterViewController: UIViewController {

    let currencyConverter = CurrencyConverterService(URLSession.shared)

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        buttonConvert.round()
        currencyConverter.viewDelegate = self
    }

    @IBOutlet weak var euroTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonConvert: UIButton!

    @IBAction func currencySelector() {
        switch currencySegmentedControl.selectedSegmentIndex {
        case 0:
            currencyConverter.currency = .USD
            resultTextField.placeholder = "U.S. Dollar"
        case 1:
            currencyConverter.currency = .MXN
            resultTextField.placeholder = "Mexican peso"
        case 2:
            currencyConverter.currency = .JPY
            resultTextField.placeholder = "Japanese yen"
        case 3:
            currencyConverter.currency = .GBP
            resultTextField.placeholder = "British pound"
        default: break
        }

    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        euroTextField.resignFirstResponder()
    }

    @IBAction func tappedConvertButton() {
        currencyConverter.doConversion(eurosToBeConverted: euroTextField.text)
    }

}

// MARK: - Extansion

extension CurrencyConverterViewController: CurrencyConverterDelegate {
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
     This function refreshes the resultTextField  with a message.
     
     - parameter value: String with the message to be displayed.
     */
    func refreshTextViewWithValue(_ value: String) {
        resultTextField.text = value
    }

     /**
      This function hides or displays the Convert button and the activity indicator.
      
      - parameter shown: True to show or False to hide.
      */
     func toogleActivityIndicator(shown: Bool) {
        buttonConvert.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}
