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
    private let session: URLSessionProtocol

    init(_ session: URLSessionProtocol) {
        self.session = session
    }

    // This function does the translation, it uses the getInformation method  of the
    // network manager class to request the translation, and retrives the translated text.
    public func doTranslation(textForTranslation: String?, completion: @escaping (Bool) -> Void) {
        let networkManager =  NetworkManager<TranslationResponse>(networkManagerSession: session)
        guard let textForTranslation = textForTranslation else {
            warningMessage("Sorry, but your text is not valid")
            completion(false)
            return
        }
        guard let resquest = createRequest(textForTranslation) else {
            warningMessage("Sorry, we have a little problem.")
            return
        }
        toogleActivityIndicator(shown: true)
        networkManager.getInformation(request: resquest) { translationResponse, error in
                self.toogleActivityIndicator(shown: false)
                guard error == nil else {
                    self.warningMessage("Sorry, we have a little problem.")
                    completion(false)
                    return
                }
                 guard let translatedText = translationResponse?.data?.translations?[0].translatedText else {
                     self.warningMessage("Sorry, we have a little problem.")
                     completion(false)
                     return
                 }
            self.refreshEnglishTextFieldWith(translatedText)
            completion(true)
        }
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
}
