//
//  MockNetworkClient.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

@testable import SpaceX

final class MockNetworkClient: NetworkClientProtocol {
    var dataTask: MockURLSessionDataTask = MockURLSessionDataTask()

    var result: Result<Data, Error>?

    @discardableResult func execute(request: URLRequest, completion: NetworkServiceCompletion?) -> URLSessionDataTaskProtocol {
        dataTask = MockURLSessionDataTask()
        if let result = result {
            completion?(result)
        }
        return dataTask
    }
}
