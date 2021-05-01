//
//  RocketServiceTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class RocketServiceTests: XCTestCase {

    var subject: RocketService!
    var mockClient: MockNetworkClient!

    override func setUpWithError() throws {
        mockClient = MockNetworkClient()
        subject = RocketService(client: mockClient)
    }

    override func tearDownWithError() throws {
        subject = nil
        mockClient = nil
    }

    func testRocketInfoFailure() {
        mockClient.result = Result.failure(TestError.test)

        let promise = expectation(description: "testRocketInfoFailure")

        subject.fetchRocketDetails(with: "id") { result in
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

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testRocketInfoDecodingFailure() {
        mockClient.result = Result.success(Data())

        let promise = expectation(description: "testRocketInfoDecodingFailure")

        subject.fetchRocketDetails(with: "id") { result in
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

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testRocketInfoSuccess() {
        mockClient.result = Result.success(self.mockRocketData)

        let promise = expectation(description: "testRocketInfoSuccess")

        subject.fetchRocketDetails(with: "id") { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

extension RocketServiceTests {
    var mockRocketData: Data {
        let encoder: JSONEncoder = JSONEncoder()
        return try! encoder.encode(mockRocket)
    }

    var mockRocket: Rocket {
        return Rocket(name: "RocketName",
                      type: "RocketType",
                      description: "RocketDesc")
    }
}
