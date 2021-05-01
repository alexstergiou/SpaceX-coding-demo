//
//  MockImageCache.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

@testable import SpaceX

final class MockImageCache: ImageCacheProtocol {

    var addedImage: UIImage?
    func add(image: UIImage, url: URL) {
        addedImage = image
    }

    var imageForURLCalled: Bool = false
    func image(url: URL?) -> UIImage? {
        imageForURLCalled = true
        return addedImage
    }
}
