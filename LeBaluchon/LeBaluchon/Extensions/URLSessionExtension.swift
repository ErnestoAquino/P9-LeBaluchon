//
//  URLSessionExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 19/05/2022.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTaskWithRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        dataTask(with: request, completionHandler: completion) as URLSessionDataTaskProtocol
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {
    func resumeWithRequest() {
        resume()
    }
}

// typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTaskWithRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resumeWithRequest()
    func cancel()
}
