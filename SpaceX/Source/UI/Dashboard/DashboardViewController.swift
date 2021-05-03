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
        title = viewModel.title

        viewModel.setup(tableView: tableView)

        fetchData()

        setupRefreshControl()
    }
}

extension DashboardViewController {
    @objc func fetchData() {
        viewModel.fetchData()
    }

    func setupRefreshControl() {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        self.refreshControl = refreshControl
    }

    func setupBarButtonItems() {
        navigationItem.largeTitleDisplayMode = .always
        let item: UIBarButtonItem = UIBarButtonItem(title: L.Dashboard.filters, style: .done, target: self, action: #selector(filterButtonTapped))
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
        refreshControl?.endRefreshing()
        setupBarButtonItems()
    }

    func didFailOnLaunchFetch() {
        refreshControl?.endRefreshing()
    }
}
