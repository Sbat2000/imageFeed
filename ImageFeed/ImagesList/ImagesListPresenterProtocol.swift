//
//  ImageListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var delegate: ImagesListPresenterDelegate? { get set }
    var photos: [Photo] { get set }
    func fetchPhotosNextPage()
    func updateTableViewAnimated()
    func needsNewPhoto(indexPath: IndexPath)
    func imageListCellDidTapLike(indexPath: IndexPath)
}
