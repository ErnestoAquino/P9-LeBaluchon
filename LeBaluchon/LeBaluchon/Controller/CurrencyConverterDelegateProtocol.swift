//
//  CurrencyConverterDelegateProtocol.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 28/04/2022.
//

import Foundation

protocol CurrencyConverterDelegate: AnyObject {
    func warningMessage(_ message: String)
    func refreshTextViewWithValue(_ value: String)
    func toogleActivityIndicator(shown: Bool)
}
