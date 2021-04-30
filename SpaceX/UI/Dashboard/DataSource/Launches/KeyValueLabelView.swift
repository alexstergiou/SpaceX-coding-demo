//
//  KeyValueLabelView.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit
import SnapKit

final class KeyValueLabelView: UIView {
    lazy var keyLabel: UILabel = {
        let label: UILabel = UILabel()

        return label
    }()

    lazy var valueLabel: UILabel = {
        let label: UILabel = UILabel()

        label.textAlignment = .right

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(value: String?) {
        valueLabel.text = value
    }

    func update(key: String, value: String?) {
        keyLabel.text = key
        update(value: value)
    }
}

extension KeyValueLabelView {
    func setupViews() {
        addSubview(keyLabel)
        addSubview(valueLabel)

        initializeConstraints()
    }

    func initializeConstraints() {
        keyLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        keyLabel.sizeToFit()

        valueLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(keyLabel.snp.trailing)
        }
    }
}
