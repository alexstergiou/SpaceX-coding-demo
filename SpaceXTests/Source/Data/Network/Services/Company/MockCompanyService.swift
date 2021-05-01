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

    var fetchCompanyInfoCalled: Bool = false
    func fetchCompanyInfo(completion: CompanyServiceCompletion?) {
        fetchCompanyInfoCalled = true

        if let company = company {
            completion?(Result.success(company))
        } else {
            completion?(Result.failure(error))
        }
    }
}
