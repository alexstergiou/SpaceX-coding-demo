//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit
import SnapKit

final class LaunchTableViewCell: UITableViewCell {
    lazy var missionValueView: KeyValueLabelView = {
        let view = KeyValueLabelView()
        view.update(key: NSLocalizedString("Mission:", comment: ""), value: nil)
        return view
    }()

    lazy var dateValueView: KeyValueLabelView = {
        let view = KeyValueLabelView()
        view.update(key: NSLocalizedString("Date/Time:", comment: ""), value: nil)
        return view
    }()

    lazy var rocketValueView: KeyValueLabelView = {
        let view = KeyValueLabelView()
        view.update(key: NSLocalizedString("Rocket:", comment: ""), value: nil)
        return view
    }()

    lazy var daysValueView: KeyValueLabelView = {
        let view = KeyValueLabelView()
        return view
    }()

    lazy var outcomeImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView()

        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 8.0

        return view
    }()

    lazy var patchImageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    weak var viewModel: DashboardLaunchItemViewModelProtocol?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with item: DashboardItem) {
        viewModel?.cancel()

        guard let viewModel = item as? DashboardLaunchItemViewModelProtocol else { return }
        self.viewModel = viewModel

        updateImage()
        updateRocketValue()
        missionValueView.update(value: viewModel.name)
        dateValueView.update(value: viewModel.formattedLaunchDate)
        daysValueView.update(key: viewModel.daysSinceLaunchTitle, value: "\(viewModel.daysSinceLaunch)")
        outcomeImageView.image = viewModel.outcomeImage
        outcomeImageView.tintColor = viewModel.outcomeImageColor
    }
}

fileprivate extension LaunchTableViewCell {
    func updateImage() {
        patchImageView.image = nil
        patchImageView.alpha = 0.0

        viewModel?.fetchImage { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let image):
                    self.set(image: image)
                case .failure:
                    self.set(image: UIImage(named: "logo"))
                }
            }
        }
    }

    func updateRocketValue() {
        rocketValueView.update(value: "--")

        viewModel?.fetchDetails(completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success:
                    self.rocketValueView.update(value: self.viewModel?.rocketDescription)
                case .failure:
                    break
                }
            }
        })
    }

    func set(image: UIImage?) {
        patchImageView.image = image
        UIView.animate(withDuration: 0.3) {
            self.patchImageView.alpha = 1.0
        }
    }

    func setupViews() {
        contentView.addSubview(patchImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(outcomeImageView)

        stackView.addArrangedSubview(missionValueView)
        stackView.addArrangedSubview(dateValueView)
        stackView.addArrangedSubview(rocketValueView)
        stackView.addArrangedSubview(daysValueView)

        initializeConstraints()
    }

    func initializeConstraints() {
        patchImageView.snp.makeConstraints { make in
            make.width.height.equalTo(48.0)
            make.leading.equalToSuperview().offset(8.0)
            make.top.equalToSuperview().inset(16.0)
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16.0)
            make.trailing.equalTo(outcomeImageView.snp.leading).offset(-8.0)
            make.leading.equalTo(patchImageView.snp.trailing).offset(8.0).priority(.high)
        }

        outcomeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32.0)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8.0)
        }
    }
}
