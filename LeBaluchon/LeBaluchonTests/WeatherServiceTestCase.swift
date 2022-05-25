//
//  WeatherServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 23/05/2022.
//

import XCTest
@testable import LeBaluchon

class WeatherServiceTestCase: XCTestCase {

    func testGivenCorrectResponse_WhenUpdateWeatherInformation_ThenSuccessShoulBeTrue() {
        let expectations = expectation(description: "Wait for queue change.")
        // Given
        let delegate = WeatherMockDelegate()
        let session = URLSessionFake(data: FakeResponse.WeatherCorrectData, response: FakeResponse.responseOK, error: nil)
        let service = WeatherService(session)
        service.viewDelegate = delegate
        // When
        service.updateWeatherInformation { succes in
            // Then
            XCTAssertTrue(succes)
            expectations.fulfill()
        }
        wait(for: [expectations], timeout: 0.01)
    }

    func testGivenErrorIntResponse_WhenUpdateWeatherInformation_ThenSuccessShoulBeFalse() {
        let expectations = expectation(description: "Wait for queue change.")
        // Given
        let delegate = WeatherMockDelegate()
        let session = URLSessionFake(data: FakeResponse.WeatherCorrectData, response: FakeResponse.responseOK, error: FakeResponse.anError)
        let service = WeatherService(session)
        service.viewDelegate = delegate
        // When
        service.updateWeatherInformation { succes in
            // Then
            XCTAssertFalse(succes)
            expectations.fulfill()
        }
        wait(for: [expectations], timeout: 0.01)
    }
}
