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
}
