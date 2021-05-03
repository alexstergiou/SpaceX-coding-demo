//
//  MockImageCache.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

@testable import SpaceX

final class MockImageCache: ImageCacheProtocol {

    var addedImageResponse: ImageResponse?
    func add(image: UIImage, url: URL) -> ImageResponse {
        let response: ImageResponse = ImageResponse(urlString: url.absoluteString, image: image)
        addedImageResponse = response
        return response
    }

    var imageForURLCalled: Bool = false
    func image(url: URL?) -> ImageResponse? {
        imageForURLCalled = true
        return addedImageResponse
    }
}
