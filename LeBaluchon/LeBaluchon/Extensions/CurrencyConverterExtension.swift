//
//  CurrencyConverterExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 10/05/2022.
//

import Foundation

extension CurrencyConverterService: CurrencyConverterDelegate {
    func warningMessage(_ message: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.warningMessage(message)
    }

    func refreshTextViewWithValue(_ value: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.refreshTextViewWithValue(value)
    }
}
