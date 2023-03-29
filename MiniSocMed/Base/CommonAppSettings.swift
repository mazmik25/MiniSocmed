//
//  CommonAppSettings.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation
import UIKit

struct CommonAppSettings {
    private static let safeAreaInsets: UIEdgeInsets = (
        UIApplication.shared.windows.first?.safeAreaInsets
    ).safeUnwrap(.zero)
    
    static let topSafeAreaInset: CGFloat = safeAreaInsets.top
    static let bottomSafeAreaInset: CGFloat = safeAreaInsets.bottom
}
