//
//  TranslatorMockDelegate.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 27/05/2022.
//

import Foundation
@testable import LeBaluchon

// Mock delegate created to test the TranslationService class.
class TranslatorMockDelegate: TranslatorDelegate {

    var warningMessageIsCalled = false
    var refreshEnglishTextFieldWithIsCalled = false
    var showActivityIndicator = false

    func warningMessage(_ message: String) {
        warningMessageIsCalled = true
    }

    func refreshEnglishTextFieldWith(_ translatedTex: String) {
        refreshEnglishTextFieldWithIsCalled = true
    }

    func showActivityIndicator(_ value: Bool) {
        showActivityIndicator = true
    }
}
