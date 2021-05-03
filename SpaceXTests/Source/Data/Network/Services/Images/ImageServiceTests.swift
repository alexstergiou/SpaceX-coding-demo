//
//  ImageServiceTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit
import XCTest

@testable import SpaceX

final class ImageServiceTests: XCTestCase {

    var subject: ImageService!
    var dependenciesHelper: DependenciesHelper!

    override func setUpWithError() throws {
        dependenciesHelper = DependenciesHelper()
        subject = ImageService(client: dependenciesHelper.mockClient,
                               cache: dependenciesHelper.mockImageCache)
    }

    override func tearDownWithError() throws {
        subject = nil
        dependenciesHelper = nil
    }

    func testImageFetchFailure() {
        dependenciesHelper.mockClient.result = Result.failure(TestError.test)

        let promise = expectation(description: "testImageFetchFailure")

        subject.fetchImage(url: URL(string: "https://www.spacex.com")!) { result in
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

        waitForExpectations(timeout: expectationTimeout, handler: nil)
    }

    func testImageFetchDataFailure() {
        dependenciesHelper.mockClient.result = Result.success(Data())

        let promise = expectation(description: "testImageFetchDataFailure")

        subject.fetchImage(url: URL(string: "https://www.spacex.com")!) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                guard let serviceError = error as? ServiceError else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(serviceError, .invalidData)
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: expectationTimeout, handler: nil)
    }

    func testImageFetchSuccess() {
        dependenciesHelper.mockClient.result = Result.success(self.mockImageData)

        let promise = expectation(description: "testImageFetchSuccess")

        subject.fetchImage(url: URL(string: "https://www.spacex.com")!) { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: expectationTimeout, handler: nil)
    }

    func testImageFetchCachedSuccess() {
        dependenciesHelper.mockClient.result = Result.success(Data())
        let image: UIImage = mockImage
        let url: URL = URL(string: "https://www.spacex.com")!
        dependenciesHelper.mockImageCache.addedImageResponse = ImageResponse(urlString: url.absoluteString, image: image)

        let promise = expectation(description: "testImageFetchSuccess")

        subject.fetchImage(url: url) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response?.image.pngData()?.count, image.pngData()?.count)
                XCTAssertTrue(self.dependenciesHelper.mockImageCache.imageForURLCalled)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: expectationTimeout, handler: nil)
    }
}

extension ImageServiceTests {
    var mockImageData: Data {
        return mockImage.pngData()!
    }

    var mockImage: UIImage {
        return UIImage(named: "logo")!
    }
}
