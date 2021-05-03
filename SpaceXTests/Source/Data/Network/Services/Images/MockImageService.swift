//
//  MockImageService.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

@testable import SpaceX

final class MockImageService: ImageServiceProtocol {
    
    var image: UIImage?
    var error: Error = TestError.test
    var dataTask: MockURLSessionDataTask?
    var urlString: String = "https://www.spacex.com"

    var fetchImageCalled: Bool = false
    func fetchImage(url: URL?, completion: ImageServiceCompletion?) -> URLSessionDataTaskProtocol? {
        fetchImageCalled = true

        if let image = image {
            completion?(Result.success(ImageResponse(urlString: urlString, image: image)))
        } else {
            completion?(Result.failure(error))
        }
        return dataTask
    }
}
