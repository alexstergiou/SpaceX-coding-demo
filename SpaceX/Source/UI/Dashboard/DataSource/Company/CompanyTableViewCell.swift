//
//  CompanyTableViewCell.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit
import SnapKit

final class CompanyTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with item: DashboardItem) {
        guard let companyItem = item as? DashboardCompanyItemViewModel else {
            titleLabel.text = nil
            
            return
        }
        let currencyCode: String = companyItem.numberFormatter.locale.currencyCode ?? ""
        let value: String = L.Dashboard.Company.description.format(companyItem.name, companyItem.founder, companyItem.foundedYear, companyItem.employees, companyItem.launchSites, currencyCode, companyItem.valuationFormattedString)
        titleLabel.text = value
    }
}

fileprivate extension CompanyTableViewCell {
    func setupViews() {
        contentView.addSubview(titleLabel)

        initializeConstraints()
    }

    func initializeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(16.0)
        }
    }
}
