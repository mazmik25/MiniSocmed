//
//  UINavigationController+Wireframe.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 28/03/23.
//

import Foundation
import UIKit

extension UINavigationController {
    func pushWireframe(_ wireframe: CommonWireframe) {
        guard let rootController = wireframe.rootController else {
            return
        }
        
        pushViewController(rootController, animated: true)
    }
    
    func presentWireframe(
        _ wireframe: CommonWireframe,
        completion: VoidClosure? = nil
    ) {
        guard let rootController = wireframe.rootController else {
            return
        }
        
        present(rootController, animated: true, completion: completion)
    }
}
