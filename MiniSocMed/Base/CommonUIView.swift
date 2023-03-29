//
//  CommonUIView.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation
import UIKit

class CommonUIView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
        
    }
}
