//
//  LaunchesService.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

typealias LaunchesServiceCompletion = (_ result: Result<[Launch], Error>) -> Void

protocol LaunchesServiceProtocol {
    func fetchLaunches(completion: LaunchesServiceCompletion?)
}

final class LaunchesService: LaunchesServiceProtocol {
    let client: NetworkClientProtocol

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    func fetchLaunches(completion: LaunchesServiceCompletion?) {
        let endpoint: LaunchesEndpoint = .launches
        guard let request = endpoint.request else {
            completion?(Result.failure(ServiceError.invalidRequest))
            return
        }

        client.execute(request: request) { result in
            switch result {
            case .success(let data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let launches: [Launch] = try decoder.decode([Launch].self, from: data)
                    completion?(Result.success(launches))
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
