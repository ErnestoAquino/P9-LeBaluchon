//
//  TranslateServiceExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 09/05/2022.
//

import Foundation

extension TranslateService: TranslatorDelegate {
    func warningMessage(_ message: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.warningMessage(message)
    }

    func refreshEnglishTextFieldWith(_ translatedTex: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.refreshEnglishTextFieldWith(translatedTex)
    }

    func toogleActivityIndicator(shown: Bool) {
        guard let viewDelegare = viewDelegate else { return }
        viewDelegare.toogleActivityIndicator(shown: shown)
    }
}
