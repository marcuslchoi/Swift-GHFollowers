//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let baseUrl = "https://api.github.com/users/"
    //completion handler takes a list of followers or error description
    func getFollowers(username: String, page: Int, completion: @escaping ([Follower]?, String?) -> Void)
    {
        //returning 100 results per page
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: endpoint) else {
            //can't call alert here because it is a bg thread, so use completion handler
            completion(nil, "Please check the username and try again.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                completion(nil, "Unable to complete your request, please check your internet connection.")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response from server, please try again.")
                return
            }
            
            guard let data = data else {
                completion(nil, "The data from  the server was invalid, please try again.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, "The data from  the server was invalid, please try again.")
            }
        }.resume()
    }
}
