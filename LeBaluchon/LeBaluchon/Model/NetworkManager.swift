//
//  NetworkManager.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 06/05/2022.
//

import Foundation

public final class NetworkManager<T: Decodable> {

    private var task: URLSessionDataTaskProtocol?
    private var session: URLSessionProtocol

    init (networkManagerSession: URLSessionProtocol) {
        self.session = networkManagerSession
    }

    func getInformation(request: URLRequest?, completionHandler: @escaping (T?, Error?) -> Void) {
        guard let request = request else {
            completionHandler(nil, nil)
            return
        }
        task?.cancel()
        task = session.dataTaskWithRequest(request, completion: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completionHandler(nil, nil)
                    return
                }
                let decoderData = JSONDecoder()
                decoderData.keyDecodingStrategy = .useDefaultKeys
                decoderData.dateDecodingStrategy = .secondsSince1970
                guard let informationObtained = try? decoderData.decode(T?.self, from: data) else {
                    completionHandler(nil, nil)
                    return
                }
                completionHandler(informationObtained, error)
            }
        })
        task?.resumeWithRequest()
    }
}
