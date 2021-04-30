//
//  TitleSwitchTableViewCell.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit
import SnapKit

protocol TitleSwitchTableViewCellResponder: AnyObject {
    func valueChanged(in item: BooleanItem?)
}

final class TitleSwitchTableViewCell: UITableViewCell {
    var item: BooleanItem?
    weak var responder: TitleSwitchTableViewCellResponder?

    lazy var titleLabel: UILabel = {
        return UILabel()
    }()

    lazy var valueSwitch: UISwitch = {
        let valueSwitch: UISwitch = UISwitch()
        valueSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        return valueSwitch
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with item: BooleanItem, responder: TitleSwitchTableViewCellResponder?) {
        self.responder = responder
        self.item = item
        titleLabel.text = item.title
        valueSwitch.setOn(item.value, animated: true)
    }
}

extension TitleSwitchTableViewCell {
    func setupViews() {
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(valueSwitch)

        initializeConstraints()
    }

    func initializeConstraints() {
        valueSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8.0)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(16.0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalTo(valueSwitch.snp.leading).offset(-8.0)
        }
    }

    @objc func valueChanged() {
        item?.value.toggle()
        responder?.valueChanged(in: item)
    }
}
