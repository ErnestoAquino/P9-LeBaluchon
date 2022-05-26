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

    func testGivenAnotValidString_WhenDoTranslation_ThenWarningMessageShouldBeCalled() {
        guard let mockDelegate = mockDelegate else { return }

        let session = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: nil)
        let translatorService = TranslateService(session)
        translatorService.viewDelegate = mockDelegate
        // Given
        let stringNil: String? = nil
        // When
        translatorService.doTranslation(textToTranslate: stringNil)
            // Then
        XCTAssertTrue(mockDelegate.warningMessageIsCalled)
    }

    func testGivenAvalidString_WhenDoTranslation_ThenRefreshEnglishTextFieldShouldBeCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        let session = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: nil)
        let translatorService = TranslateService(session)
        translatorService.viewDelegate = mockDelegate
        // Given
        let validString = "Bonjour"
        // When
        translatorService.doTranslation(textToTranslate: validString)
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssert(mockDelegate.refreshEnglishTextFieldWithIsCalled)
    }

    func testGivenCorrectResponse_WhenDoTranslation_ThenShouldGetTheExpectedTranslation() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: nil)
        let translatorService = TranslateService(session)
        translatorService.viewDelegate = mockDelegate

        let expectedTranslation = "Hello, this is a test message for tests."
        // When
        translatorService.doTranslation(textToTranslate: "Bonjour, ceci est un message de test pour les tests.")
        exp.fulfill()
        await waitForExpectations(timeout: 1)
        // Then
        XCTAssertEqual(expectedTranslation, translatorService.translatedTex)
    }

    func testGivenWrongDataInResponse_WhenDoTranslation_ThenWarningMessageShoulBeCalled() async {
        guard let mockDelegate = mockDelegate else { return }
        let exp = expectation(description: "Wait to the function to terminate")
        // Given
        let session = URLSessionFake(data: FakeResponse.incorretData, response: FakeResponse.responseOK, error: nil)
        let translatorService = TranslateService(session)
        translatorService.viewDelegate = mockDelegate
        // When
        translatorService.doTranslation(textToTranslate: "Valide String")
        exp.fulfill()
        await waitForExpectations(timeout: 1)
            // Then
        XCTAssertTrue(mockDelegate.warningMessageIsCalled)
    }

}
