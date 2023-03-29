//
//  HomeWireframe.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 28/03/23.
//

import Foundation
import UIKit

protocol HomeWireframe: CommonWireframe {
    func navigateToAddPost(withUser model: UserModel, viewDelegate: CreatePostViewDelegate?)
}

final class HomeWireframeImpl: HomeWireframe {
    var rootController: UIViewController? = nil
    
    init() {
        let controller = HomeViewController()
        
        let interactor = HomeInteractorImpl()
        let presenter = HomePresenterImpl(
            wireframe: self,
            view: controller,
            interactor: interactor
        )
        
        controller.presenter = presenter
        let rootController = UINavigationController(
            rootViewController: controller
        ) 
        
        self.rootController = rootController
    }
    
    func navigateToAddPost(withUser model: UserModel, viewDelegate: CreatePostViewDelegate?) {
        let wireframe = CreatePostWireframeImpl(userModel: model, viewDelegate: viewDelegate)
        navigationController?.pushWireframe(wireframe)
    }
}
