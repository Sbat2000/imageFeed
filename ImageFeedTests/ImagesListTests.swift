//
//  ImagesListView.swift
//  ImageFeedTests
//
//  Created by Aleksandr Garipov on 14.05.2023.
//

@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {
    
    let indexPath = IndexPath(row: 9, section: 0)
    let photo = Photo(id: "",
                      size: CGSize(width: 1.1, height: 1.1),
                      createdAt: nil,
                      welcomeDescription: "",
                      thumbImageURL: "",
                      largeImageURL: "",
                      isLiked: true)
    
    final class ImageListPresenterSpy: ImagesListPresenterProtocol {
        
        var delegate: ImagesListPresenterDelegate?
        
        internal var updateTableViewAnimatedCalled: Bool = false
        internal var needsNewPhoto: Bool = false
        internal var imageListCellDidTapLikeCalled: Bool = false
        
        var photos: [Photo] = []
        
        func updateTableViewAnimated() {
            updateTableViewAnimatedCalled = true
        }
        
        func needsNewPhoto(indexPath: IndexPath) {
            if indexPath.row + 1 == photos.count {
                needsNewPhoto = true
            }
        }
        
        func imageListCellDidTapLike(indexPath: IndexPath) {
            imageListCellDidTapLikeCalled = true
        }
 
    }
    
    final class ImageListsViewControllerSpy: ImagesListViewControllerProtocol, ImagesListPresenterDelegate {
        func updateTableViewAnimated(indexPaths: [IndexPath]) {
            
        }
        
        func blockUI() {
            
        }
        
        func unblockUI() {
            
        }
        
        func updateLikeStatus(_ indexPath: IndexPath) {
            
        }
        
        var presenter: ImagesListPresenterProtocol?
        
    }
    

    func testNeedsNewPhoto() {
        let presenter = ImageListPresenterSpy()
        presenter.photos = Array(repeating: photo, count: 10)
        let controller = ImageListsViewControllerSpy()
        controller.presenter = presenter
        
        presenter.needsNewPhoto(indexPath: indexPath)
        print(presenter.photos.count)
        print(presenter.needsNewPhoto)
        XCTAssertTrue(presenter.needsNewPhoto)
    }
    
    func testNotNeedsNewPhoto() {
        let presenter = ImageListPresenterSpy()
        presenter.photos = Array(repeating: photo, count: 9)
        let controller = ImageListsViewControllerSpy()
        controller.presenter = presenter
        
        presenter.needsNewPhoto(indexPath: indexPath)
        print(presenter.photos.count)
        print(presenter.needsNewPhoto)
        XCTAssertFalse(presenter.needsNewPhoto)
    }
    
    func testUpdateTableViewAnimatedCalled() {
        let presenter = ImageListPresenterSpy()
        let controller = ImageListsViewControllerSpy()
        controller.presenter = presenter
        presenter.updateTableViewAnimated()
        
        XCTAssertTrue(presenter.updateTableViewAnimatedCalled)
    }
    
    func testImageListCellDidTapLikeCalled() {
        let presenter = ImageListPresenterSpy()
        let controller = ImageListsViewControllerSpy()
        controller.presenter = presenter
        presenter.imageListCellDidTapLike(indexPath: indexPath)
        
        XCTAssertTrue(presenter.imageListCellDidTapLikeCalled)
    }

    
}
