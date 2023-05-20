//
//  PhotoLikedRequest.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 18.04.2023.
//

import Foundation

struct PhotosLikedRequest: Codable {
    let photo: PhotoLiked
}

extension PhotosLikedRequest {
    struct PhotoLiked: Codable {
        let id: String?
        let likedByUser: Bool
    }
}
