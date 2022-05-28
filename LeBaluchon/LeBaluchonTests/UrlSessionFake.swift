//
//  UrlSessionFake.swift
//  LeBaluchonTests
//
//  Created by Ernesto Elias Aquino Cifuentes on 17/05/2022.
//

import Foundation
import UIKit
@testable import LeBaluchon

/**
 * URLSessionFake:
 *
 * This class is a mock of the URL Session class, it is initialized with the necessary information to make the tests.
 */
class URLSessionFake: URLSessionProtocol {

    var data: Data?
    var response: URLResponse?
    var error: Error?

    init(data: Data?, response: URLResponse?, error: Error? ) {
        self.data = data
        self.response = response
        self.error = error
    }

    func dataTaskWithRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task = URLSessionDataTaskFake(data: data, urlResponse: response, responseError: error)
        task.completionHandler = completion
        return task
    }
}

/**
 * URLSessionDataTaskFake:
 *
 *This class is a mock of the  URLSessionDataTask. The resume() method only resends the information that has been entered at the time of initialization.
 */
class URLSessionDataTaskFake: URLSessionDataTaskProtocol {

    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?

    init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = responseError
    }

    func resumeWithRequest() {
        completionHandler?(data, urlResponse, responseError)
    }

    func cancel() {}
}
