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
    private var task: URLSessionDataTask?
    private let urlBase = "https://translation.googleapis.com/language/translate/v2"

    func doTranslation(textForTranslation: String?) {
        guard let textForTranslation = textForTranslation else { return }
        guard let resquest = createRequest(textForTranslation) else { return }
        let netwokManager = NetworkManager<TranslationResponse>()
        netwokManager.getInformation(request: resquest) { translationResponse, error in
            guard error == nil,
                  let translatedTex = translationResponse?.data?.translations?[0].translatedText else { return }
            self.refreshEnglishTextFieldWith(translatedTex)
        }
    }

     private func createRequest(_ textForTranslation: String) -> URLRequest? {
        guard let urlTranslation = URL(string: urlBase) else {return nil}
        guard let key = apiKey else {return nil}
        var request = URLRequest(url: urlTranslation)
        request.httpMethod = "POST"
        let body = "key=\(key)&q=\(textForTranslation)&source=fr&target=en&format=text"
        request.httpBody = body.data(using: .utf8)

        return request
    }
}
