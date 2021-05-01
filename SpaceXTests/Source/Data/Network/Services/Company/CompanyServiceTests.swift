//
//  CompanyServiceTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import XCTest

@testable import SpaceX

final class CompanyServiceTests: XCTestCase {

    var subject: CompanyService!
    var mockClient: MockNetworkClient!

    override func setUpWithError() throws {
        mockClient = MockNetworkClient()
        subject = CompanyService(client: mockClient)
    }

    override func tearDownWithError() throws {
        subject = nil
        mockClient = nil
    }

    func testCompanyInfoFailure() {
        mockClient.result = Result.failure(TestError.test)

        let promise = expectation(description: "testCompanyInfoFailure")

        subject.fetchCompanyInfo { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                guard let testError = error as? TestError else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(testError, .test)
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testCompanyInfoDecodingFailure() {
        mockClient.result = Result.success(Data())

        let promise = expectation(description: "testCompanyInfoDecodingFailure")

        subject.fetchCompanyInfo { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                guard let _ = error as? DecodingError else {
                    XCTFail()
                    return
                }
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testCompanyInfoSuccess() {
        mockClient.result = Result.success(self.mockCompanyData)

        let promise = expectation(description: "testCompanyInfoSuccess")

        subject.fetchCompanyInfo { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

extension CompanyServiceTests {
    var mockCompanyData: Data {
        let encoder: JSONEncoder = JSONEncoder()
        return try! encoder.encode(mockCompany)
    }
    
    var mockCompany: Company {
        return Company(name: "name",
                       founder: "founder",
                       foundedYear: 2020,
                       employees: 10,
                       launchSites: 20,
                       valuation: 2000)
    }
}
