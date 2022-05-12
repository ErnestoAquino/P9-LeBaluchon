//
//  CurrencyConverterService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 25/04/2022.
//

import Foundation

final class CurrencyConverterService {

    weak var viewDelegate: CurrencyConverterDelegate?
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    private let urlBase = "http://data.fixer.io/api/latest"
    private let warningMessage = "We have un little problem, please check your internet connection."
    private let networkManager = NetworkManager<ExchangeRate>()
    private var exchangeRateLocal: ExchangeRate?
    public var currency: Currency = .USD
    enum Currency: String {
        case USD
        case MXN
        case JPY
        case GBP
    }

    public func doConversion(eurosToBeConverted: String?) {
        guard stringWithEurosIsValid(eurosToBeConverted) else {
            warningMessage("Please enter a valid amount (greater than 0 and less than 1 000 000).")
            return
        }
        guard exchangeRateLocal == nil else {
            guard let exchangeRateLocal = exchangeRateLocal else { return }
            let result = calculateConversion(euros: eurosToBeConverted, exchangeData: exchangeRateLocal)
            refreshTextViewWithValue(result)
            print("Exchange information local")
            return
        }
        guard let request = createRequest() else {return}
        networkManager.getInformation(request: request) { exchangeRate, error in
            guard error == nil,
                  let exchageInformation = exchangeRate else {
                self.warningMessage("We have un little problem, please check your internet connection.")
                return
            }
            self.exchangeRateLocal = exchageInformation
            let result = self.calculateConversion(euros: eurosToBeConverted, exchangeData: exchageInformation)
            self.refreshTextViewWithValue(result)
            print("Exchange request informatio")
        }
    }

    private func calculateConversion(euros: String?, exchangeData: ExchangeRate) -> String {
        var conversionResult = -0.0

        guard let euros = euros,
              let eurosHowDouble = Double(euros),
              let value = exchangeData.rates?[currency.rawValue] else {
            return String(conversionResult)
        }
        conversionResult = eurosHowDouble * value
        return String(conversionResult)
    }

    private func stringWithEurosIsValid(_ value: String?) -> Bool {
        guard let value = value,
              let valueHowDouble = Double(value),
              valueHowDouble > 0,
              valueHowDouble < 1000000 else {return false}
        return true
    }

    private func createRequest() -> URLRequest? {
        guard let key = apiKey else {return nil}
        let urlWithKey = "\(urlBase)?access_key=\(key)&base=EUR&symbols=USD,MXN,JPY,GBP"
        guard let urlExchangeRate = URL(string: urlWithKey) else {return nil}
        var request = URLRequest(url: urlExchangeRate)
        request.httpMethod = "GET"

        return request
    }
}
