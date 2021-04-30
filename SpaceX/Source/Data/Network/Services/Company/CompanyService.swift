//
//  CompanyService.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

typealias CompanyServiceCompletion = (_ result: Result<Company, Error>) -> Void

protocol CompanyServiceProtocol {
    func fetchCompanyInfo(completion: CompanyServiceCompletion?)
}

final class CompanyService: CompanyServiceProtocol {
    let client: NetworkClientProtocol

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    func fetchCompanyInfo(completion: CompanyServiceCompletion?) {
        let endpoint: CompanyEndpoint = .company
        guard let request = endpoint.request else {
            completion?(Result.failure(ServiceError.invalidRequest))
            return
        }

        client.execute(request: request) { result in
            switch result {
            case .success(let data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let company: Company = try decoder.decode(Company.self, from: data)
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
