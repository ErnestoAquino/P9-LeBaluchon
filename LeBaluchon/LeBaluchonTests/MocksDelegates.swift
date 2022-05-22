//
//  MocksDelegates.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 22/05/2022.
//

import Foundation
@testable import LeBaluchon

// Mock delegate  to test the CurrentConverterService class.
class CurrencyConverterMockDelegate: CurrencyConverterDelegate {

    var warningMessageIsCalled = false
    var refreshTextViewWithValueIsCalled = false
    var toogledActivityIndicatorIsCalled = false

    func warningMessage(_ message: String) {
        warningMessageIsCalled = true
    }

    func refreshTextViewWithValue(_ value: String) {
        refreshTextViewWithValueIsCalled = true
    }

    func toogleActivityIndicator(shown: Bool) {
        toogledActivityIndicatorIsCalled = true
    }
}

// Mock delegate created to test the WeatherService class.
class WeatherMockDelegate: WeatherDelegate {
    var warningMessageIsCalled = false
    var refreshNewYorkTextFieldWithIsCalled = false
    var refreshBrevalTextFieldIsCalled = false
    var toogleActivityIndicatorIsCalled = false

    func warningMessage(_ message: String) {
        warningMessageIsCalled = true
    }

    func refreshNewYorkTextFieldWith(_ value: String) {
        refreshNewYorkTextFieldWithIsCalled = true
    }

    func refreshBrevalTextFieldWith(_ value: String) {
        refreshNewYorkTextFieldWithIsCalled = true
    }

    func toogleActivityIndicator(shown: Bool) {
        toogleActivityIndicatorIsCalled = true
    }
}

// Mock delegate created to test the TranslationService class.
class TranslatorMockDelegate: TranslatorDelegate {
    var warningMessageIsCalled = false
    var refreshEnglishTextFieldWithIsCalled = false
    var toogleActivityIndicatorIsCalled = false

    func warningMessage(_ message: String) {
        warningMessageIsCalled = true
    }

    func refreshEnglishTextFieldWith(_ translatedTex: String) {
        refreshEnglishTextFieldWithIsCalled = true
    }

    func toogleActivityIndicator(shown: Bool) {
        toogleActivityIndicatorIsCalled = true
    }
}
