//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    internal let imageListService = ImagesListService.shared
    internal var photos: [Photo] = []
    internal weak var delegate: ImagesListPresenterDelegate?
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            delegate?.updateTableViewAnimated(indexPaths: indexPaths)
        }
    }
    
    func imageListCellDidTapLike(indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        delegate?.blockUI()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                self.photos = self.imageListService.photos
                self.delegate?.updateLikeStatus(indexPath)
                self.delegate?.unblockUI()
            case .failure(let error):
                self.delegate?.unblockUI()
                print(error)
            }
        }
    }
    
    func needsNewPhoto(indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            self.imageListService.fetchPhotosNextPage()
        }
    }

}


