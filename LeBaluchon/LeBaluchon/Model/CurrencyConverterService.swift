//
//  CurrencyConverterService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 25/04/2022.
//

import Foundation

class CurrencyConverterService: CurrencyConverterDelegate {

    weak var viewDelegate: CurrencyConverterDelegate?
    var currency: Currency = .USD
    var moneyToConvert = ""
    private var task: URLSessionDataTask?

    private static let exchangeRateURL = URL(string: "http://data.fixer.io/api/latest?access_key=e9ef236194e10da371830069d966cc91&base=EUR&symbols=USD,MXN,JPY,GBP")!
    enum Currency: String {
        case USD
        case MXN
        case JPY
        case GBP
    }

     private  func getExchangeRate(completion: @escaping (ExchangeRate?, Error?) -> Void) {
         var request = URLRequest(url: CurrencyConverterService.exchangeRateURL)
        request.httpMethod = "GET"

        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil,
                      let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(nil, nil)
                    return
                }
                let decoderExchange = JSONDecoder()
                decoderExchange.keyDecodingStrategy = .convertFromSnakeCase
                decoderExchange.dateDecodingStrategy = .secondsSince1970
                if let exchangeRates = try? decoderExchange.decode(ExchangeRate.self, from: data) {
                    print("\(exchangeRates.rates)")
                    print(exchangeRates.base)
                    print(exchangeRates.timestamp)
                    completion(exchangeRates, error)
                } else {
                    completion(nil, nil)
                }
            }
        }
        task?.resume()
    }

    func doConversion(value: String?) {
        guard stringWithEurosIsValid(value) else {
        warningMessage("Please enter a valid amount (greater than 0 and less than 1 000 000).")
        return }
        getExchangeRate { exchangeRate, error in
            guard error == nil,
                  let exchangeRate = exchangeRate else {
                self.warningMessage("We have un little problem, please check your internet connection.")
                return
            }
            let resulat = self.calculateConversion(euros: value, exchangeData: exchangeRate)
            self.refreshTextViewWithValue("\(resulat)")
        }
    }

    func calculateConversion(euros: String?, exchangeData: ExchangeRate) -> String {
        var conversionResult = -0.0

        guard let euros = euros,
              let eurosHowDouble = Double(euros),
              !exchangeData.rates.isEmpty,
              exchangeData.rates[currency.rawValue] != nil
        else {
            return String(conversionResult)
        }
        conversionResult = eurosHowDouble * exchangeData.rates[currency.rawValue]!
        return String(conversionResult)
    }

    func stringWithEurosIsValid(_ value: String?) -> Bool {
        guard let value = value,
              let valueHowDouble = Double(value),
              valueHowDouble > 0,
              valueHowDouble < 1000000 else {return false}
        return true
    }

    func warningMessage(_ message: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.warningMessage(message)
    }

    func refreshTextViewWithValue(_ value: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.refreshTextViewWithValue(value)
    }

}

struct ExchangeRate: Decodable {
    let success: Bool
    let timestamp: Date
    let base: String
    let rates: [String: Double]
}
