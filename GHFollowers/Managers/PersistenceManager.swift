//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/25/21.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    private static let defaults = UserDefaults.standard

    static func update(favorite: Follower, actionType: PersistenceActionType, closure: @escaping (GFError?) -> Void) {
        get { result in
            switch result {
            case let .success(favorites):
                var tempFavorites = favorites

                switch actionType {
                case .add:
                    guard !tempFavorites.contains(favorite) else {
                        closure(.alreadyInFavorites)

                        return
                    }

                    tempFavorites.append(favorite)
                case .remove:
                    tempFavorites.removeAll { $0.login == favorite.login }
                }

                closure(save(favorites: tempFavorites))
            case let .failure(error):
                closure(error)
            }
        }
    }

    static func get(closure: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favorites = defaults.object(forKey: StorageKeys.favorites) as? Data else {
            closure(.success([]))

            return
        }

        do {
            let decoder = JSONDecoder()

            let favorites = try decoder.decode([Follower].self, from: favorites)

            closure(.success(favorites))
        } catch {
            closure(.failure(.unableToFavorite))
        }
    }

    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()

            let encodedFavorites = try encoder.encode(favorites)

            defaults.setValue(encodedFavorites, forKey: StorageKeys.favorites)

            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
