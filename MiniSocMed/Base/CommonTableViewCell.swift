//
//  CommonTableViewCell.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation
import UIKit

final class CommonTableViewCell<View: UIView>: UITableViewCell {
    
    let view: View = View()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
