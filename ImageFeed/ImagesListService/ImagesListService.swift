//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 15.04.2023.
//

import Foundation

final class ImagesListService {
    
    private let urlSession = URLSession.shared
    private var lastLoadedPage: Int?
    private var task: URLSessionDataTask?
    private let token = OAuth2TokenStorage().token!
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
     
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if task != nil {return}
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        
        let request = makePhotosRequest(with: nextPage)
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<PhotosResult, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let photosResult):
                photosResult.forEach { photo in
                    let date = DateFormatter().date(from: photo.createdAt)
                    guard let thumbImageURL = photo.urls?.thumb,
                          let largeImageURL = photo.urls?.full
                    else {return}
                    let photo = Photo(id: photo.createdAt,
                                      size: CGSize(width: photo.width,
                                                   height: photo.height),
                                      createdAt: date,
                                      welcomeDescription: photo.description,
                                      thumbImageURL: thumbImageURL,
                                      largeImageURL: largeImageURL,
                                      isLiked: photo.likedByUser)
                    print(photo.id)
                    self.photos.append(photo)
                }
                NotificationCenter.default.post(
                    name: ImagesListService.DidChangeNotification,
                    object: self,
                    userInfo: ["Photos": self.photos])
                self.task = nil
                print(self.photos.count)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
        self.task = task
        task.resume()
    }
}

//MARK: HTTPRequest service
extension ImagesListService {
    
    private func makePhotosRequest(with pageNumber: Int) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/photos/?page=\(pageNumber)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("10", forHTTPHeaderField: "per_page")
        request.setValue("1", forHTTPHeaderField: "page")
        return request
    }
}
