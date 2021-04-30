//
//  DashboardCompanySectionViewModel.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

protocol DashboardCompanySectionViewModelProtocol: DashboardSection {
    var numberOfItems: Int { get }

    func update(with company: Company)
}

final class DashboardCompanySectionViewModel: DashboardSection {

    let title: String = L.Dashboard.Company.title
    let type: DashboardSectionType = .company
    var items: [DashboardItem] = []

    func update(with company: Company) {
        items = [DashboardCompanyItemViewModel(company: company)]
    }

    var numberOfItems: Int {
        return items.count
    }
}
