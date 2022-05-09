//
//  WeatherData.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 09/05/2022.
//

import Foundation

struct WeatherData: Decodable {
    let weather: [Weather]?
    let main: [String: Double]?
    let wind: [String: Double]?
    let date: Date?

    private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weather
        case main
        case wind
    }
}

struct Weather: Decodable {
    let weatherID: Int?
    let main: String?
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case weatherID = "id"
        case main
        case description
    }
}
