//
//  WeatherServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 23/05/2022.
//

import XCTest
@testable import LeBaluchon

/**
 * WeatherServiceTestCase:
 *
 * Tests created for the Weather Service.
 */
class WeatherServiceTestCase: XCTestCase {

    var mockDelegate: WeatherMockDelegate?

    override func setUp() {
        mockDelegate = WeatherMockDelegate()
    }

    func testGivenErrorInResponse_WhenUpdateWeatherInformation_ThenWarningMessageIsCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: FakeResponse.anError)
        let weatherService = WeatherService(session)
        weatherService.viewDelegate = mockDelegate

        // When
        weatherService.updateWeatherInformation()
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssert(mockDelegate.warningMessageIsCalled)
    }

    func testGivenWrongDataInResponse_WhenUpdateWeatherInformation_ThenWarningMessageIsCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.incorretData, response: FakeResponse.responseOK, error: nil)
        let weatherService = WeatherService(session)
        weatherService.viewDelegate = mockDelegate
        // When
        weatherService.updateWeatherInformation()
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        //
        XCTAssert(mockDelegate.warningMessageIsCalled)
    }

    func testGivenCorrectResponse_WhenUpdateWeatherInformation_ThenRefreshTextsFieldShouldBeCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.WeatherCorrectData, response: FakeResponse.responseOK, error: nil)
        let weatherService = WeatherService(session)
        weatherService.viewDelegate = mockDelegate
        // When
        weatherService.updateWeatherInformation()
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssert(mockDelegate.refreshNewYorkTextFieldWithIsCalled)
    }

    func testGivenCorrectResponse_WhenUpdateWeatherInformation_ThenlGetTheExpectedInformation() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.WeatherCorrectData, response: FakeResponse.responseOK, error: nil)
        let weatherServive = WeatherService(session)
        weatherServive.viewDelegate = mockDelegate
        let informationExpected =
        """
        SCATTERED CLOUDS
        16.08 °C min - 26.31 °C max
        7.72 Km/h
        74.0 % Humidity
        """
        // When
        weatherServive.updateWeatherInformation()
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssertEqual(informationExpected, weatherServive.brevalWeatherInformation)
        XCTAssertEqual(informationExpected, weatherServive.newyorkWeatherInformation)
    }

    func testGivenWrongStatusCodeInResponse_WhenUpdateWeatherInformation_ThenWarningMessageIsCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.WeatherCorrectData, response: FakeResponse.responseFail, error: nil)
        let serviceWeather = WeatherService(session)
        serviceWeather.viewDelegate = mockDelegate
        // When
        serviceWeather.updateWeatherInformation()
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssert(mockDelegate.warningMessageIsCalled)
    }
}
