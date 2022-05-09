//
//  NetworkManager.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 06/05/2022.
//

import Foundation

class NetworkManager<T: Decodable> {

    private var task: URLSessionDataTask?
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "TRANSLATOR_API_KEY") as? String

    func getInformation(request: URLRequest?, completionHandler: @escaping (T?, Error?) -> Void) {
        guard let request = request else { return }
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil,
                      let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else { return }
                print(String(data: data, encoding: .utf8)!)
                let decoderData = JSONDecoder()
                decoderData.keyDecodingStrategy = .useDefaultKeys
                guard let translation = try? decoderData.decode(T?.self, from: data) else { return }
                completionHandler(translation, error)
            }
        })
        task?.resume()
    }

    private func createURL() -> String {
        guard let key = apiKey else { return ""}
        let urlWithKey =
        "http://translation.googleapis.com/language/translate/v2?key=\(key)&q=Hello my friend&source=en&target=fr&format=text"

        return urlWithKey
    }
}
