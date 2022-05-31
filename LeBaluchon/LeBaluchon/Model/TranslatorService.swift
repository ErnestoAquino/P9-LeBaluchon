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

    init(_ session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    /**
     This function translates the text it receives into a parameter. If for some reason it fails to perform the task, it displays an error message to the user.
     
     - parameter textToTranslate: Optional string with the text to be translated.
     */
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

    /**
     This function retrieves the translation from the Google Translator API using the network manager class.
     
     - parameter textToTranslate: Optional string with the text to be translated.
     - parameter completion:      This completion handler takes the following parameters:
                                String? : Google translator API response.
                                Bool?: False that indicates  the request failed or True
                                if the request was successful
     */
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

    /**
     This function creates an optional URL Request with method " POST ".
     
     - parameter textForTranslation: String with the text to be translated.
     
     - returns: Returns a URL Request for the text to be translated.
     */
    private func creteRequest(_ textForTranslation: String) -> URLRequest? {
        guard let url = URL(string: urlBase) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "key=\(apiKey ?? "")&q=\(textForTranslation)&source=fr&target=en&format=text"
        request.httpBody = body.data(using: .utf8)

        return request
    }
}
