//
//  HomePresenter.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 28/03/23.
//

import Foundation

protocol HomePresenter: AnyObject {
    
    var homeContentViewParams: [HomeContentView.ViewParam] { get }
    
    func fetchPosts()
    
    func navigationBarTitleTapped()
    func updateSelectedUser(from name: String)
    
    func navigateToAddPost(viewDelegate: CreatePostViewDelegate?)
    func onNewPostAdded(_ model: PostModel)
    
    func getUserModel() -> UserModel?
}

final class HomePresenterImpl: HomePresenter {
    
    var homeContentViewParams: [HomeContentView.ViewParam] = []
    
    private let wireframe: HomeWireframe
    private weak var view: HomeView?
    private let interactor: HomeInteractor
    
    private var currentUserModel: UserModel?
    
    init(
        wireframe: HomeWireframe,
        view: HomeView?,
        interactor: HomeInteractor
    ) {
        self.wireframe = wireframe
        self.view = view
        self.interactor = interactor
        
        // by default, the first user is being selected
        currentUserModel = interactor.getUserModels().first
    }
    
    func fetchPosts() {
        homeContentViewParams = interactor.postModels
            .sorted(by: { $0.postingDate > $1.postingDate })
            .compactMap({ postModel in
                return HomeContentView.ViewParam(
                    avatarImage: postModel.user.avatarImage,
                    fullnameText: postModel.user.nameText,
                    usernameText: postModel.user.usernameText,
                    bodyText: postModel.contentText,
                    postImages: postModel.images
                )
            })
        view?.reloadData()
        view?.updateNavigationBarContent()
    }
    
    func navigationBarTitleTapped() {
        let names = interactor.getUserModels().compactMap({ $0.nameText })
        view?.showAvailableUsers(names)
    }
    
    func updateSelectedUser(from name: String) {
        let userModel = interactor.getUserModels().filter({ $0.nameText.elementsEqual(name) }).first
        currentUserModel = userModel
        view?.updateNavigationBarContent()
    }
    
    func navigateToAddPost(viewDelegate: CreatePostViewDelegate?) {
        guard let currentUserModel = currentUserModel else {
            return
        }

        wireframe.navigateToAddPost(withUser: currentUserModel, viewDelegate: viewDelegate)
    }
    
    func onNewPostAdded(_ model: PostModel) {
        interactor.addNewPost(model: model)
        fetchPosts()
    }
    
    func getUserModel() -> UserModel? {
        return currentUserModel
    }
}
