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

                let user = try decoder.decode(User.self, from: data)

                closure(.success(user))
            } catch {
                closure(.failure(.invalidServerResponse))
            }
        }

        task.resume()
    }
}
