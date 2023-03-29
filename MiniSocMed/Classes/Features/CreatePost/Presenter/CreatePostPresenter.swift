//
//  CreatePostPresenter.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 28/03/23.
//

import Foundation
import UIKit

protocol CreatePostPresenter: AnyObject {
    var numberOfCharacters: Int { get }
    var images: [UIImage?] { get }
    var maximumCharacters: Int { get }
    
    func contentTextDidChange(_ contentText: String?)
    func addNewImage(from url: URL?)
    func addNewPost()
}

final class CreatePostPresenterImpl: CreatePostPresenter {
    
    var images: [UIImage?] = []
    var numberOfCharacters: Int = 0
    var maximumCharacters: Int = 200
    
    private let userModel: UserModel
    private let wireframe: CreatePostWireframe
    private weak var view: CreatePostView?
    private let interactor: CreatePostInteractor
    private weak var viewDelegate: CreatePostViewDelegate?
    
    private var contentText: String? = nil
    
    init(
        userModel: UserModel,
        wireframe: CreatePostWireframe,
        view: CreatePostView?,
        interactor: CreatePostInteractor,
        viewDelegate: CreatePostViewDelegate?
    ) {
        self.userModel = userModel
        self.wireframe = wireframe
        self.view = view
        self.interactor = interactor
        self.viewDelegate = viewDelegate
    }
    
    func addNewImage(from url: URL?) {
        guard let url = url else {
            view?.showError(message: "Path is invalid. Please try again")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            images.append(image)
            view?.onNewImagesAdded()
        } catch {
            view?.showError(message: error.localizedDescription)
        }
    }
    
    func contentTextDidChange(_ contentText: String?) {
        self.contentText = contentText
        
        guard contentText.safeUnwrap().count <= maximumCharacters else {
            return
        }
        
        numberOfCharacters = contentText.safeUnwrap().count
        view?.showCurrentNumberOfCharacters()
    }
    
    func addNewPost() {
        guard !userModel.userId.isEmpty else {
            view?.showError(message: "User not found")
            return
        }
        
        guard let contentText = contentText,
              !contentText.isEmpty else {
            view?.showError(message: "Content shouldn't be empty")
            return
        }
        
        let imageContents: [CommonImageContent] = images.map({
            return .image($0)
        })
        
        let postModel: PostModel = PostModel(
            user: userModel,
            postingDate: Date(),
            contentText: contentText,
            images: imageContents
        )
        
        viewDelegate?.createPostViewDidFinishAddingContent(model: postModel)
        wireframe.closePage()
    }
}
