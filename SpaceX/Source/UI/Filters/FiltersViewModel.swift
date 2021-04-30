//
//  FiltersViewModel.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

protocol FiltersViewModelProtocol {
    var title: String { get }
    func setup(tableView: UITableView)
    func doneBarButtonItemTapped()
}

final class FiltersViewModel: FiltersViewModelProtocol {
    enum CoordinatorAction: DelegateAction {
        case dismiss
    }

    let dataSource: FiltersTableViewDataSource
    let filtersManager: FiltersManagerProtocol

    weak var actionDelegate: ActionDelegate?

    init(filtersManager: FiltersManagerProtocol) {
        self.filtersManager = filtersManager
        self.dataSource = FiltersTableViewDataSource(filtersManager: filtersManager)
        self.dataSource.responder = self
    }

    var title: String {
        return NSLocalizedString("Filters", comment: "")
    }

    func setup(tableView: UITableView) {
        dataSource.setup(tableView: tableView)
    }

    func doneBarButtonItemTapped() {
        actionDelegate?.didReceive(action: CoordinatorAction.dismiss)
    }
}

extension FiltersViewModel: FiltersTableViewDataSourceResponder {
    func filtersChanged() {
        filtersManager.filtersUpdated()
    }
}
