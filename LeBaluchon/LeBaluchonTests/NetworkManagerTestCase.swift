//
//  NetworkManagerTestCase.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias Aquino Cifuentes on 15/05/2022.
//

import XCTest
@testable import LeBaluchon

class NetworkManagerTestCase: XCTestCase {

    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        expectation = XCTestExpectation(description: "Wait for queue change.")
    }

    // Creation of request for tests.
    func createRequestForTest() -> URLRequest? {
        guard let urlTranslation = URL(string: "https://urlForTests.com/") else {
            return nil
        }
        var request = URLRequest(url: urlTranslation)
        request.httpMethod = "POST"
        let body = "iAmABodyForTests"
        request.httpBody = body.data(using: .utf8)
        return request
    }

    // MARK: - Tests

    func testGivenErrorInResponse_WhenLaunchGetInformation_ThenShouldHaveAnError() {
        // Given
        let sessionFake = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: FakeResponse.anError)
        let fakeNetworkManager = NetworkManager<TranslationResponse>(networkManagerSession: sessionFake)
        let request = createRequestForTest()
        // When
        fakeNetworkManager.getInformation(request: request) { translation, error in
        // Then
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenEmptyRequest_WhenLaunchGetInformation_ThenCompletionHandlerShouldBeNilAndNil() {
        // Given
        let sessionFake = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: nil)
        let fakeNetworkManager = NetworkManager<TranslationResponse>(networkManagerSession: sessionFake)

        // When
        fakeNetworkManager.getInformation(request: FakeResponse.emptyRequest) { translation, error in
            // Then
            XCTAssertNil(translation)
            XCTAssertNil(error)
        }
    }

    func testGivenNoDataInResponse_WhenLaunchGetInformation_ThenComplationHandlerShouldBeNilAndNil() {
        // Given
        let sessionFake = URLSessionFake(data: nil, response: FakeResponse.responseOK, error: nil)
        let fakeNetworkManager = NetworkManager<TranslationResponse>(networkManagerSession: sessionFake)
        let request = createRequestForTest()
        // When
        fakeNetworkManager.getInformation(request: request) { tranalation, error in
            // Then
            XCTAssertNil(tranalation)
            XCTAssertNil(error)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWrongStatusCode_WhenGetInformation_ThenCompletionHandlerShouldBeNil() {
        // Given
        let sessionFake = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseFail, error: nil)
        let fakeNetworkManager = NetworkManager<TranslationResponse>(networkManagerSession: sessionFake)
        let request = createRequestForTest()
        // When
        fakeNetworkManager.getInformation(request: request) { translation, error in
            // Then
            XCTAssertNil(translation)
            XCTAssertNil(error)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenIncorretDataReceived_WhenGetInformation_ThenCompletionHandlerShouldBeNilAsdNil() {
        // Given
        let sessionFake = URLSessionFake(data: FakeResponse.incorretData, response: FakeResponse.responseOK, error: nil)
        let fakeNetworkManager = NetworkManager<TranslationResponse>(networkManagerSession: sessionFake)
        let request = createRequestForTest()
        // When
        fakeNetworkManager.getInformation(request: request) { translation, error in
            // Then
            XCTAssertNil(translation)
            XCTAssertNil(error)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenCorrectResponseTranslation_WhenGetInformation_ThenShouldHaveCorrectTextTranslated() {
        // Given
        let sessionFake = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: nil)
        let fakeNetworkManager = NetworkManager<TranslationResponse>(networkManagerSession: sessionFake)
        let request = createRequestForTest()
        // When
        fakeNetworkManager.getInformation(request: request) { translation, error in
            // Then
            let textTranslated = "Hello, this is a test message for tests."

            XCTAssertNotNil(translation)
            XCTAssertNil(error)
            XCTAssertEqual(textTranslated, translation!.data!.translations![0].translatedText!)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenCorrectResponseWeather_WhenGetInformation_ThenShouldHaveCorrectInformation() {
        // Given
        let sessionFake = URLSessionFake(data: FakeResponse.WeatherCorrectData, response: FakeResponse.responseOK, error: nil)
        let fakeNetWorkManager = NetworkManager<WeatherData>(networkManagerSession: sessionFake)
        let request = createRequestForTest()
        // When
        fakeNetWorkManager.getInformation(request: request) { weather, error in
            // Then
            let description = "scattered clouds"

            XCTAssertNotNil(weather)
            XCTAssertNil(error)
            XCTAssertEqual(description, weather!.weather![0].description!)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenCorrectResponseExchangeRate_WhenGetInformation_ThenShouldHaveCorrectInformation() {
        // Given
        let sessionFake = URLSessionFake(data: FakeResponse.ExchangeRateCorrectData, response: FakeResponse.responseOK, error: nil)
        let fakeNetworkManager = NetworkManager<ExchangeRate>(networkManagerSession: sessionFake)
        let request = createRequestForTest()
        // When
        fakeNetworkManager.getInformation(request: request) { exchangeRate, error in
            // Then
            let USD = 1.04346
            let MXN = 20.916588
            let JPY = 134.880284
            let GBP = 0.847446

            XCTAssertNotNil(exchangeRate)
            XCTAssertNil(error)
            XCTAssertEqual(USD, exchangeRate!.rates!["USD"]!)
            XCTAssertEqual(MXN, exchangeRate!.rates!["MXN"]!)
            XCTAssertEqual(JPY, exchangeRate!.rates!["JPY"]!)
            XCTAssertEqual(GBP, exchangeRate!.rates!["GBP"]!)

            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
