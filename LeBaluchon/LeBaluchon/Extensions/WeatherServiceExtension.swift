//
//  WeatherServiceExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 09/05/2022.
//

import Foundation

extension WeatherService: WeatherDelegate {
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
    func refreshNewYorkTextFieldWith(_ value: String) {
        viewDelegate?.refreshNewYorkTextFieldWith(value)
    }

    /**
     This function refreshes the Breval Text Field  with a message.
     
     - parameter value: String with message to be displayed.
     */
    func refreshBrevalTextFieldWith(_ value: String) {
        viewDelegate?.refreshBrevalTextFieldWith(value)
    }

    /**
     This function hides or displays the Update button and the activity indicator.
     
     - parameter value: True to show or False to hide.
     */
    func showActivityIndicator(_ value: Bool) {
        viewDelegate?.showActivityIndicator(value)
    }
}
