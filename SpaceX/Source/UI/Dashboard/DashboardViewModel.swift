//
//  DashboardViewModel.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

protocol DashboardViewModelProtocol {
    var title: String { get }
    func fetchData()
    func setup(tableView: UITableView)
    func filtersButtonTapped()
}

protocol DashboardViewModelResponder: AnyObject {
    func shouldReload(section: Int)
    func didFetchLaunches()
    func didFailOnLaunchFetch()
}

final class DashboardViewModel: DashboardViewModelProtocol {
    enum CoordinatorAction: DelegateAction {
        case filters([Launch])
        case actions(DashboardItem)
    }

    let companyService: CompanyServiceProtocol
    let launchesService: LaunchesServiceProtocol
    let dataSource: DashboardTableViewDataSourceProtocol
    let filtersManager: FiltersManagerProtocol

    weak var actionDelegate: ActionDelegate?
    weak var responder: DashboardViewModelResponder?

    var launches: [Launch] = []

    var title: String {
        return L.app
    }

    init(companyService: CompanyServiceProtocol,
         launchesService: LaunchesServiceProtocol,
         dataSource: DashboardTableViewDataSourceProtocol,
         filtersManager: FiltersManagerProtocol) {
        self.companyService = companyService
        self.launchesService = launchesService
        self.dataSource = dataSource
        self.filtersManager = filtersManager
        filtersManager.add(responder: self)

        self.dataSource.selectionDelegate = self
    }

    func fetchData() {
        fetchCompanyInfo()
        fetchLaunchInfo()
    }

    func setup(tableView: UITableView) {
        dataSource.setup(tableView: tableView)
    }

    func filtersButtonTapped() {
        actionDelegate?.didReceive(action: CoordinatorAction.filters(launches))
    }
}

extension DashboardViewModel {
    func fetchCompanyInfo() {
        companyService.fetchCompanyInfo { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let company):
                    guard let section = self.dataSource.update(with: company) else { return }
                    self.responder?.shouldReload(section: section)
                case .failure:
                    break
                }
            }
        }
    }

    func fetchLaunchInfo() {
        launchesService.fetchLaunches { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let launches):
                    self.launches = launches
                    self.filterLaunchesAndUpdateDataSource()
                    self.responder?.didFetchLaunches()
                case .failure:
                    self.responder?.didFailOnLaunchFetch()
                }
            }
        }
    }

    func filterLaunchesAndUpdateDataSource() {
        let filteredLaunches = filtersManager.update(with: launches)
        guard let section = dataSource.update(with: filteredLaunches) else { return }
        responder?.shouldReload(section: section)
    }
}

extension DashboardViewModel: FilterOperationsResponder {
    @objc func didUpdateFilters() {
        filterLaunchesAndUpdateDataSource()
    }
}

extension DashboardViewModel: DashboardTableViewSelectionDelegate {
    func didSelect(item: DashboardItem) {
        actionDelegate?.didReceive(action: CoordinatorAction.actions(item))
    }
}
