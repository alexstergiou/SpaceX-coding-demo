//
//  MockLaunchesService.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

@testable import SpaceX

final class MockLaunchesService: LaunchesServiceProtocol {

    var launches: [Launch]?
    var error: Error = TestError.test

    var fetchLaunchesCalled: Bool = false
    func fetchLaunches(completion: LaunchesServiceCompletion?) {
        fetchLaunchesCalled = true

        if let launches = launches {
            completion?(Result.success(launches))
        } else {
            completion?(Result.failure(error))
        }
    }
}
