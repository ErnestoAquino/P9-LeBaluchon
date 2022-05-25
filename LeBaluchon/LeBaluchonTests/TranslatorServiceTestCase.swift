//
//  TranslatorServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 23/05/2022.
//

import XCTest
@testable import LeBaluchon

class TranslatorServiceTestCase: XCTestCase {

    var mockDelegate: TranslatorMockDelegate?

    override func setUp() {
        mockDelegate = TranslatorMockDelegate()
    }

    func testGivenAnotValidString_WhenDoTranslation_ThenSuccessShouldBeFalse() {
        guard let mockDelegate = mockDelegate else {
            return
        }
        let expectation = expectation(description: "Wait for queue change.")
        let session = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: nil)
        let translatorService = TranslateService(session)
        translatorService.viewDelegate = mockDelegate
        // Given
        let stringNil: String? = nil
        // When
        translatorService.doTranslation(textForTranslation: stringNil) { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenAnErrorInResponse_WhenDoTranslation_ThenSuccessShouldBeFalse() {
        guard let mockDelegate = mockDelegate else {
            return
        }
        let expectation = expectation(description: "Wait for queue change.")
        // Given
        let session = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: FakeResponse.anError)
        let translatorService = TranslateService(session)
        translatorService.viewDelegate = mockDelegate
        // When
        translatorService.doTranslation(textForTranslation: "Bonjour") { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWrongDataInResponse_WhenDoTranslation_ThenSuccessShouldBeFalse() {
        guard let mockDelegate = mockDelegate else {
            return
        }
        let expectation = expectation(description: "Wait for queue change.")
        // Given
        let session = URLSessionFake(data: FakeResponse.incorretData, response: FakeResponse.responseOK, error: nil)
        let translatorService = TranslateService(session)
        translatorService.viewDelegate = mockDelegate
        // When
        translatorService.doTranslation(textForTranslation: "Bonjour") { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenCorrectResponse_WhenDoTranslation_ThenSuccessShouldBeTrue() {
        guard let mockDelegate = mockDelegate else {
            return
        }
        let expectation = expectation(description: "Wait for queue change.")
        // Given
        let session = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: nil)
        let translatorService = TranslateService(session)
        translatorService.viewDelegate = mockDelegate
        // When
        translatorService.doTranslation(textForTranslation: "Bonjour") { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
