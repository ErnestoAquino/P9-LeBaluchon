//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 02/05/2022.
//

import Foundation

class WeatherService {
    weak var viewDelegate: WeatherProtocol?
    

}

extension WeatherService: WeatherProtocol {
    func warningMessage(_ message: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.warningMessage(message)
    }

    func refreshNewYorkTextFieldWith(_ value: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.refreshNewYorkTextFieldWith(value)
    }

    func refreshBrevalTextFieldWith(_ value: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.refreshBrevalTextFieldWith(value)
    }
}

struct WeatherData: Decodable {
    let weather: [Weather]
    let main: [String: Double]
    let wind: [String: Double]
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}
