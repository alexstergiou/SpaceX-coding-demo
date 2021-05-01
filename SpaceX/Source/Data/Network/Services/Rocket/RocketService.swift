//
//  RocketService.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

typealias RocketDetailsCompletion = (_ result: Result<Rocket, Error>) -> Void

protocol RocketServiceProtocol {
    @discardableResult func fetchRocketDetails(with rocketIdentifier: String, completion: RocketDetailsCompletion?) -> URLSessionDataTaskProtocol?
}

final class RocketService: RocketServiceProtocol {
    let client: NetworkClientProtocol

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    @discardableResult func fetchRocketDetails(with rocketIdentifier: String, completion: RocketDetailsCompletion?) -> URLSessionDataTaskProtocol? {
        let endpoint: RocketEndpoint = .details(rocketIdentifier)
        guard let request = endpoint.request else {
            completion?(Result.failure(ServiceError.invalidRequest))
            return nil
        }

        return client.execute(request: request) { result in
            switch result {
            case .success(let data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let company: Rocket = try decoder.decode(Rocket.self, from: data)
                    completion?(Result.success(company))
                } catch {
                    completion?(Result.failure(error))
                }
                break
            case .failure(let error):
                completion?(Result.failure(error))
            }
        }
    }
}
