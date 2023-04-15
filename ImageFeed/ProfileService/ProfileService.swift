//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 07.04.2023.
//

import Foundation


final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    
    private var task: URLSessionDataTask?
    private var lastToken: String?
  
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        let request = profileRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<Profile, Error>) -> Void in
            guard let self = self else { return }
            switch result  {
            case .success(let profile):
                self.profile = profile
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in  }
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
