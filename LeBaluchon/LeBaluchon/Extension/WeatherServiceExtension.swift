//
//  WeatherServiceExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 09/05/2022.
//

import Foundation

extension WeatherService: WeatherDelegate {
    func warningMessage(_ message: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.warningMessage(message)
    }

    func refreshNewYorkTextFieldWith(_ value: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.refreshNewYorkTextFieldWith(value)
    }

    func refreshBrevalTextFieldWith(_ value: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.refreshBrevalTextFieldWith(value)
    }
}
