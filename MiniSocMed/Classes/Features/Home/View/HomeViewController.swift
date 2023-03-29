//
//  HomeViewController.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import UIKit

protocol HomeView: AnyObject {
    func reloadData()
    func updateNavigationBarContent()
    func showAvailableUsers(_ names: [String])
}

final class HomeViewController: UIViewController,
                                HomeView {
    
    private lazy var navBar: HomeNavigationBar = setupNavigationBar()
    private lazy var tableView: UITableView = setupTableView()
    
    var presenter: HomePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateNavigationBarContent() {
        let userModel = presenter.getUserModel()
        navBar.currentTitle = userModel?.nameText
        navBar.currentAvatarImage = userModel?.avatarImage
    }
    
    func showAvailableUsers(_ names: [String]) {
        let alertController = UIAlertController(title: "Choose the user", message: nil, preferredStyle: .actionSheet)
        names.forEach({ name in
            guard !name.isEmpty else { return }
            let action = UIAlertAction(
                title: name,
                style: .default,
                handler: { _ in
                    self.presenter.updateSelectedUser(from: name)
                }
            )
            alertController.addAction(action)
        })
        present(alertController, animated: true)
    }
    
    // MARK: Private method
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(navBar)
        view.addSubview(tableView)
        
        setupNavigationBarConstraints()
        setupTableViewConstraints()
    }
    
    private func setupNavigationBarConstraints() {
        navBar.pinTopToSuperView(side: .top)
        navBar.pinLeadingToSuperView(side: .left)
        navBar.pinTrailingToSuperView(side: .right)
    }
    
    private func setupTableViewConstraints() {
        tableView.pinTop(to: .bottom, of: navBar)
        tableView.pinLeadingToSuperView(side: .left)
        tableView.pinTrailingToSuperView(side: .right)
        tableView.pinBottomToSuperView(side: .bottom)
    }

    private func setupNavigationBar() -> HomeNavigationBar {
        let navBar = HomeNavigationBar()
        navBar.delegate = self
        
        return navBar
    }
    
    private func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset.bottom = CommonAppSettings.bottomSafeAreaInset
        tableView.register(
            CommonTableViewCell<HomeContentView>.self,
            forCellReuseIdentifier: HomeContentView.className()
        )
        return tableView
    }
}

// MARK: HomeNavigationBarDelegate
extension HomeViewController: HomeNavigationBarDelegate {
    func homeNavigationBarDidTapTitle(_ navBar: HomeNavigationBar) {
        presenter.navigationBarTitleTapped()
    }
    
    func homeNavigationBarDidTapAddContent(_ navBar: HomeNavigationBar) {
        presenter.navigateToAddPost(viewDelegate: self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.homeContentViewParams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CommonTableViewCell<HomeContentView> = tableView.dequeueReusableCell(
            withIdentifier: HomeContentView.className(),
            for: indexPath
        ) as? CommonTableViewCell<HomeContentView>,
              let viewParam = presenter.homeContentViewParams[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.view.configure(viewParam: viewParam)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: CreatePostViewDelegate {
    func createPostViewDidFinishAddingContent(model: PostModel) {
        presenter.onNewPostAdded(model)
    }
}
