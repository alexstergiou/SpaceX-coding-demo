//
//  FiltersCoordinatorTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 01/05/2021.
//

import XCTest

@testable import SpaceX

final class FilterTestCoordinator: Coordinator {
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

    var removeChildCalled: Bool = false
    func removeChildCoordinator(_ coordinator: Coordinator) {
        removeChildCalled = true
        children = children.filter { $0 !== coordinator }
    }
}

final class FiltersCoordinatorTests: XCTestCase {

    var dependenciesHelper: DependenciesHelper!
    var subject: FiltersCoordinator!

    override func setUpWithError() throws {
        dependenciesHelper = DependenciesHelper()
        subject = FiltersCoordinator(router: dependenciesHelper.mockRouter,
                                     dependencies: dependenciesHelper.dependencies)
    }

    override func tearDownWithError() throws {
        subject = nil
        dependenciesHelper = nil
    }

    func testStart() {
        subject.start()

        let router: MockRouter = dependenciesHelper.mockRouter
        guard let controller = router.pushedViewController as? FiltersViewController else {
            XCTFail()
            return
        }
        guard let viewModel = controller.viewModel as? FiltersViewModel else {
            XCTFail()
            return
        }
        XCTAssertNotNil(viewModel.actionDelegate)
    }

    func testReceive() {
        let parentCoordinator: FilterTestCoordinator = FilterTestCoordinator()
        subject.parent = parentCoordinator
        subject.didReceive(action: FiltersViewModel.CoordinatorAction.dismiss)
        XCTAssertTrue(dependenciesHelper.mockRouter.dismissCalled)
        XCTAssertTrue(parentCoordinator.removeChildCalled)
    }
}
