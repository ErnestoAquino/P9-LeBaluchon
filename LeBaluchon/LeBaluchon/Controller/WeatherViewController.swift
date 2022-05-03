//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 23/04/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    let weather = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityindicator.isHidden = true
        updateButton.round()
        weather.viewDelegate = self
    }

    @IBOutlet weak var newYorkTextField: UITextView!
    @IBOutlet weak var brevalTextField: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!

    @IBAction func tappedUdateButton() {
    }

}

extension WeatherViewController: WeatherProtocol {
    func refreshNewYorkTextFieldWith(_ value: String) {
        newYorkTextField.text = value
    }

    func refreshBrevalTextFieldWith(_ value: String) {

    }
    func warningMessage(_ message: String) {
    }
}
