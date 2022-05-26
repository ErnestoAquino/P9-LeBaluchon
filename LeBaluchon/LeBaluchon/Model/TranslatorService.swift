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
    private (set) var translatedTex = ""

    init(_ session: URLSessionProtocol) {
        self.session = session
    }

    public func doTranslation(textToTranslate: String?) {
        obtainTranslation(textToTranslate) { textTranslated, succes in
            guard succes == true,
                  let textTranslated = textTranslated else {
                self.warningMessage("Sorry, we have a little problem")
                return
            }
            self.translatedTex = textTranslated
            self.refreshEnglishTextFieldWith(self.translatedTex)
        }
    }

    private func obtainTranslation(_ textToTranslate: String?, completion: @escaping (String?, Bool?) -> Void) {
        let networkManager = NetworkManager<TranslationResponse>(networkManagerSession: session)
        guard let textToTranslate = textToTranslate else {
            warningMessage("Sorry, but your text is not valid")
            completion(nil, false)
            return
        }
        let request = creteRequest(textToTranslate)
        toogleActivityIndicator(shown: true)
        networkManager.getInformation(request: request) { translationResponse, error in
            self.toogleActivityIndicator(shown: false)
            guard error == nil,
                  let translatedText = translationResponse?.data?.translations?[0].translatedText else {
                self.warningMessage("Sorry, we have a little problem")
                completion(nil, false)
                return
            }
            completion(translatedText, true)
        }
    }

    private func creteRequest(_ textForTranslation: String) -> URLRequest {
        let url =  createURL()
        let key = createKey()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "key=\(key)&q=\(textForTranslation)&source=fr&target=en&format=text"
        request.httpBody = body.data(using: .utf8)

        return request
    }

    private func createURL() -> URL {
        guard let urlTranslation = URL(string: urlBase) else {
            return  URL(string: " ")!
        }
        return urlTranslation
    }

    private func createKey() -> String {
        guard let key = apiKey else {
            return " "
        }
        return key
    }
}
