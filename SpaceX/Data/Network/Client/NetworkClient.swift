//
//  NetworkClient.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

protocol NetworkClientProtocol {
    @discardableResult func execute(request: URLRequest, completion: NetworkServiceCompletion?) -> URLSessionDataTaskProtocol
}

final class NetworkClient: NetworkClientProtocol {
    let session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
    }

    @discardableResult func execute(request: URLRequest, completion: NetworkServiceCompletion?) -> URLSessionDataTaskProtocol {
        let dataTask: URLSessionDataTaskProtocol = session.internalDataTask(with: request) { (data, response, error) in
            if let error = error {
                completion?(Result.failure(error))
            } else if let data = data {
                completion?(Result.success(data))
            }
        }
        dataTask.resume()

        return dataTask
    }
}
