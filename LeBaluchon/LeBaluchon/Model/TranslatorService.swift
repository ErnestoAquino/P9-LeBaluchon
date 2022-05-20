//
//  TranslatorService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 06/05/2022.
//

import Foundation

final class TranslateService {
    weak var viewDelegate: TranslatorDelegate?
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "TRANSLATOR_API_KEY") as? String
    private let urlBase = "https://translation.googleapis.com/language/translate/v2"
    private let session = URLSession.shared

    // This function does the translation, it uses the getInformation method  of the
    // network manager class to request the translation, and retrives the translated text.
    public func doTranslation(textForTranslation: String?) {
        guard let textForTranslation = textForTranslation else { return }
        guard let resquest = createRequest(textForTranslation) else { return }
//        let session = URLSession(configuration: .default)
        let testNetworkManager = TestNetworkManager<TranslationResponse>(networkManagerSession: session)
        toogleActivityIndicator(shown: true)
        testNetworkManager.getInformation(request: resquest) { translationResponse, error in
            self.toogleActivityIndicator(shown: false)
            guard error == nil,
                  let translatedText = translationResponse?.data?.translations?[0].translatedText else { return }
            self.refreshEnglishTextFieldWith(translatedText)
        }

//        toogleActivityIndicator(shown: true)
//        netwokManager.getInformation(request: resquest) { translationResponse, error in
//            self.toogleActivityIndicator(shown: false)
//            guard error == nil,
//                  let translatedTex = translationResponse?.data?.translations?[0].translatedText else { return }
//            self.refreshEnglishTextFieldWith(translatedTex)
//        }
    }

    // This function create a URL Request for URL Session.
    // Receives as a parameter the text to be translated and adds it to the request body.
     private func createRequest(_ textForTranslation: String) -> URLRequest? {
        guard let urlTranslation = URL(string: urlBase),
              let key = apiKey else {return nil}
        var request = URLRequest(url: urlTranslation)
        request.httpMethod = "POST"
        let body = "key=\(key)&q=\(textForTranslation)&source=fr&target=en&format=text"
        request.httpBody = body.data(using: .utf8)

        return request
    }

    private func createSession() -> URLSession {
        let session = URLSession(configuration: .default)
        return session
    }
}
