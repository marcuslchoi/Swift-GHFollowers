//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/19/22.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

//using enum instead of struct because struct can be initialized empty, but not enum
enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys {
        static let favorites = "favorites"
    }
    
    //retrieve favorites, update, then save
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GHError?) -> Void) {
        retrieveFavorites { result in
            switch result {
                
            case .success(let favorites):
                var updatedFavs = favorites
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    updatedFavs.append(favorite)
                case .remove:
                    updatedFavs.removeAll { $0.login == favorite.login }
                }
                completion(save(favorites: updatedFavs))
            case .failure(let error):
                completion(error)
                return
            }
        }  
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower], GHError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            //sending back an empty array because this is the first time we are accessing this
            completion(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> GHError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavs = try encoder.encode(favorites)
            defaults.set(encodedFavs, forKey: Keys.favorites)
        } catch {
            return .unableToFavorite
        }
        return nil
    }
}
