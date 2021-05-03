//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit
import SnapKit

final class LaunchTableViewCell: UITableViewCell {

    lazy var patchImageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView()

        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = CGFloat.xs

        return view
    }()

    lazy var missionValueView: KeyValueLabelView = {
        let view = KeyValueLabelView()
        view.update(key: L.Dashboard.mission, value: nil)
        return view
    }()

    lazy var dateValueView: KeyValueLabelView = {
        let view = KeyValueLabelView()
        view.update(key: L.Dashboard.dateTime, value: nil)
        return view
    }()

    lazy var rocketValueView: KeyValueLabelView = {
        let view = KeyValueLabelView()
        view.update(key: L.Dashboard.rocket, value: nil)
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

    weak var viewModel: DashboardLaunchItemViewModelProtocol?
    var imageCompletion: ImageServiceCompletion?
    var detailsCompletion: RocketDetailsCompletion?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

    func update(with item: DashboardItem) {
        reset()

        guard let viewModel = item as? DashboardLaunchItemViewModelProtocol else { return }
        self.viewModel = viewModel

        updateImage()
        updateRocketValue()

        updateValueViews(viewModel: viewModel)
        updateOutcomeImageView(viewModel: viewModel)
    }
}

//MARK: - View Setup -

fileprivate extension LaunchTableViewCell {
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
            make.width.height.equalTo(CGFloat.xxl)
            make.leading.equalToSuperview().offset(CGFloat.xs)
            make.top.equalToSuperview().inset(CGFloat.m)
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(CGFloat.m)
            make.trailing.equalTo(outcomeImageView.snp.leading).offset(-CGFloat.xs)
            make.leading.equalTo(patchImageView.snp.trailing).offset(CGFloat.xs).priority(.high)
        }

        outcomeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(CGFloat.xl)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-CGFloat.xs)
        }
    }
}

//MARK: - View Updates -

fileprivate extension LaunchTableViewCell {
    func updateValueViews(viewModel: DashboardLaunchItemViewModelProtocol) {
        missionValueView.update(value: viewModel.name)
        dateValueView.update(value: viewModel.formattedLaunchDate)
        daysValueView.update(key: viewModel.daysSinceLaunchTitle, value: "\(viewModel.daysSinceLaunch)")
    }

    func updateOutcomeImageView(viewModel: DashboardLaunchItemViewModelProtocol) {
        outcomeImageView.image = viewModel.outcomeImage
        outcomeImageView.tintColor = viewModel.outcomeImageColor
    }

    func reset() {
        viewModel?.cancel()
        imageCompletion = nil
        detailsCompletion = nil
        patchImageView.image = nil
        patchImageView.alpha = 0.0
    }

    func updateImage() {
        imageCompletion = { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                guard let viewModel = self.viewModel else { return }
                if let image = viewModel.image(from: response) {
                    self.set(image: image)
                }
            case .failure:
                self.set(image: UIImage(named: "logo"))
            }
            self.imageCompletion = nil
        }

        viewModel?.fetchImage(completion: imageCompletion)
    }

    func updateRocketValue() {
        rocketValueView.update(value: "--")

        detailsCompletion = { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.rocketValueView.update(value: self.viewModel?.rocketDescription)
            case .failure:
                break
            }
            self.detailsCompletion = nil
        }
        viewModel?.fetchDetails(completion: detailsCompletion)
    }

    func set(image: UIImage?) {
        patchImageView.image = image
        UIView.animate(withDuration: TimeInterval.animationDuration) {
            self.patchImageView.alpha = 1.0
        }
    }
}
