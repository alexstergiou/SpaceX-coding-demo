//
//  EndpointRequestProviderTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import XCTest

@testable import SpaceX

final class EndpointRequestProviderTests: XCTestCase {

    func testRequest() {
        let subject: EndpointRequestProvider = EndpointRequestProvider()
        XCTAssertNil(subject.request(url: nil, httpMethod: .get))

        let urlString: String = "https://www.spacex.com"
        let url: URL = URL(string: urlString)!
        XCTAssertNotNil(subject.request(url: url, httpMethod: .get))
    }
}
