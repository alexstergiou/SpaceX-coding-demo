//
//  DashboardCompanyItem.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

struct DashboardCompanyItemViewModel: DashboardItem {
    let company: Company

    var name: String {
        return company.name
    }

    var founder: String {
        return company.founder
    }

    var foundedYear: Int {
        return company.foundedYear
    }

    var employees: Int {
        return company.employees
    }

    var launchSites: Int {
        return company.launchSites
    }

    var valuation: Double {
        return company.valuation
    }

    let numberFormatter: NumberFormatter

    init(company: Company) {
        self.company = company
        
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency

        self.numberFormatter = numberFormatter
    }

    var valuationFormattedString: String {
        let value: NSNumber = NSNumber(value: valuation)
        return numberFormatter.string(from: value) ?? ""
    }
}
