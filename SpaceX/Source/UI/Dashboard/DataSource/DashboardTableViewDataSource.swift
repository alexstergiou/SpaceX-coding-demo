//
//  DashboardTableViewDataSource.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

enum DashboardSectionType {
    case company
    case launches
}

protocol DashboardSection: AnyObject {
    var title: String { get }
    var type: DashboardSectionType { get }
    var items: [DashboardItem] { get set }
}

enum DashboardItemType {
    case company
    case launch
}

protocol DashboardItem {
    var type: DashboardItemType { get }
}

protocol DashboardTableViewDataSourceProtocol: AnyObject {
    var sections: [DashboardSection] { get set }
    var selectionDelegate: DashboardTableViewSelectionDelegate? { get set }

    func setup(tableView: UITableView)

    func update(with company: Company) -> Int?
    func update(with launches: [Launch]) -> Int?
}

protocol DashboardTableViewSelectionDelegate: AnyObject {
    func didSelect(item: DashboardItem)
}

final class DashboardTableViewDataSource: NSObject, DashboardTableViewDataSourceProtocol {
    var sections: [DashboardSection] = []
    let companySection: DashboardCompanySectionViewModel
    let launchesSection: DashboardLaunchesSectionViewModel

    weak var selectionDelegate: DashboardTableViewSelectionDelegate?

    init(services: Services) {
        self.companySection = DashboardCompanySectionViewModel()
        self.launchesSection = DashboardLaunchesSectionViewModel(launchesService: services.launchesService,
                                                                 imageService: services.imageService,
                                                                 rocketService: services.rocketService)

        sections.append(companySection)
        sections.append(launchesSection)

        super.init()
    }

    func setup(tableView: UITableView) {
        tableView.register(cellClass: CompanyTableViewCell.self)
        tableView.register(cellClass: LaunchTableViewCell.self)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.tableFooterView = UIView()
    }

    func update(with company: Company) -> Int? {
        companySection.update(with: company)

        return indexOfSection(type: .company)
    }

    func update(with launches: [Launch]) -> Int? {
        launchesSection.update(with: launches)
        return indexOfSection(type: .launches)
    }
}

extension DashboardTableViewDataSource {
    func indexOfSection(type: DashboardSectionType) -> Int? {
        for (index, section) in sections.enumerated() {
            if section.type == type {
                return index
            }
        }
        return nil
    }

    func section(at index: Int) -> DashboardSection? {
        guard index < sections.count else { return nil }
        return sections[index]
    }
}

extension DashboardTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section(at: section)?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = section(at: indexPath.section) else { fatalError() }
        switch section.type {
        case .company:
            return self.tableView(tableView, companyCellForRowAt: indexPath)
        case .launches:
            return self.tableView(tableView, launchesCellForRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, companyCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.reuseIdentifier(), for: indexPath) as? CompanyTableViewCell else { fatalError() }
        guard let section = section(at: indexPath.section) else { fatalError() }

        let item = section.items[indexPath.row]

        cell.update(with: item)

        return cell
    }

    func tableView(_ tableView: UITableView, launchesCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.reuseIdentifier(), for: indexPath) as? LaunchTableViewCell else { fatalError() }
        guard let section = section(at: indexPath.section) else { fatalError() }

        let item = section.items[indexPath.row]

        cell.update(with: item)

        return cell
    }
}

extension DashboardTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section(at: section)?.title
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = self.section(at: indexPath.section) else { return }
        let item: DashboardItem = section.items[indexPath.row]
        selectionDelegate?.didSelect(item: item)
    }
}
