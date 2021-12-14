//
//  DataParserProtocol.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

protocol DataParserProtocol {
    func parseData<T: Codable>(_ data: Data?) -> T?
}
