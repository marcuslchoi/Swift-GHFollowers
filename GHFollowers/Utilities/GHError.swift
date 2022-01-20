//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

import Foundation
enum GHError: String, Error {
    case invalidUsername = "Invalid username. Please check the username and try again."
    case unableToComplete = "Unable to complete your request, please check your internet connection."
    case invalidResponse = "Invalid response from server, please try again."
    case invalidData = "The data from  the server was invalid, please try again."
    case unableToFavorite = "There was an error favoriting this user, please try again."
    case alreadyInFavorites = "This user is already in your favorites."
}
