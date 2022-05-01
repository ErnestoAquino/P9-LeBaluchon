//
//  CurrencyConverterViewController.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 23/04/2022.
//

import UIKit

class CurrencyConverterViewController: UIViewController, CurrencyConverterDelegate {

    let currencyConverter = CurrencyConverterService()

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
        case 1:
            currencyConverter.currency = .MXN
        case 2:
            currencyConverter.currency = .JPY
        case 3:
            currencyConverter.currency = .GBP
        default: break
        }

    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        euroTextField.resignFirstResponder()
    }

    @IBAction func tappedConvertButton() {
        buttonConvert.isHidden = true
        activityIndicator.isHidden = false
        currencyConverter.doConversion(value: euroTextField.text)
        buttonConvert.isHidden = false
        activityIndicator.isHidden = false
    }

    func warningMessage(_ message: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }

    func refreshTextViewWithValue(_ value: String) {
        resultTextField.text = value
    }
}
