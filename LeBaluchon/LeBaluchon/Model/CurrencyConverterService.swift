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

    /* This function performs the operation requested by the controller.
     It first verifies that what the user has entered is valid.
     Second it verifies that there is no local structure with the necessary data to perform the calculation.
     If there is already data stored in the exchangeRateLocal variable, it will use this data and will not make another call.
     Third, if there is no information stored in the variable, it will create a URL Request to use the getInformation method of the networManager class.
     */
    public func doConversion(eurosToBeConverted: String?) {
        guard stringWithEurosIsValid(eurosToBeConverted) else {
            warningMessage("Please enter a valid amount (greater than 0 and less than 1 000 000).")
            return
        }
        guard exchangeRateLocal == nil else {
            guard let exchangeRateLocal = exchangeRateLocal else { return }
            let result = calculateConversion(euros: eurosToBeConverted, exchangeData: exchangeRateLocal)
            refreshTextViewWithValue(result)
            return
        }
        guard let request = createRequest() else {
            warningMessage("We have un little problem, please check your internet connection.")
            return
        }
        toogleActivityIndicator(shown: true)
        networkManager.getInformation(request: request) { exchangeRate, error in
            self.toogleActivityIndicator(shown: false)
            guard error == nil,
                  let exchageInformation = exchangeRate else {
                self.warningMessage("We have un little problem, please check your internet connection.")
                return
            }
            self.exchangeRateLocal = exchageInformation
            let result = self.calculateConversion(euros: eurosToBeConverted, exchangeData: exchageInformation)
            self.refreshTextViewWithValue(result)
        }
    }

    // This function performs the conversion calculation.
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

    // This function verifies the amount entered by the user is valid.
    private func stringWithEurosIsValid(_ value: String?) -> Bool {
        guard let value = value,
              let valueHowDouble = Double(value),
              valueHowDouble > 0,
              valueHowDouble < 1000000 else {return false}
        return true
    }

    // This function create a URL Request for URL Session.
    private func createRequest() -> URLRequest? {
        guard let key = apiKey else {return nil}
        let urlWithKey = "\(urlBase)?access_key=\(key)&base=EUR&symbols=USD,MXN,JPY,GBP"
        guard let urlExchangeRate = URL(string: urlWithKey) else {return nil}
        var request = URLRequest(url: urlExchangeRate)
        request.httpMethod = "GET"

        return request
    }
}
