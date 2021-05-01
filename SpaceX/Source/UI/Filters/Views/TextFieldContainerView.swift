//
//  TextFieldContainerView.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit
import SnapKit

final class TextFieldContainerView: UIView {
    lazy var textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.tintColor = .clear
        return textField
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(text: String?) {
        textField.text = text
    }

    func setup(inputView: UIView) {
        textField.inputView = inputView
    }
}

extension TextFieldContainerView {
    func setupViews() {
        addSubview(textField)

        initializeConstraints()
    }

    func initializeConstraints() {
        textField.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(CGFloat.m)
        }
    }
}
