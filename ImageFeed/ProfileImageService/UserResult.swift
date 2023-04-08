//
//  UserResult.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 08.04.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small: String
}
