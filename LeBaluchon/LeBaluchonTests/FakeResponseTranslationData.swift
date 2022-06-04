//
//  FakeResponseTranslationData.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias Aquino Cifuentes on 16/05/2022.
//

import Foundation

/**
 * FakeResponse
 *
 * This class contains the necessary information to be able to test the classes: Currency converter service, Translator service and Weather Service.
 */
class FakeResponse {
    static var emptyRequest: URLRequest?

    static var incorretData = "Error".data(using: .utf8)

    static var translationCorrectData: Data? {
        let bundle = Bundle(for: FakeResponse.self)
        guard let url = bundle.url(forResource: "Translation", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }

    static var WeatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponse.self)
        guard let url = bundle.url(forResource: "Weather", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }

    static var ExchangeRateCorrectData: Data? {
        let bundle = Bundle(for: FakeResponse.self)
        guard let url = bundle.url(forResource: "ExchangeRate", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }

    static var responseOK: HTTPURLResponse? {
        guard let url = URL(string: "www.openclassrooms.com") else {
            return nil
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        return response
    }

    static var responseFail: HTTPURLResponse? {
        guard let url = URL(string: "www.openclassrooms.com") else {
            return nil
        }
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        return response
    }

    class FakeResponseError: Error {}
    static var anError = FakeResponseError()

// MARK: EDITABLE
}
