//
//  URLSessionExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 19/05/2022.
//

import Foundation

// URL Session protocol adn URL Session protocol allow to make the classes testable. Allowing the injection of dependencies.

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

protocol URLSessionProtocol {
    func dataTaskWithRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resumeWithRequest()
    func cancel()
}
