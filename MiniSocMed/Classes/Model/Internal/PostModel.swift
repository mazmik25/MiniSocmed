//
//  PostModel.swift
//  MiniSocMed
//
//  Created by Muhammad Azmi Khairullah on 29/03/23.
//

import Foundation

struct PostModel {
    let user: UserModel
    let postingDate: Date
    let contentText: String
    let images: [CommonImageContent]
}
