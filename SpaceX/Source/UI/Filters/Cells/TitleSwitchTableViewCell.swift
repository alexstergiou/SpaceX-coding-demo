//
//  TitleSwitchTableViewCell.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit
import SnapKit

protocol TitleSwitchTableViewCellResponder: AnyObject {
    func valueChanged()
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
            make.trailing.equalToSuperview().offset(-CGFloat.s)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(CGFloat.m)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat.s)
            make.trailing.equalTo(valueSwitch.snp.leading).offset(-CGFloat.s)
        }
    }

    @objc func valueChanged() {
        item?.value.toggle()
        responder?.valueChanged()
    }
}
