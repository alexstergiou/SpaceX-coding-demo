//
//  URLSession+Protocols.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

typealias NetworkServiceCompletion = (_ result: Swift.Result<Data, Error>) -> Void
typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol URLSessionProtocol {
    func internalDataTask(with request: URLRequest, taskCompletion: @escaping DataTaskCompletion) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func internalDataTask(with request: URLRequest, taskCompletion: @escaping DataTaskCompletion) -> URLSessionDataTaskProtocol {
        return dataTask(with: request) { (data, response, error) in
            taskCompletion(data, response, error)
        }
    }
}
