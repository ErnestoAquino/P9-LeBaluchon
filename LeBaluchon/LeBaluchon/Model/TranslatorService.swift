//
//  TranslatorService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 06/05/2022.
//

import Foundation

class TranslateService {
    weak var viewDelegate: TranslatorDelegate?
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "TRANSLATOR_API_KEY") as? String
    private let urlTranslator = URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyC9DahFwVoDYphW78uiaVuqO-erO4bc-ls&q=Hello Google traductor!&source=en&target=fr&format=text")!
    private let networkManager = NetworkManager(urlService: urlTranslator)
    func test() {
        guard let key = apiKey else { return }
        refreshEnglishTextFieldWith(key)
    }
}
// MARK: - Extension
extension TranslateService: TranslatorDelegate {
    func warningMessage(_ message: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.warningMessage(message)
    }

    func refreshEnglishTextFieldWith(_ translatedTex: String) {
        guard let viewDelegate = viewDelegate else { return }
        viewDelegate.refreshEnglishTextFieldWith(translatedTex)
    }
}

// MARK: - Structure
struct TranslationResponse: Decodable {
    let data: Translations?
    struct Translations: Decodable {
        let translation: [TranslationText]?
    }
    struct TranslationText: Decodable {
        let translatedText: String?
    }
}
