//
//  WeatherDelegateProtocol.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 02/05/2022.
//

import Foundation

protocol WeatherDelegate: AnyObject {
    func warningMessage(_ message: String)
    func refreshNewYorkTextFieldWith(_ value: String)
    func refreshBrevalTextFieldWith(_ value: String)
    func toogleActivityIndicator(shown: Bool)
}
