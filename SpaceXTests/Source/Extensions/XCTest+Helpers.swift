//
//  XCTest+Helpers.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation
import XCTest

extension XCTestCase {

    var expectationTimeout: TimeInterval {
        return 0.2
    }

    func eventually(closure: @escaping () -> Void) {
        eventually(timeout: expectationTimeout, closure: closure)
    }

    func eventually(timeout: TimeInterval = 0.01, closure: @escaping () -> Void) {
        let expectation = self.expectation(description: "")
        expectation.fulfillAfter(timeout)
        self.waitForExpectations(timeout: 5.0) { _ in
            closure()
        }
    }
}

extension XCTestExpectation {

    func fulfillAfter(_ time: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.fulfill()
        }
    }
}
