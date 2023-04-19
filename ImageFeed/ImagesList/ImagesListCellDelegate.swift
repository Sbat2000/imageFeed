//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 19.04.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
