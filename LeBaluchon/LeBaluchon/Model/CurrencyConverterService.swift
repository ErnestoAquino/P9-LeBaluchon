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
    private let message = "We have un little problem, please check your internet connection."
    private (set) var exchangeRateLocal: ExchangeRate?
    private (set) var checkResult = ""
    private (set) var exchangeInformationIsExpired = false
    private var euros = 0.0
    public var currency: Currency = .USD
    private let session: URLSessionProtocol

    enum Currency: String {
        case USD
        case MXN
        case JPY
        case GBP
    }

    init(_ session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    /**
     This function performs the conversion.
     It indicates the result to the controller using the method refreshTextView.
     
     - parameter eurosToBeConverted: Optional string with the euros to be converted.
     */
    public func doConversion(eurosToBeConverted: String?) {
        guard stringWithEurosIsValid(eurosToBeConverted) else {
            warningMessage("Please enter a valid amount (greater than 0 and less than 1 000 000).")
            return
        }
        guard exchangeRateLocal != nil else {
            obtainExchangeRate()
            return
        }
        guard !exchageRateHasExpired() else {
            obtainExchangeRate()
            return
        }
        let result = calculateCoversion()
        checkResult = result
        refreshTextViewWithValue(result)
    }

    /**
     This function retrieves the current exchange rate information from the FIXER API and stores it in the variable "exchangeRateLocal ".
     */
    private func obtainExchangeRate() {
        let networkManager = NetworkManager<ExchangeRate>(networkManagerSession: session)
        let request = createRequest()
        showActivityIndicator(true)
        networkManager.getInformation(request: request) { exchangeRate, error in
            self.showActivityIndicator(false)
            guard error == nil,
                  let exchangeRate = exchangeRate else {
                self.warningMessage(self.message)
                return
            }
            self.exchangeRateLocal = exchangeRate
            let result = self.calculateCoversion()
            self.checkResult = result
            self.refreshTextViewWithValue(result)
        }
    }

    /**
     This function makes the conversion using the variable "euros" and the value of the currency selected in "currency".
     
     - returns: Returns the result of the conversion as a string
     */
    func calculateCoversion() -> String {
        guard let value = exchangeRateLocal?.rates?[currency.rawValue] else {
            return "please try again"
        }
        let result = euros * value
        return String(result)
    }
    /**
     This function receives an optional string as a parameter and checks if it can be converted to a double type.
     
     - parameter value: The optional string to be verified.
     
     - returns: If value can be converted to double and if it is between 1 - 999 999 returns true.
     */
    private func stringWithEurosIsValid(_ value: String?) -> Bool {
        guard let value = value,
              let valueHowDouble = Double(value),
              valueHowDouble > 0,
              valueHowDouble < 1000000 else {return false}
        euros = valueHowDouble
        return true
    }

    /**
     This function checks if the currency exchange rate information is expired. The information is expired if more than 24 hours have passed since it was obtained.
     
     - returns: A Bolean. True if the information has expired or false otherwise.
     */
    private func exchageRateHasExpired() -> Bool {
        let aDayInSeconds = -86400.0
        guard let dateOfExchangeInformation = exchangeRateLocal?.timestamp?.timeIntervalSinceNow,
              dateOfExchangeInformation < aDayInSeconds  else {
            exchangeInformationIsExpired = false
            return false
        }
        exchangeInformationIsExpired = true
        return true
    }

    /**
     This function recovers the url generated by the createURL() function, and builds an instance of URL Request.
     
     - returns: Returns an instance of URL Request with GET method.
     */
    private func createRequest() -> URLRequest? {
        guard let url = createURL() else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }

    /**
     This function constructs a url using the API key.
     
     - returns: Returns an optional url.
     */
    private func createURL() -> URL? {
        let urlWithKey = "\(urlBase)?access_key=\(apiKey ?? "")&base=EUR&symbols=USD,MXN,JPY,GBP"
        guard let url = URL(string: urlWithKey) else {
            return nil
        }
        return url
    }
}
