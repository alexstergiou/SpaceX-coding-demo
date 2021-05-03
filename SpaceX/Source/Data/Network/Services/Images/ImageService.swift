//
//  ImageService.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

typealias ImageServiceCompletion = ( _ result: Result<ImageResponse?, Error>) -> Void

protocol ImageServiceProtocol {
    @discardableResult func fetchImage(url: URL?, completion: ImageServiceCompletion?) -> URLSessionDataTaskProtocol?
}

final class ImageService: ImageServiceProtocol {
    let client: NetworkClientProtocol
    let cache: ImageCacheProtocol

    init(client: NetworkClientProtocol, cache: ImageCacheProtocol) {
        self.client = client
        self.cache = cache
    }

    @discardableResult func fetchImage(url: URL?, completion: ImageServiceCompletion?) -> URLSessionDataTaskProtocol? {
        guard let url = url else {
            completion?(Result.failure(ServiceError.invalidURL))
            return nil
        }

        if let response = cache.image(url: url) {
            completion?(Result.success(response))

            return nil

        } else {
            let request: URLRequest = URLRequest(url: url)

            return client.execute(request: request) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    switch result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            completion?(Result.failure(ServiceError.invalidData))
                            return
                        }
                        let response: ImageResponse = self.cache.add(image: image, url: url)
                        completion?(Result.success(response))
                    case .failure(let error):
                        completion?(Result.failure(error))
                    }
                }
            }
        }
    }
}
