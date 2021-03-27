//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "https://api.github.com"

    let cache = NSCache<NSString, UIImage>()

    private init() {}

    func getFollowers(for username: String, page: Int, closure: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            closure(.failure(.invalidUserName))

            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                closure(.failure(.unableToComplete))

                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                closure(.failure(.invalidServerResponse))

                return
            }

            guard let data = data else {
                closure(.failure(.invalidServerResponse))

                return
            }

            do {
                let decoder = JSONDecoder()

                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let followers = try decoder.decode([Follower].self, from: data)

                closure(.success(followers))
            } catch {
                closure(.failure(.invalidServerResponse))
            }
        }

        task.resume()
    }

    func getUserInfo(for username: String, closure: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseURL + "/users/\(username)"

        guard let url = URL(string: endpoint) else {
            closure(.failure(.invalidUserName))

            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                closure(.failure(.unableToComplete))

                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                closure(.failure(.invalidServerResponse))

                return
            }

            guard let data = data else {
                closure(.failure(.invalidServerResponse))

                return
            }

            do {
                let decoder = JSONDecoder()

                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601

                let user = try decoder.decode(User.self, from: data)

                closure(.success(user))
            } catch {
                closure(.failure(.invalidServerResponse))
            }
        }

        task.resume()
    }

    func downloadImage(from urlString: String, closure: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            closure(image)

            return
        }

        guard let url = URL(string: urlString) else {
            closure(nil)

            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data)
            else {
                closure(nil)

                return
            }

            self.cache.setObject(image, forKey: cacheKey)

            closure(image)
        }

        task.resume()
    }
}
