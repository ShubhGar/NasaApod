//
//  DataFetcherProtocol.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

protocol DataFetcherProtocol {
    func requestData<T: Codable>(url:URL, completion: @escaping (ApiResult<T>)->Void)
}
