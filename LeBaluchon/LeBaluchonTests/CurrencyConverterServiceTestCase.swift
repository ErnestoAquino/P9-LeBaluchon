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
    var testFakeSession = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseOK, error: nil)
    var testCurrencyService: CurrencyConverterService?
    override func setUp() {
        mockDelegate = CurrencyConverterMockDelegate()
        testCurrencyService = CurrencyConverterService(testFakeSession)
    }
// MARK: - STAR TEST

    func testUno() async {
        guard let mockDelegate = mockDelegate else { return }
        let session = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session)
        currencyService.viewDelegate = mockDelegate
        let expectation = expectation(description: "Wait to the function to terminate")
        let expectedResult = "20.8692"
        currencyService.doConversion(eurosToBeConverted: "20")

        expectation.fulfill()
        await waitForExpectations(timeout: 1)
        currencyService.doConversion(eurosToBeConverted: "10")

        XCTAssertEqual(expectedResult, currencyService.checkResult)
    }

    func testDos() async {
        let json =
        """
{
    "success": true,
    "timestamp": 1654357838,
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
        let jsonData = json.data(using: .utf8)
        guard let mockDelegate = mockDelegate else { return }
        let session = URLSessionFake(data: jsonData, response: FakeResponse.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session)
        currencyService.viewDelegate = mockDelegate
        let expectation = expectation(description: "Wait for the function to terminate")
    
        currencyService.doConversion(eurosToBeConverted: "10")
        expectation.fulfill()
        await waitForExpectations(timeout: 1)
        currencyService.doConversion(eurosToBeConverted: "15")
        print (currencyService.checkResult)

    }
// MARK: - END TEST

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
}
