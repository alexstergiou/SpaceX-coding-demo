//
//  NetworkClientTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import XCTest

@testable import SpaceX

final class NetworkClientTests: XCTestCase {

    var subject: NetworkClient!
    var session: MockURLSession!

    override func setUpWithError() throws {
        session = MockURLSession()
        subject = NetworkClient(session: session)
    }

    override func tearDownWithError() throws {
        subject = nil
        session = nil
    }

    func testDataTaskWithError() {
        session.error = TestError.test

        let promise = expectation(description: "testDataTaskWithError")

        subject.execute(request: self.testRequest()) { (result) in
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

    func testDataTaskWithSuccess() {
        let responseString: String = "responseDataHere"
        let responseData: Data = responseString.data(using: .utf8)!

        session.data = responseData

        let promise = expectation(description: "testDataTaskWithSuccess")

        subject.execute(request: self.testRequest()) { (result) in
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

    func testRequest() -> URLRequest {
        let urlString: String = "https://www.spacex.com"
        let url: URL = URL(string: urlString)!
        return URLRequest(url: url)
    }
}
