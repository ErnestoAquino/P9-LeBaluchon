//
//  ExchangeRate.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 10/05/2022.
//

import Foundation

/**
 * ExchangeRate:
 *
 * Structure for retrieving the response from the FIXER API
 */
struct ExchangeRate: Decodable {
    let success: Bool?
    let timestamp: Date?
    let base: String?
    let rates: [String: Double]?
}
