//
//  UserResult.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 08.04.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small: String
}
