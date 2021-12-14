//
//  NetworkManager.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    var reachability: Reachability?
    var isNetworkConnectionAvailable: Bool {
        get {
            return reachability?.connection != Reachability.Connection.unavailable
        }
    }
    
    private init () {
        reachability = try? Reachability(hostname: "www.google.com")
    }
    
}
