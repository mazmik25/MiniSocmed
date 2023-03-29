//
//  CommonCarouselView.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation
import UIKit

final class CommonCarouselView: CommonUIView {
    
    struct ViewParam {
        let itemSize: CGSize
        let itemsCount: Int
        let sectionInset: UIEdgeInsets
        let spacing: CGFloat
        
        init(
            itemSize: CGSize,
            itemsCount: Int,
            sectionInset: UIEdgeInsets = .zero,
            spacing: CGFloat = .zero
        ) {
            self.itemSize = itemSize
            self.itemsCount = itemsCount
            self.sectionInset = sectionInset
            self.spacing = spacing
        }
    }
    
    typealias CellForItemClosure = (UICollectionView, IndexPath) -> UICollectionViewCell
    typealias ReusableCellClosure<ViewType: UIView> = (CommonCollectionViewCell<ViewType>, IndexPath) -> Void
    
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = setupCollectionView()
    
    private let cellIdentifier = "CellIdentifier"
    private var cellForItem: CellForItemClosure?
    
    var isScrollable: Bool = true {
        didSet {
            collectionView.isScrollEnabled = isScrollable
        }
    }
    
    var isBouncable: Bool = true {
        didSet {
            collectionView.bounces = isBouncable
        }
    }
    
    private var itemsCount: Int = 0 {
        didSet {
            if itemsCount != oldValue {
                reloadData()
            }
        }
    }
    
    private var itemSize: CGSize = .zero {
        didSet {
            if itemSize != oldValue {
                invalidateIntrinsicContentSize()
                reloadData()
            }
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        var superSize = super.intrinsicContentSize
        superSize.height = itemSize.height
        superSize.height += flowLayout.sectionInset.top + flowLayout.sectionInset.bottom
        return superSize
    }
    
    override func commonInit() {
        addSubview(collectionView)
        collectionView.fillSuperView()
        
        collectionView.clipsToBounds = clipsToBounds
        collectionView.backgroundColor = backgroundColor
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.canCancelContentTouches = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )
        cellForItem = { [weak self] collectionView, indexPath in
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: (self?.cellIdentifier).safeUnwrap(),
                for: indexPath
            )
        }
        
        reloadData()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func register<ViewType: UIView>(
        _ type: ViewType.Type,
        reuseIdentifier: String? = nil,
        closure: ReusableCellClosure<ViewType>?
    ) {
        let identifier: String = reuseIdentifier.safeUnwrap(cellIdentifier)
        cellForItem = { [weak self] collectionView, indexPath in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: identifier,
                for: indexPath
            )
            if let self = self,
                let cell = cell as? CommonCollectionViewCell<ViewType> {
                closure?(cell, self.getDataSourceIndexPath(for: indexPath))
                return cell
            }
            return cell
        }
            
        collectionView.register(
            CommonCollectionViewCell<ViewType>.self,
            forCellWithReuseIdentifier: identifier
        )
    }
    
    func configure(param: CommonCarouselView.ViewParam) {
        itemSize = param.itemSize
        itemsCount = param.itemsCount
        
        if flowLayout.sectionInset != param.sectionInset {
            flowLayout.sectionInset = param.sectionInset
        }
        
        if flowLayout.minimumLineSpacing != param.spacing {
            flowLayout.minimumLineSpacing = param.spacing
            invalidateIntrinsicContentSize()
        }
        
        reloadData()
    }
    
    private func setupCollectionView() -> UICollectionView {
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return view
    }
    
    private func getDataSourceIndexPath(for indexPath: IndexPath) -> IndexPath {
        return IndexPath(
            item: indexPath.item % itemsCount,
            section: indexPath.section
        )
    }
}

extension CommonCarouselView: UICollectionViewDelegateFlowLayout,
                                UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return itemSize
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return itemsCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = cellForItem?(collectionView, indexPath) else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}
