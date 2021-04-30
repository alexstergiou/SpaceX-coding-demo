//
//  MockCompanyService.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

@testable import SpaceX

final class MockCompanyService: CompanyServiceProtocol {
    var company: Company?
    var error: Error = TestError.test

    func fetchCompanyInfo(completion: CompanyServiceCompletion?) {
        if let company = company {
            completion?(Result.success(company))
        } else {
            completion?(Result.failure(error))
        }
    }
}
