//
//  CommonWireframe.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 28/03/23.
//

import Foundation
import UIKit

protocol CommonWireframe: AnyObject {
    var rootController: UIViewController? { get }
    var navigationController: UINavigationController? { get }
}

extension CommonWireframe {
    var navigationController: UINavigationController? {
        if let navigationController = rootController as? UINavigationController {
            return navigationController
        }
        return rootController?.navigationController
    }
}
