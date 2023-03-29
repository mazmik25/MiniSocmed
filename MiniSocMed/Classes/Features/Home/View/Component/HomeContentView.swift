//
//  HomeContentView.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation
import UIKit

final class HomeContentView: CommonUIView {
    
    struct ViewParam {
        let avatarImage: CommonImageContent
        let fullnameText: String?
        let usernameText: String?
        let bodyText: String?
        let postImages: [CommonImageContent]
    }
    
    private let imageView: UIImageView = UIImageView()
    private let fullnameLabel: UILabel = UILabel()
    private let usernameLabel: UILabel = UILabel()
    private let bodyTextLabel: UILabel = UILabel()
    private let carouselView: CommonCarouselView = CommonCarouselView()
    
    private var bodyTextLabelBottomConstraintToSuperView: NSLayoutConstraint?
    
    private var carouselViewTopConstraintToBodyTextLabel: NSLayoutConstraint?
    private var carouselViewHeightConstraint: NSLayoutConstraint?
    private var carouselViewBottomConstraintToSuperView: NSLayoutConstraint?
    
    private var viewParam: HomeContentView.ViewParam?
    
    override func commonInit() {
        addSubview(imageView)
        addSubview(fullnameLabel)
        addSubview(usernameLabel)
        addSubview(bodyTextLabel)
        addSubview(carouselView)
        
        setupImageView()
        setupFullnameLabel()
        setupUsernameLabel()
        setupBodyTextLabel()
        setupCarouselView()
    }
    
    func configure(viewParam: HomeContentView.ViewParam) {
        self.viewParam = viewParam
        
        viewParam.avatarImage.apply(to: imageView)
        fullnameLabel.text = viewParam.fullnameText
        usernameLabel.text = viewParam.usernameText
        bodyTextLabel.text = viewParam.bodyText
        
        carouselView.configure(
            param: CommonCarouselView.ViewParam(
                itemSize: CGSize(width: 120, height: 90),
                itemsCount: viewParam.postImages.count,
                sectionInset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 20),
                spacing: 8
            )
        )
        carouselView.isScrollable = !viewParam.postImages.isEmpty
        
        hidesImagePreviews(viewParam.postImages.isEmpty)
    }
    
    private func setupImageView() {
        imageView.pinSize(
            CGSize(
                width: 56,
                height: 56
            )
        )
        imageView.pinTopToSuperView(side: .top, constant: 10)
        imageView.pinLeadingToSuperView(side: .left, constant: 20)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 28
    }
    
    private func setupFullnameLabel() {
        fullnameLabel.pinLeading(to: .right, of: imageView, constant: 12)
        fullnameLabel.pinTopToSuperView(side: .top, constant: 14)
        
        fullnameLabel.setContentHuggingPriority(.required, for: .vertical)
        fullnameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        fullnameLabel.textColor = .black
        fullnameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        fullnameLabel.numberOfLines = 1
    }
    
    private func setupUsernameLabel() {
        usernameLabel.pinLeading(to: .right, of: fullnameLabel, constant: 8)
        usernameLabel.pinTrailingToSuperView(side: .right, constant: 20, relation: .less)
        usernameLabel.pinTopToSuperView(side: .top, constant: 14)
        
        usernameLabel.setContentHuggingPriority(.required, for: .vertical)
        usernameLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        usernameLabel.textColor = .darkGray
        usernameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        usernameLabel.numberOfLines = 1
    }
    
    private func setupBodyTextLabel() {
        bodyTextLabel.pinLeading(to: .right, of: imageView, constant: 12)
        bodyTextLabel.pinTrailingToSuperView(side: .right, constant: 20)
        bodyTextLabel.pinTop(to: .bottom, of: fullnameLabel, constant: 14)
        bodyTextLabelBottomConstraintToSuperView = bodyTextLabel.pinBottomToSuperView(side: .bottom, constant: 12)
        
        bodyTextLabel.setContentHuggingPriority(.required, for: .vertical)
        bodyTextLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        bodyTextLabel.textColor = .black
        bodyTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        bodyTextLabel.numberOfLines = 0
    }
    
    private func setupCarouselView() {
        carouselView.pinLeading(to: .right, of: imageView)
        carouselView.pinTrailingToSuperView(side: .right)
        
        carouselViewTopConstraintToBodyTextLabel = carouselView.pinTop(to: .bottom, of: bodyTextLabel)
        carouselViewHeightConstraint = carouselView.pinHeight(constant: 98)
        carouselViewBottomConstraintToSuperView = carouselView.pinBottomToSuperView(side: .bottom, constant: 12)
        
        carouselViewTopConstraintToBodyTextLabel?.isActive = false
        carouselViewHeightConstraint?.isActive = false
        carouselViewBottomConstraintToSuperView?.isActive = false
        
        carouselView.register(
            HomeContentImagePreviewView.self,
            reuseIdentifier: HomeContentImagePreviewView.className()
        ) { [weak self] cell, indexPath in
            guard let self = self,
                  let content = self.viewParam?.postImages[safe: indexPath.item] else { return }
            
            cell.view.configure(content: content)
        }
    }
    
    private func hidesImagePreviews(_ isHidden: Bool) {
        carouselView.isHidden = isHidden
        
        bodyTextLabelBottomConstraintToSuperView?.isActive = isHidden
        carouselViewTopConstraintToBodyTextLabel?.isActive = !isHidden
        carouselViewHeightConstraint?.isActive = !isHidden
        carouselViewBottomConstraintToSuperView?.isActive = !isHidden
    }
}
