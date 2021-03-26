//
//  GFError.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/25/21.
//

import Foundation

enum GFError: String, Error {
    case invalidUserName = "This username created an invalid url"
    case unableToComplete = "Unable to complete network request, please check your internet connection"
    case invalidServerResponse = "The data received from the server was invalid, please try again"
    case unableToFavorite = "There was an error favoriting this user, please try again"
    case alreadyInFavorites = "You've already favorited this user"
}
