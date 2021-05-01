//
//  StartEndDateTableViewCell.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit
import SnapKit

final class StartEndDateTableViewCell: UITableViewCell {
    var datesDataSource: DatePickerDataSourceProtocol?

    lazy var titleLabel: UILabel = {
        return UILabel()
    }()

    lazy var startDateContainerView: TextFieldContainerView = {
        return TextFieldContainerView()
    }()

    lazy var endDateContainerView: TextFieldContainerView = {
        return TextFieldContainerView()
    }()

    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0

        stackView.addArrangedSubview(startDateContainerView)
        stackView.addArrangedSubview(endDateContainerView)

        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(title: String, dataSource: DatePickerDataSourceProtocol) {
        titleLabel.text = title
        datesDataSource = dataSource
        dataSource.set(startTextField: startDateContainerView.textField)
        dataSource.set(endTextField: endDateContainerView.textField)
    }

    func update(title: String, start: String?, end: String?) {
        titleLabel.text = title
        startDateContainerView.update(text: start)
        endDateContainerView.update(text: end)
    }
}

extension StartEndDateTableViewCell {
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        
        initializeConstraints()
    }

    func initializeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(CGFloat.s)
        }

        stackView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(CGFloat.s)
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.s)
            make.height.equalTo(CGFloat.xxxl)
        }
    }
}
