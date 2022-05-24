//
//  CurrencyConverterServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 22/05/2022.
//

import XCTest
@testable import LeBaluchon

class CurrencyConverterServiceTestCase: XCTestCase {

    var mockDelegate: CurrencyConverterMockDelegate!
    var currencyConverter: CurrencyConverterService!

    override func setUp() {
        currencyConverter = CurrencyConverterService()
        mockDelegate = CurrencyConverterMockDelegate()
        currencyConverter?.viewDelegate = mockDelegate
    }

    func testGivenCurrencyIsUsd_WhenIselectMnx_ThenCurencyIsMnx() {
        let currencyConverterService =  CurrencyConverterService()
        // Given
        currencyConverterService.currency = .USD
        // When
        currencyConverterService.currency = .MXN
        // Then
        XCTAssertTrue(currencyConverterService.currency == .MXN)
    }

    func testGivenAnInvaidAmount_WhenLaunchDoConversion_ThenWarningMessageIsCalled() {
        // Given
        let wrongAmount = "I am a wrong amout"
        // When
        currencyConverter.doConversion(eurosToBeConverted: wrongAmount)
        // Then
        XCTAssertTrue(mockDelegate.warningMessageIsCalled)
    }
}
