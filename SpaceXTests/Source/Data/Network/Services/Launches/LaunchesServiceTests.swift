//
//  LaunchesServiceTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class LaunchesServiceTests: XCTestCase {
    var subject: LaunchesService!
    var mockClient: MockNetworkClient!

    override func setUpWithError() throws {
        mockClient = MockNetworkClient()
        subject = LaunchesService(client: mockClient)
    }

    override func tearDownWithError() throws {
        subject = nil
        mockClient = nil
    }

    func testLaunchesInfoFailure() {
        mockClient.result = Result.failure(TestError.test)

        let promise = expectation(description: "testLaunchesInfoFailure")

        subject.fetchLaunches { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                guard let testError = error as? TestError else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(testError, .test)
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: expectationTimeout, handler: nil)
    }

    func testLaunchesInfoDecodingFailure() {
        mockClient.result = Result.success(Data())

        let promise = expectation(description: "testLaunchesInfoDecodingFailure")

        subject.fetchLaunches { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                guard let _ = error as? DecodingError else {
                    XCTFail()
                    return
                }
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: expectationTimeout, handler: nil)
    }

    func testLaunchesInfoSuccess() {
        mockClient.result = Result.success(self.mockLaunchesData)

        let promise = expectation(description: "testLaunchesInfoSuccess")

        subject.fetchLaunches { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: expectationTimeout, handler: nil)
    }
}

extension LaunchesServiceTests {
    var mockLaunchesData: Data {
        let encoder: JSONEncoder = JSONEncoder()
        return try! encoder.encode(mockLaunches)
    }

    var mockLaunches: [Launch] {
        return [Launch(name: "name",
                       timestamp: 100,
                       links: Links(patch: nil,
                                    webcast: "https://www.spacex.com",
                                    article: "https://www.spacex.com",
                                    wikipedia: "https://www.spacex.com"),
                       rocketID: "identifier",
                       success: true)]
    }
}
