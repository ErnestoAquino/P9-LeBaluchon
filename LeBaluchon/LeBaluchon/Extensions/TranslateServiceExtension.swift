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
        guard let viewDelegate = viewDelegate else {
            return
        }
        viewDelegate.warningMessage(message)
    }

    /**
     This function displays a message in the English Text Field
     
     - parameter translatedTex: String with the message to be displayed.
     */
    func refreshEnglishTextFieldWith(_ translatedTex: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.refreshEnglishTextFieldWith(translatedTex)
    }

    /**
     This function hides or displays the Translate button and the activity indicator.
     
     - parameter shown: True to show or False to hide.
     */
    func toogleActivityIndicator(shown: Bool) {
        guard let viewDelegare = viewDelegate else { return }
        viewDelegare.toogleActivityIndicator(shown: shown)
    }
}
