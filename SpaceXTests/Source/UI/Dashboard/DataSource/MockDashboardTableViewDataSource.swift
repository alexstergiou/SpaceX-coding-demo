//
//  MockDashboardTableViewDataSource.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

@testable import SpaceX

final class MockDashboardTableViewDataSource: DashboardTableViewDataSourceProtocol {
    var sections: [DashboardSection] = []

    var selectionDelegate: DashboardTableViewSelectionDelegate?

    var setupCalled: Bool = false
    func setup(tableView: UITableView) {
        setupCalled = true
    }

    var updateCompanySection: Int?
    var updateCompanyCalled: Bool = false
    func update(with company: Company) -> Int? {
        updateCompanyCalled = true
        return updateCompanySection
    }

    var updateLaunchesSection: Int?
    var updateLaunchesCalled: Bool = false
    func update(with launches: [Launch]) -> Int? {
        updateLaunchesCalled = true
        return updateLaunchesSection
    }
}
