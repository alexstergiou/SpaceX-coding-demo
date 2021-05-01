//
//  MockRocketService.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

@testable import SpaceX

final class MockRocketService: RocketServiceProtocol {

    var rocket: Rocket?
    var error: Error = TestError.test
    var dataTask: MockURLSessionDataTask?

    var fetchRocketDetailsCalled: Bool = false
    func fetchRocketDetails(with rocketIdentifier: String, completion: RocketDetailsCompletion?) -> URLSessionDataTaskProtocol? {
        fetchRocketDetailsCalled = true
        
        if let rocket = rocket {
            completion?(Result.success(rocket))
        } else {
            completion?(Result.failure(error))
        }
        return dataTask
    }
}
