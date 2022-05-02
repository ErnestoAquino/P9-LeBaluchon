//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 23/04/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        activityindicator.isHidden = true
        updateButton.round()
    }

    @IBOutlet weak var newYorkTextField: UITextView!
    @IBOutlet weak var brevalTextField: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!

    @IBAction func tappedUdateButton() {
    }

}
