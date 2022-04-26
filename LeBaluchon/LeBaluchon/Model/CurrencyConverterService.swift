//
//  CurrencyConverterService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 25/04/2022.
//

import Foundation

class CurrencyConverterService {
    private static let currencyConverterUrl =
        URL(string: "http://data.fixer.io/api/latest?access_key=e9ef236194e10da371830069d966cc91&base=EUR&symbols=USD,MXN,JPY,GBP")!
    
    static func getExchangeRate(){
        var request = URLRequest(url: currencyConverterUrl)
        request.httpMethod = "GET"
        
//        let body = "access_key=e9ef236194e10da371830069d966cc91&base=EUR&symbols=USD,MXN,JPY,GBP"
//        request.httpBody = body.data(using: .utf8)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("1. Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                if statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        let exchange = try decoder.decode(ExchangeRate.self, from: data)
                        print (exchange.base)
                        print (exchange.timestamp)
                        if exchange.rates.count > 1 {
                            print (exchange.rates["USD"]!)
                        }
                        
                    } catch let error {
                        print("2. Error: \(error.localizedDescription)")
                    }
                }
            }
        }
//            if let dataResponse = data , error == nil{
//                if let responseResponse = response as? HTTPURLResponse, responseResponse.statusCode == 200 {
//                    print("Hasta aqui todo bien")
//                    if  let exchangeRate =  try? JSONDecoder().decode(ExchangeRate.self, from: dataResponse){
//                        print("funciono")
//                    }
//
//                }
//            }
            
//            if let data = data, error == nil {
//                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    decoder.dateDecodingStrategy = .secondsSince1970
//
//
//
//
//                    let exchangeRate = try?  decoder.decode(ExchangeRate.self, from: data)
//                    print(exchangeRate?.base ?? "No funcionp")
//
//
//
//                    guard let resultado = exchangeRate?.success else {return}
//                    print(resultado)
//
//                    if let responseJSON = try? JSONDecoder().decode([String:String].self, from: data){
//                        let dollar = responseJSON["USD"],
//                        let mexicanPeso = responseJSON["MXN"],
//                        let yen =  responseJSON["JPY"],
//                        let poundSterling = responseJSON["GBP"]{
//
//                        print ("iam here")
//                    }
//                }
//            }
            
//            print(data ?? "No funciono")
//            print(response ?? "No funciono response")
//            print(error ?? "No funciono error")
            
       
        task.resume()
    }
    
}


struct ExchangeRate : Decodable {
    let success: Bool
    let timestamp: Date
    let base: String
    let rates: [String : Float]
}


