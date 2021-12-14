//
//  NetworkDataFetcher.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

class NetworkDataFetcher: DataFetcherProtocol {
    //MARK:- Fetch data from server
    func requestData<T: Codable>(url: URL, completion: @escaping (ApiResult<T>) -> Void) {
        let header =  ["content-type": "application/json"]
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                completion(ApiResult.failure(DataError.serverMessage(error.localizedDescription)))
            }else if let responseCode = response as? HTTPURLResponse {
                // check for response and gives error accordinngly
                switch responseCode.statusCode {
                case 200:
                    // parse data to give object
                    if let data: T = JsonDataParser().parseData(data) {
                        completion(ApiResult.success(data))
                    }
                    else {
                        completion(ApiResult.failure(DataError.customMessage(ErrorMessage.somethingWentWrong)))
                    }
                case 400...499:
                    completion(ApiResult.failure(DataError.unauthorized))
                default:
                    completion(ApiResult.failure(DataError.customMessage(ErrorMessage.somethingWentWrong)))
                    break
                }
            }
        }.resume()
    }
}
