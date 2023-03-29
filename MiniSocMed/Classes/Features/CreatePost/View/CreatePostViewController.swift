//
//  CreatePostViewController.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 27/03/23.
//

import Foundation
import UIKit

protocol CreatePostView: AnyObject {
    func onNewImagesAdded()
    func showError(message: String)
    func showCurrentNumberOfCharacters()
}

protocol CreatePostViewDelegate: AnyObject {
    func createPostViewDidFinishAddingContent(model: PostModel)
}

final class CreatePostViewController: UIViewController,
                                      CreatePostView {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    
    private lazy var pickerController: UIImagePickerController = createImagePickerController()
    
    private lazy var textView: UITextView = createTextView()
    private lazy var numberCharactersLabel: UILabel = createNumberCharactersLabel()
    private lazy var carouselView: CommonCarouselView = CommonCarouselView()
    
    var presenter: CreatePostPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    func showCurrentNumberOfCharacters() {
        numberCharactersLabel.text = "\(presenter.numberOfCharacters)/\(presenter.maximumCharacters)"
    }
    
    func onNewImagesAdded() {
        pickerController.dismiss(animated: true) {
            self.reloadCarouselView()
        }
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in
                    alertController.dismiss(animated: true)
                }
            )
        )
        present(alertController, animated: true)
    }
    
    private func setupNavigationBar() {
        title = "Add Post"
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .organize,
                target: self,
                action: #selector(onAddMediaTapped)
            ),
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(onAddNewPost)
            )
        ]
    }
    
    private func setupView() {
        setupScrollView()
        setupContainerView()
    }
    
    private func setupScrollView() {
        scrollView.contentInset.top = CommonAppSettings.topSafeAreaInset
        scrollView.contentInset.bottom = CommonAppSettings.bottomSafeAreaInset
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupContainerView() {
        containerView.addSubview(textView)
        containerView.addSubview(numberCharactersLabel)
        containerView.addSubview(carouselView)
        
        setupTextView()
        setupNumberCharactersLabel()
        setupCarouselView()
    }
    
    private func setupTextView() {
        textView.pinTopToSuperView(side: .top, constant: 16)
        textView.pinTrailingToSuperView(side: .right, constant: 20)
        textView.pinLeadingToSuperView(side: .left, constant: 20)
        textView.pinHeight(constant: 120)
        textView.delegate = self
    }
    
    private func setupNumberCharactersLabel() {
        numberCharactersLabel.pinTop(to: .bottom, of: textView, constant: 8)
        numberCharactersLabel.pinTrailingToSuperView(side: .right, constant: 20)
        numberCharactersLabel.pinLeadingToSuperView(side: .left, constant: 20)
        showCurrentNumberOfCharacters()
    }
    
    private func setupCarouselView() {
        carouselView.pinLeadingToSuperView(side: .left)
        carouselView.pinTrailingToSuperView(side: .right)
        carouselView.pinTop(to: .bottom, of: numberCharactersLabel, constant: 20)
        carouselView.pinHeight(constant: 98)
        carouselView.pinBottomToSuperView(side: .bottom, constant: 20)
        
        carouselView.register(
            HomeContentImagePreviewView.self,
            reuseIdentifier: HomeContentImagePreviewView.className()
        ) { [weak self] cell, indexPath in
            guard let self = self,
                  let content = self.presenter.images[safe: indexPath.item] else { return }
            
            cell.view.configure(
                content: .image(content)
            )
        }
        
        reloadCarouselView()
    }
    
    private func reloadCarouselView() {
        carouselView.configure(
            param: CommonCarouselView.ViewParam(
                itemSize: CGSize(width: 120, height: 90),
                itemsCount: presenter.images.count,
                sectionInset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 20),
                spacing: 8
            )
        )
        carouselView.isScrollable = !presenter.images.isEmpty
        carouselView.reloadData()
    }
    
    private func createTextView() -> UITextView {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .black
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        view.isEditable = true
        view.isSelectable = true
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        return view
    }
    
    private func createNumberCharactersLabel() -> UILabel {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .darkGray
        view.numberOfLines = 1
        view.textAlignment = .right
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }
    
    private func createImagePickerController() -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        return pickerController
    }
    
    @objc
    private func onAddMediaTapped() {
        let alertController = UIAlertController(title: "Choose the media", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(
            UIAlertAction(
                title: "Photo",
                style: .default,
                handler: { _ in
                    self.handleImagePicker(for: .photoLibrary)
                }
            )
        )
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func onAddNewPost() {
        presenter.addNewPost()
    }
    
    private func handleImagePicker(for sourceType: UIImagePickerController.SourceType) {
        pickerController.sourceType = sourceType
        present(pickerController, animated: true)
    }
}

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.contentTextDidChange(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText: String = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= presenter.maximumCharacters
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let imageUrl: URL? = info[.imageURL] as? URL
        presenter.addNewImage(from: imageUrl)
    }
}
