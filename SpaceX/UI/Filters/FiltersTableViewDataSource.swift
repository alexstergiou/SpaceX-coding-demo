//
//  FiltersTableViewDataSource.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

protocol FiltersTableViewDataSourceResponder: AnyObject {
    func filtersChanged()
}

final class FiltersTableViewDataSource: NSObject {
    let filtersManager: FiltersManagerProtocol
    let filters: [Filter]
    weak var responder: FiltersTableViewDataSourceResponder?

    let dateFormatter: DateFormatter

    init(filtersManager: FiltersManagerProtocol, dateFormatter: DateFormatter = DateFormatter()) {
        self.filtersManager = filtersManager
        self.filters = filtersManager.allFilters
        self.dateFormatter = dateFormatter
        super.init()

        self.dateFormatter.dateFormat = DateFormat.year.rawValue
    }

    func setup(tableView: UITableView) {
        tableView.register(cellClass: StartEndDateTableViewCell.self)
        tableView.register(cellClass: TitleSwitchTableViewCell.self)
        tableView.dataSource = self

        tableView.tableFooterView = UIView()
    }
}

extension FiltersTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter: Filter = filters[indexPath.row]

        switch filter.type {
        case .launchSuccess, .orderAscending:
            return self.tableView(tableView, filter: filter, titleSwitchTableViewCell: indexPath)
        case .duration:
            return self.tableView(tableView, filter: filter, datesTableViewCell: indexPath)
        }
    }
}

extension FiltersTableViewDataSource {
    func tableView(_ tableView: UITableView, filter: Filter, datesTableViewCell indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StartEndDateTableViewCell.reuseIdentifier(), for: indexPath) as? StartEndDateTableViewCell else { fatalError() }
        if let item = filter as? StartEndDateItem {
            cell.update(title: item.title, dataSource: DatePickerDataSource(dateItem: item, filtersManager: filtersManager))
        }

        return cell
    }

    func tableView(_ tableView: UITableView, filter: Filter, titleSwitchTableViewCell indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleSwitchTableViewCell.reuseIdentifier(), for: indexPath) as? TitleSwitchTableViewCell else { fatalError() }

        if let booleanItem = filter as? BooleanItem {
            cell.update(with: booleanItem, responder: self)
        }

        return cell
    }

    func startText(date: Date?) -> String? {
        if let date = date {
            return NSLocalizedString("Start: ", comment: "") + dateFormatter.string(from: date)
        }
        return nil
    }

    func endText(date: Date?) -> String? {
        if let date = date {
            return NSLocalizedString("End: ", comment: "") + dateFormatter.string(from: date)
        }
        return nil
    }
}

extension FiltersTableViewDataSource: TitleSwitchTableViewCellResponder {
    func valueChanged(in item: BooleanItem?) {
        responder?.filtersChanged()
    }
}
