//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import Foundation

enum GFError: String, Error {
    case invalidUserName = "This username created an invalid url"
    case unableToComplete = "Unable to complete network request, please check your internet connection"
    case invalidServerResponse = "The data received from the server was invalid, please try again"
}
