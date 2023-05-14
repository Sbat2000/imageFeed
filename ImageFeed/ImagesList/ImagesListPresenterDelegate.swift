//
//  ImagesListPresenterDelegate.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import Foundation

protocol ImagesListPresenterDelegate {
    func updateTableViewAnimated(indexPaths: [IndexPath])
    func blockUI()
    func unblockUI()
    func updateLikeStatus(_ indexPath: IndexPath)
}
