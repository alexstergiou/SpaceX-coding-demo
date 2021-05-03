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

    func image(from response: ImageResponse?) -> UIImage?

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

    func image(from response: ImageResponse?) -> UIImage? {
        guard isValid(imageURLString: response?.urlString) else { return nil }
        return response?.image
    }

    func isValid(imageURLString: String?) -> Bool {
        guard let string = imageURLString else { return false }
        guard let url = imageURL else { return false }
        return string == url.absoluteString
    }

    var name: String {
        return launch.name
    }

    var date: Date {
        return launch.timestamp.date
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
        return success ? UIColor.success : UIColor.failure
    }

    var imageURL: URL? {
        guard let urlString = launch.links.patch?.small else { return nil }
        return URL(string: urlString)
    }

    func fetchImage(completion: ImageServiceCompletion?) {
        imageDataTask = imageService.fetchImage(url: imageURL, completion: { [weak self] result in
            self?.imageDataTask = nil

            switch result {
            case .success(let image):
                completion?(Result.success(image))
            case .failure(let error):
                let error = error as NSError
                if error.code == -999 { // Cancelled request
                    completion?(Result.success(nil))
                    return
                }
                completion?(Result.failure(error))
            }
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
        imageDataTask = nil
        detailsDataTask?.cancel()
        detailsDataTask = nil
    }
}
