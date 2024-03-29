//
//  TranslateServiceExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 09/05/2022.
//

import Foundation

extension TranslateService: TranslatorDelegate {
    /**
     This function displays an alert to the user.
     
     - parameter message: String with the message to be displayed in the alert.
     */
    func warningMessage(_ message: String) {
        viewDelegate?.warningMessage(message)
    }

    /**
     This function displays a message in the English Text Field
     
     - parameter translatedTex: String with the message to be displayed.
     */
    func refreshEnglishTextFieldWith(_ translatedTex: String) {
        viewDelegate?.refreshEnglishTextFieldWith(translatedTex)
    }

    /**
     This function hides or displays the Translate button and the activity indicator.
     
     - parameter value: True to show or False to hide.
     */
    func showActivityIndicator(_ value: Bool) {
        viewDelegate?.showActivityIndicator(value)
    }
}
