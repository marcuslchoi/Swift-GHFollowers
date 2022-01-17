//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    private let baseUrl = "https://api.github.com/users/"
    //completion handler takes a list of followers or error description
    func getFollowers(username: String, page: Int, completion: @escaping (Result<[Follower], GHError>) -> Void)
    {
        //returning 100 results per page
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: endpoint) else {
            //can't call alert here because it is a bg thread, so use completion handler
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                        completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
