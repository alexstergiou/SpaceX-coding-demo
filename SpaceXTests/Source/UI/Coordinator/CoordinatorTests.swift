//
//  CoordinatorTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class TestCoordinator: Coordinator {
    var parent: Coordinator?

    let mockRouter: MockRouter = MockRouter()

    var router: Routable {
        return mockRouter
    }

    var children: [Coordinator] = []

    var startCalled: Bool = false
    func start() {
        startCalled = true
    }
}

final class CoordinatorTests: XCTestCase {
    func testChildren() {
        let coordinator: TestCoordinator = TestCoordinator()
        let childCoordinator: TestCoordinator = TestCoordinator()

        XCTAssertEqual(coordinator.children.count, 0)
        coordinator.addChildCoordinator(childCoordinator)
        XCTAssertNotNil(childCoordinator.parent)
        XCTAssertEqual(coordinator.children.count, 1)

        coordinator.removeChildCoordinator(coordinator)
        XCTAssertEqual(coordinator.children.count, 1)
        coordinator.removeChildCoordinator(childCoordinator)
        XCTAssertEqual(coordinator.children.count, 0)
    }
}
