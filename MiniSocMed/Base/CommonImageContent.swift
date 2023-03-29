//
//  CommonImageContent.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 27/03/23.
//

import Foundation
import UIKit

typealias CommonImageContentClosure = (Result<UIImage, CommonImageContentError>) -> Void

enum CommonImageContentError: Error {
    case assetNotFound
    case invalidUrl
    case imageNotFound
    case fileNotExist
    case invalidPath
    case unknown(_ error: Error)
}

enum CommonImageContent {
    case network(url: URL?)
    case asset(name: String)
    case localAsset(path: String)
    case image(_ image: UIImage?)
}

extension CommonImageContent {
    func apply(to imageView: UIImageView, completion: CommonImageContentClosure? = nil) {
        switch self {
        case .image(let image):
            imageView.image = image
        case .network(let url):
            guard let url = url else {
                completion?(.failure(.invalidUrl))
                return
            }
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    guard let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            completion?(.failure(.imageNotFound))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        imageView.image = image
                        completion?(.success(image))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(.unknown(error)))
                    }
                }
            }
        case .asset(let named):
            guard let image: UIImage = UIImage(named: named) else {
                completion?(.failure(.assetNotFound))
                return
            }
            imageView.image = image
        case .localAsset(let path):
            guard FileManager.default.fileExists(atPath: path) else {
                completion?(.failure(.fileNotExist))
                return
            }
            
            guard let url = URL(string: path) else {
                completion?(.failure(.invalidUrl))
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    guard let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            completion?(.failure(.imageNotFound))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        imageView.image = image
                        completion?(.success(image))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(.unknown(error)))
                    }
                }
            }
        }
    }
}
