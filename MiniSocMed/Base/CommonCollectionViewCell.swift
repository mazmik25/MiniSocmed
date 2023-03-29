//
//  CommonCollectionViewCell.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation
import UIKit

final class CommonCollectionViewCell<View: UIView>: UICollectionViewCell {
    
    let view: View = View()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(view)
        view.fillSuperView()
    }
}
