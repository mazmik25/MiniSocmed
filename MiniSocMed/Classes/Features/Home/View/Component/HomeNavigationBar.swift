//
//  HomeNavigationBar.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import UIKit

protocol HomeNavigationBarDelegate: AnyObject {
    func homeNavigationBarDidTapTitle(_ navBar: HomeNavigationBar)
    func homeNavigationBarDidTapAddContent(_ navBar: HomeNavigationBar)
}

final class HomeNavigationBar: CommonUIView {
    
    // MARK: Property
    
    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let button: UIButton = UIButton()
    private let topSafeArea: CGFloat = CommonAppSettings.topSafeAreaInset
    
    // MARK: Public property
    var currentTitle: String? {
        didSet {
            titleLabel.text = currentTitle
        }
    }
    
    var currentAvatarImage: CommonImageContent? {
        didSet {
            currentAvatarImage?.apply(to: imageView)
        }
    }
    
    weak var delegate: HomeNavigationBarDelegate?
    
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        return CGSize(
            width: superContentSize.width,
            height: 44 + topSafeArea
        )
    }
    
    override func commonInit() {
        backgroundColor = .systemBlue
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(button)
        
        setupImageView()
        setupTitleLabel()
        setupAddButton()
    }
    
    // MARK: Private method
    
    private func setupImageView() {
        imageView.pinTopToSuperView(side: .top, constant: topSafeArea)
        imageView.pinLeadingToSuperView(side: .left, constant: 20)
        imageView.pinSize(
            CGSize(width: 44, height: 44)
        )
        imageView.pinBottomToSuperView(side: .bottom, constant: 8)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
    }
    
    private func setupTitleLabel() {
        titleLabel.pinTopToSuperView(side: .top, constant: topSafeArea)
        titleLabel.pinLeading(to: .right, of: imageView)
        titleLabel.pinTrailing(to: .left, of: button)
        titleLabel.pinBottomToSuperView(side: .bottom)
        titleLabel.text = currentTitle
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        
        // Setup Tap Gesture
        titleLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(callOnTapTitle)
        )
        titleLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupAddButton() {
        button.pinTopToSuperView(side: .top, constant: topSafeArea)
        button.pinTrailingToSuperView(side: .right, constant: 8)
        button.pinWidth(constant: 44)
        button.pinBottomToSuperView(side: .bottom)
        
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
    }
    
    @objc
    private func callOnTapTitle() {
        delegate?.homeNavigationBarDidTapTitle(self)
    }
    
    @objc
    private func onButtonAddTapped() {
        delegate?.homeNavigationBarDidTapAddContent(self)
    }
}
