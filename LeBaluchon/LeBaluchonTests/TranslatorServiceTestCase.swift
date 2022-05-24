//
//  TranslatorServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias on 23/05/2022.
//

import XCTest
@testable import LeBaluchon

class TranslatorServiceTestCase: XCTestCase {

    func test() {
        let session = URLSessionFake(data: FakeResponse.translationCorrectData, response: FakeResponse.responseOK, error: FakeResponse.anError)
        let translatorService = TranslateService(session: session)
        let mockDelegate = TranslatorMockDelegate()
        translatorService.viewDelegate = mockDelegate

//        print(mockDelegate.refreshEnglishTextFieldWithIsCalled)
        print(mockDelegate.toogleActivityIndicatorIsCalled, "toogle before")
        print(mockDelegate.warningMessageIsCalled, "warning message before")
        translatorService.doTranslation(textForTranslation: "texto")
//        print(mockDelegate.refreshEnglishTextFieldWithIsCalled)
        print(mockDelegate.toogleActivityIndicatorIsCalled)
        print(mockDelegate.warningMessageIsCalled, "warning message after")
    }
}
