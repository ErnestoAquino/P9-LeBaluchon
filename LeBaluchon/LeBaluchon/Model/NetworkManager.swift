//
//  NetworkManager.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 06/05/2022.
//

import Foundation

class NetworkManager<T: Decodable> {

    private var task: URLSessionDataTask?

    func getInformation(request: URLRequest?, completionHandler: @escaping (T?, Error?) -> Void) {
        guard let request = request else {return}
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil,
                      let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {return}
                let decoderData = JSONDecoder()
                decoderData.keyDecodingStrategy = .useDefaultKeys
                decoderData.dateDecodingStrategy = .secondsSince1970
                guard let translation = try? decoderData.decode(T?.self, from: data) else {return}
                completionHandler(translation, error)
            }
        })
        task?.resume()
    }

}
