//
//  CreatePostWireframe.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 28/03/23.
//

import Foundation
import UIKit

protocol CreatePostWireframe: CommonWireframe {
    func closePage()
}

final class CreatePostWireframeImpl: CreatePostWireframe {
    var rootController: UIViewController?
    
    init(userModel: UserModel, viewDelegate: CreatePostViewDelegate?) {
        let rootController = CreatePostViewController()
        
        let interactor = CreatePostInteractorImpl()
        let presenter = CreatePostPresenterImpl(
            userModel: userModel,
            wireframe: self,
            view: rootController,
            interactor: interactor,
            viewDelegate: viewDelegate
        )
        
        rootController.presenter = presenter
        self.rootController = rootController
    }
    
    func closePage() {
        navigationController?.popToRootViewController(animated: true)
    }
}
