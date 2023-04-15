//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 15.04.2023.
//

import Foundation

// MARK: - PhotosResultElement
struct PhotosResultElement: Codable {
    let id: String
    let createdAt: String
    let width, height: Int
    let likes: Int?
    let likedByUser: Bool
    let description: String?
    let urls: Urls?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case likes
        case likedByUser = "liked_by_user"
        case description, urls
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

typealias PhotosResult = [PhotosResultElement]
