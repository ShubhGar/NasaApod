//
//  JsonDataParser.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

class JsonDataParser: DataParserProtocol {
    //MARK:- parse json data to given object
    func parseData<T: Codable>(_ data: Data?) -> T? {
        if let data = data, let obj = try? JSONDecoder().decode(T.self, from: data) {
            return obj
        }
        return nil
    }
    
}
