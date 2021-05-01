//
//  DashboardCoordinatorTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class DashboardCoordinatorTests: XCTestCase {

    var dependenciesHelper: DependenciesHelper!
    var subject: DashboardCoordinator!

    override func setUpWithError() throws {
        dependenciesHelper = DependenciesHelper()
        let dependencies: Dependencies = dependenciesHelper.dependencies

        dependenciesHelper.mockLinkAlertProvider.controller = UIAlertController()

        subject = DashboardCoordinator(router: dependenciesHelper.mockRouter,
                                       dependencies: dependencies,
                                       linkAlertProvider: dependenciesHelper.mockLinkAlertProvider)
    }

    override func tearDownWithError() throws {
        subject = nil
        dependenciesHelper = nil
    }

    func testStart() {
        subject.start()

        guard let viewController = dependenciesHelper.mockRouter.pushedViewController as? DashboardViewController else {
            XCTFail()
            return
        }
        guard let viewModel = viewController.viewModel as? DashboardViewModel else {
            XCTFail()
            return
        }
        XCTAssertNotNil(viewModel.responder)
        XCTAssertNotNil(viewModel.actionDelegate)
    }

    func testShowFilters() {
        subject.showFilters()
        filtersTests()
    }

    func testDidReceiveFilters() {
        subject.didReceive(action: DashboardViewModel.CoordinatorAction.filters([]))
        filtersTests()
    }

    func filtersTests() {
        guard let coordinator = subject.children.first as? FiltersCoordinator else {
            XCTFail()
            return
        }
        XCTAssertNotNil(coordinator.parent)
    }

    func testShowActionsWithoutController() {
        dependenciesHelper.mockLinkAlertProvider.controller = nil
        subject.showActions(item: TestCompanyDashboardItem())
        XCTAssertFalse(dependenciesHelper.mockRouter.presentCalled)
    }

    func testShowActions() {
        subject.showActions(item: TestCompanyDashboardItem())
        XCTAssertTrue(dependenciesHelper.mockRouter.presentCalled)
    }

    func testDidReceiveActions() {
        subject.didReceive(action: DashboardViewModel.CoordinatorAction.actions(TestCompanyDashboardItem()))
        XCTAssertTrue(dependenciesHelper.mockRouter.presentCalled)
    }
}
