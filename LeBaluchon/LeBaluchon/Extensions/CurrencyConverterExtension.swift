//
//  CurrencyConverterExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 10/05/2022.
//

import Foundation

extension CurrencyConverterService: CurrencyConverterDelegate {
    /**
     This function displays an alert to the user.
     
     - parameter message: String with the message to be displayed in the alert.
     */
    func warningMessage(_ message: String) {
        viewDelegate?.warningMessage(message)
    }

    /**
     This function refreshes the New York Text Field  with a message.
     
     - parameter value: String with the message to be displayed.
     */
    func refreshTextViewWithValue(_ value: String) {
        viewDelegate?.refreshTextViewWithValue(value)
    }

    /**
     This function hides or displays the Update button and the activity indicator.
     
     - parameter shown: True to show or False to hide.
     */
    func toogleActivityIndicator(shown: Bool) {
        viewDelegate?.toogleActivityIndicator(shown: shown)
    }
}
