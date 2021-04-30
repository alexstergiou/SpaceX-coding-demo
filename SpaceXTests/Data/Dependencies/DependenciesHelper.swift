//
//  DependenciesHelper.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

@testable import SpaceX

final class DependenciesHelper {
    let mockClient: MockNetworkClient
    let mockCompanyService: MockCompanyService

    convenience init() {
        self.init(mockClient: MockNetworkClient(),
                  mockCompanyService: MockCompanyService())
    }

    init(mockClient: MockNetworkClient, mockCompanyService: MockCompanyService) {
        self.mockClient = mockClient
        self.mockCompanyService = mockCompanyService
    }
}

extension DependenciesHelper {
    var dependencies: Dependencies {
        return Dependencies(client: mockClient,
                            companyService: mockCompanyService)
    }
}
