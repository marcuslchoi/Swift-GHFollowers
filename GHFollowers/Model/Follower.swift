//
//  Follower.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    //can use camel case if using decoder.keyDecodingStrategy = .convertFromSnakeCase (since original is in snake case)
    var avatarUrl: String
}
