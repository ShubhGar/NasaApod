//
//  Utils.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
//Constants for project
typealias parameters = [String:Any]

enum Urls {
    static let apod = "https://api.nasa.gov/planetary/apod?api_key=\(Constants.API_KEY)&date="
}

enum Constants  {
    static let API_KEY = "NSqXRdl7GCvlndctP7lavDbF1wCJOidHDulpR9vq"
    static let DONE = "Done"
    static let CANCEL = "Cancel"
    static let WAIT = "Wait"
    static let OK = "Ok"
}

public enum ErrorMessage: String {
    case somethingWentWrong = "Some thing went wrong"
    case unauthorizedUser = "Unauthorized user."
    case noInternet = "No internet connection"
}

enum ApiResult<T:Codable> {
    case success(T)
    case failure(DataError)
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
}

public enum DataError {
    case internetError
    case customMessage(ErrorMessage)
    case serverMessage(String)
    case unauthorized
}
