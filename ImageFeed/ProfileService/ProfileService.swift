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
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = profileRequest(token: token)
        let task = object(for: request) { [weak self] result -> Void in
            guard let self = self else { return }
            switch result  {
            case .success(let profile):
                self.profile = profile
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in  }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension ProfileService {
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<Profile, Error> in
                Result { try decoder.decode(Profile.self, from: data) }
            }
            completion(response)
        }
    }
}
