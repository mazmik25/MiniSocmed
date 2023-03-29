//
//  HomeInteractor.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 28/03/23.
//

import Foundation

protocol HomeInteractor: AnyObject {
    var postModels: [PostModel] { get }
    
    func addNewPost(model: PostModel)
    func getUserModels() -> [UserModel]
}

final class HomeInteractorImpl: HomeInteractor {
    var postModels: [PostModel] = []
    
    func addNewPost(model: PostModel) {
        postModels.append(model)
    }
    
    func getUserModels() -> [UserModel] {
        return [
            .init(
                userId: "123",
                avatarImage: .network(url: URL(string: "https://images.pexels.com/photos/3866555/pexels-photo-3866555.png?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")),
                nameText: "Cassandra Michelle",
                usernameText: "@CaMille"
            ),
            .init(
                userId: "456",
                avatarImage: .network(url: URL(string: "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")),
                nameText: "Martin Lacroft",
                usernameText: "@elNino"
            ),
            .init(
                userId: "789",
                avatarImage: .network(url: URL(string: "https://images.pexels.com/photos/1212984/pexels-photo-1212984.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")),
                nameText: "Vijay Bhardawal",
                usernameText: "@CallMeVijay"
            )
        ]
    }
}
