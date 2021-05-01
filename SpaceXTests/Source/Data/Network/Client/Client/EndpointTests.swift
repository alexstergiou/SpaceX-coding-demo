//
//  EndpointTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import XCTest

@testable import SpaceX

final class EndpointTests: XCTestCase {

    func testCompanyEndpoint() {
        let endpoint: CompanyEndpoint = .company

        XCTAssertEqual(endpoint.httpMethod, .get)
        XCTAssertEqual(endpoint.path, "company")

        let expectedURLString: String = "https://api.spacexdata.com/v4/company"

        XCTAssertEqual(endpoint.url?.absoluteString, expectedURLString)
        let request: URLRequest? = endpoint.request
        XCTAssertEqual(request?.url?.absoluteString, expectedURLString)
        XCTAssertEqual(request?.httpMethod, HTTPMethod.get.rawValue)
    }

    func testLaunchesEndpoint() {
        let endpoint: LaunchesEndpoint = .launches

        XCTAssertEqual(endpoint.httpMethod, .get)
        XCTAssertEqual(endpoint.path, "launches")

        let expectedURLString: String = "https://api.spacexdata.com/v4/launches"

        XCTAssertEqual(endpoint.url?.absoluteString, expectedURLString)
        let request: URLRequest? = endpoint.request
        XCTAssertEqual(request?.url?.absoluteString, expectedURLString)
        XCTAssertEqual(request?.httpMethod, HTTPMethod.get.rawValue)
    }

    func testRocketEndpoint() {
        let endpoint: RocketEndpoint = .details("identifier")

        XCTAssertEqual(endpoint.httpMethod, .get)
        XCTAssertEqual(endpoint.path, "rockets/\("identifier")")

        let expectedURLString: String = "https://api.spacexdata.com/v4/rockets/identifier"

        XCTAssertEqual(endpoint.url?.absoluteString, expectedURLString)
        let request: URLRequest? = endpoint.request
        XCTAssertEqual(request?.url?.absoluteString, expectedURLString)
        XCTAssertEqual(request?.httpMethod, HTTPMethod.get.rawValue)
    }
}
