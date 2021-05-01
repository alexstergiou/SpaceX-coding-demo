//
//  MockDashboardViewModel.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

@testable import SpaceX

final class MockDashboardViewModel: DashboardViewModelProtocol {
    var title: String {
        return "Title"
    }

    var fetchDataCalled: Bool = false
    func fetchData() {
        fetchDataCalled = true
    }

    var setupCalled: Bool = false
    func setup(tableView: UITableView) {
        setupCalled = true
    }

    var filtersButtonTappedCalled: Bool = false
    func filtersButtonTapped() {
        filtersButtonTappedCalled = true
    }
}
