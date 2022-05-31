//
//  CurrencyConverterMockDelegate.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 27/05/2022.
//

import Foundation
@testable import LeBaluchon

// Mock delegate  to test the CurrentConverterService class.
class CurrencyConverterMockDelegate: CurrencyConverterDelegate {

    var warningMessageIsCalled = false
    var refreshTextViewWithValueIsCalled = false
    var showActivityIndicator = false

    func warningMessage(_ message: String) {
        warningMessageIsCalled = true
    }

    func refreshTextViewWithValue(_ value: String) {
        refreshTextViewWithValueIsCalled = true
    }

    func showActivityIndicator(_ value: Bool) {
        showActivityIndicator = true
    }
}
