//
//  DashboardLaunchItem.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

protocol LaunchItem: DashboardItem, AnyObject {
    var launch: Launch { get }
}

protocol DashboardLaunchItemViewModelProtocol: LaunchItem {
    var name: String { get }
    var daysSinceLaunch: Int { get }
    var daysSinceLaunchTitle: String { get }
    var imageURL: URL? { get }
    var rocketDescription: String? { get }
    var formattedLaunchDate: String { get }
    var outcomeImage: UIImage? { get }
    var outcomeImageColor: UIColor? { get }

    func fetchImage(completion: ImageServiceCompletion?)
    func fetchDetails(completion: RocketDetailsCompletion?)

    func cancel()
}

final class DashboardLaunchItemViewModel: DashboardLaunchItemViewModelProtocol {
    let type: DashboardItemType = .launch
    let launch: Launch
    let imageService: ImageServiceProtocol
    let rocketService: RocketServiceProtocol
    let dateFormatter: DateFormatter

    var imageDataTask: URLSessionDataTaskProtocol?
    var detailsDataTask: URLSessionDataTaskProtocol?

    init(launch: Launch,
         imageService: ImageServiceProtocol,
         rocketService: RocketServiceProtocol,
         dateFormatter: DateFormatter) {
        self.launch = launch
        self.imageService = imageService
        self.rocketService = rocketService
        self.dateFormatter = dateFormatter
    }

    var name: String {
        return launch.name
    }

    var date: Date {
        return Date(timeIntervalSince1970: launch.timestamp)
    }

    var rocketDescription: String? {
        guard let rocket = launch.rocket else { return nil }
        return "\(rocket.name) - \(rocket.type)"
    }

    var formattedLaunchDate: String {
        return dateFormatter.string(from: date)
    }

    var daysSinceLaunch: Int {
        return Calendar.current.numberOfDaysBetween(from: date, to: Date()) ?? 0
    }

    var daysSinceLaunchTitle: String {
        let days: Int = daysSinceLaunch
        return days > 0 ? L.Dashboard.daysSinceNow : L.Dashboard.daysFromNow
    }

    var outcomeImage: UIImage? {
        guard let success = launch.success else { return nil }
        let imageName: String = success ? "checkmark" : "cross"
        return UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
    }

    var outcomeImageColor: UIColor? {
        guard let success = launch.success else { return nil }
        return success ? UIColor.green : UIColor.red
    }

    var imageURL: URL? {
        guard let urlString = launch.links.patch?.small else { return nil }
        return URL(string: urlString)
    }

    func fetchImage(completion: ImageServiceCompletion?) {
        imageDataTask = imageService.fetchImage(url: imageURL, completion: { [weak self] result in
            self?.imageDataTask = nil
            completion?(result)
        })
    }

    func fetchDetails(completion: RocketDetailsCompletion?) {
        if let rocket = launch.rocket {
            completion?(Result.success(rocket))
            return
        } else {
            detailsDataTask = rocketService.fetchRocketDetails(with: launch.rocketID, completion: { [weak self] result in
                self?.detailsDataTask = nil
                switch result {
                case .success(let rocket):
                    self?.launch.rocket = rocket
                    completion?(Result.success(rocket))
                case .failure(let error):
                    completion?(Result.failure(error))
                }
            })
        }
    }

    func cancel() {
        imageDataTask?.cancel()
        detailsDataTask?.cancel()
    }
}
