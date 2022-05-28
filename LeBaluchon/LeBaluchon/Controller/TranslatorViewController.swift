//
//  TranslatorViewController.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 23/04/2022.
//

import UIKit

class TranslatorViewController: UIViewController {
    let translatorService = TranslateService(URLSession.shared)

    override func viewDidLoad() {
        super.viewDidLoad()
        translateButton.round()
        activityIndicator.isHidden = true
        translatorService.viewDelegate = self
    }

    @IBOutlet weak var frenchTexField: UITextView!
    @IBOutlet weak var englishTextField: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var translateButton: UIButton!

    @IBAction func dismissKeyBoard(_ sender: UITapGestureRecognizer) {
        frenchTexField.resignFirstResponder()
    }

    @IBAction func tappedTranslateButton() {
        translatorService.doTranslation(textToTranslate: frenchTexField.text)
    }
}

// MARK: - Extension
extension TranslatorViewController: TranslatorDelegate {
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
     This function refreshes the English Text Field  with a message.
     
     - parameter translatedTex: String with the message to be displayed.
     */
    func refreshEnglishTextFieldWith(_ translatedTex: String) {
        englishTextField.text = translatedTex
    }

     /**
      This function hides or displays the Update button and the activity indicator.
      
      - parameter shown: True to show or False to hide.
      */
     func toogleActivityIndicator(shown: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}
