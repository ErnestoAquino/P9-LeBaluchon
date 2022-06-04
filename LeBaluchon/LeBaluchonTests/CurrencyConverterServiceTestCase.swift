//
//  CurrencyConverterServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias Aquino Cifuentes on 25/05/2022.
//

import XCTest
@testable import LeBaluchon

/**
 * CurrencyConverterServiceTestCase:
 *
 * Tests created for the Currency Converter Service
 */
class CurrencyConverterServiceTestCase: XCTestCase {
    var mockDelegate: CurrencyConverterMockDelegate?

    override func setUp() {
        mockDelegate = CurrencyConverterMockDelegate()
    }

    func testGivenANotValidAmount_WhenDoConversion_ThenWarningMessageShoulBeCalled() {
        guard let mockDelegate = mockDelegate else { return }
        let session = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session)
        currencyService.viewDelegate = mockDelegate

        // Given
        let stringNoValide: String? = nil
        // When
        currencyService.doConversion(eurosToBeConverted: stringNoValide)
        // Then
        XCTAssert(mockDelegate.warningMessageIsCalled)
    }

    func testGivenErrorInResponse_WhenDoConversion_ThenWarningMessageShouldBeCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseOK, error: FakeResponse.anError)
        let currencyService = CurrencyConverterService(session)
        currencyService.viewDelegate = mockDelegate
        let stringValide = "10"
        // When
        currencyService.doConversion(eurosToBeConverted: stringValide)
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssert(mockDelegate.warningMessageIsCalled)
    }

    func testGivenWrongStatusCodeInResponse_WhenDoConversion_ThenWarningMessageShouldBeCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseFail, error: nil)
        let currencyService = CurrencyConverterService(session)
        currencyService.viewDelegate = mockDelegate
        let stringValide = "10"
        // When
        currencyService.doConversion(eurosToBeConverted: stringValide)
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssert(mockDelegate.warningMessageIsCalled)
    }

    func testGivenWrongDataInResponse_WhenDoConversion_ThenWarningMessageShouldBeCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.incorretData, response: FakeResponse.responseFail, error: nil)
        let currencyService = CurrencyConverterService(session)
        currencyService.viewDelegate = mockDelegate
        let stringValide = "10"
        // When
        currencyService.doConversion(eurosToBeConverted: stringValide)
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssert(mockDelegate.warningMessageIsCalled)
    }

    func testGivenCorrectResponseAndAmount_WhenDoConversion_ThenShouldGetTheExpectedResult() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        let session = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session)
        currencyService.viewDelegate = mockDelegate
        // Given
        let expectedResult = "10.4346"
        // When
        currencyService.doConversion(eurosToBeConverted: "10")
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssertEqual(expectedResult, currencyService.checkResult)
    }

    func testGivenCurrencyChanged_WhenDoConversion_ThenShouldGetTheExpectedResult() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        let session = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session)
        currencyService.viewDelegate = mockDelegate
        // Given
        currencyService.currency = .USD
        let expectedMxn = "62.749764"
        // When
        currencyService.doConversion(eurosToBeConverted: "10")
        currencyService.currency = .MXN
        currencyService.doConversion(eurosToBeConverted: "3")
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssertEqual(expectedMxn, currencyService.checkResult)
    }

    func testGivenExpiredCurrencyExchangeInformation_WhenDoConversionCalledTwoTimes_ThenExchangeInformationIsExpired() async {
        // Given
        let session = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session)
        let expectation = expectation(description: "Wait to the function to terminate")
        // When
        currencyService.doConversion(eurosToBeConverted: "20")
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
        currencyService.doConversion(eurosToBeConverted: "10")
        // Thne
        XCTAssertTrue(currencyService.exchangeInformationIsExpired)
    }

    func testGivenRecentCurrencyExchangeInformation_WhenDoConversionIsCalledTwoTimes_ThenExchangeInformationIsNotExpired() async {
        let json =
        """
{
    "success": true,
    "timestamp": 1654621371,
    "base": "EUR",
    "date": "2022-05-16",
    "rates": {
        "USD": 1.04346,
        "MXN": 20.916588,
        "JPY": 134.880284,
        "GBP": 0.847446
    }
}
"""
        // Given
        let jsonData = json.data(using: .utf8)
        let session = URLSessionFake(data: jsonData, response: FakeResponse.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session)
        let expectation = expectation(description: "Wait for the function to terminate")
        // When
        currencyService.doConversion(eurosToBeConverted: "10")
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
        currencyService.doConversion(eurosToBeConverted: "15")
        // Then
        XCTAssertFalse(currencyService.exchangeInformationIsExpired)
    }
}
