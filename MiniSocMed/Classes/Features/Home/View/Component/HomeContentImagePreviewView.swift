//
//  HomeContentImagePreviewView.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 27/03/23.
//

import Foundation
import UIKit

final class HomeContentImagePreviewView: CommonUIView {
    
    private let imageView: UIImageView = UIImageView()
    
    override func commonInit() {
        addSubview(imageView)
        imageView.fillSuperView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }
    
    func configure(content: CommonImageContent) {
        content.apply(to: imageView) { [weak self] result in
            switch result {
            case .success:
                return
            case .failure(let error):
                switch error {
                case .assetNotFound,
                        .invalidUrl,
                        .imageNotFound,
                        .fileNotExist,
                        .invalidPath:
                    let brokenImage = UIImage(named: "broken-image")
                    self?.imageView.image = brokenImage
                    return
                case .unknown:
                    self?.imageView.image = nil
                    self?.imageView.backgroundColor = .darkGray
                    return
                }
            }
        }
    }
}
