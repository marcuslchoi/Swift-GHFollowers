//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

import Foundation
enum ErrorMessage: String {
    case invalidUsername = "Invalid username. Please check the username and try again."
    case unableToComplete = "Unable to complete your request, please check your internet connection."
    case invalidResponse = "Invalid response from server, please try again."
    case invalidData = "The data from  the server was invalid, please try again."
}
