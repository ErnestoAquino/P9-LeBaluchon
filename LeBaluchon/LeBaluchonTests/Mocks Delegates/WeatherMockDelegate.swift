//
//  WeatherMockDelegate.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 27/05/2022.
//

import Foundation
@testable import LeBaluchon

// Mock delegate created to test the WeatherService class.
class WeatherMockDelegate: WeatherDelegate {
    var warningMessageIsCalled = false
    var refreshNewYorkTextFieldWithIsCalled = false
    var refreshBrevalTextFieldIsCalled = false
    var showActivityIndicator = false

    func warningMessage(_ message: String) {
        warningMessageIsCalled = true
    }

    func refreshNewYorkTextFieldWith(_ value: String) {
        refreshNewYorkTextFieldWithIsCalled = true
    }

    func refreshBrevalTextFieldWith(_ value: String) {
        refreshNewYorkTextFieldWithIsCalled = true
    }

    func showActivityIndicator(_ value: Bool) {
        showActivityIndicator = true
    }
}
