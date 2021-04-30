//
//  DashboardViewController.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

final class DashboardViewController: UITableViewController {

    let viewModel: DashboardViewModelProtocol

    init(viewModel: DashboardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setup(tableView: tableView)
        viewModel.fetchData()
        title = viewModel.title

    }
}

extension DashboardViewController {
    func setupBarButtonItems() {
        navigationItem.largeTitleDisplayMode = .always
        let item: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Filters", comment: ""), style: .done, target: self, action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = item
    }

    @objc func filterButtonTapped() {
        viewModel.filtersButtonTapped()
    }
}

extension DashboardViewController: DashboardViewModelResponder {
    func shouldReload(section: Int) {
        tableView.reload(section: section)
    }

    func didFetchLaunches() {
        setupBarButtonItems()
    }
}
