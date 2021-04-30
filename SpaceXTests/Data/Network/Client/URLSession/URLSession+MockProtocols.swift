//
//  URLSession+MockProtocols.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

@testable import SpaceX

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {

    var resumeCalled: Bool = false
    func resume() {
        resumeCalled = true
    }

    var cancelCalled: Bool = false
    func cancel() {
        cancelCalled = true
    }
}

final class MockURLSession: URLSessionProtocol {
    var dataTask: MockURLSessionDataTask = MockURLSessionDataTask()

    var data: Data?
    var error: Error?
    var response: URLResponse?

    func internalDataTask(with request: URLRequest, taskCompletion: @escaping DataTaskCompletion) -> URLSessionDataTaskProtocol {
        dataTask = MockURLSessionDataTask()

        taskCompletion(data, response, error)
        
        return dataTask
    }
}
