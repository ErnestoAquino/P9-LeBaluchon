//
//  TranslatorDelegateProtocol.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 07/05/2022.
//

import Foundation

protocol TranslatorDelegate: AnyObject {
    func warningMessage(_ message: String)
    func refreshEnglishTextFieldWith(_ translatedTex: String)
}
