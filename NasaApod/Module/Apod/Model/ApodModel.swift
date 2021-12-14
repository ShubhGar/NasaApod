//
//  ApodModel.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
import CoreData

//MARK:- Model for data from server
struct ApodModel:Codable {
    let copyright : String?
    let date : String?
    let explanation : String?
    let hdurl : String?
    let media_type : String?
    let service_version : String?
    let title : String?
    let url : String?
    var isfav: Bool?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        explanation = try values.decodeIfPresent(String.self, forKey: .explanation)
        hdurl = try values.decodeIfPresent(String.self, forKey: .hdurl)
        media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
        service_version = try values.decodeIfPresent(String.self, forKey: .service_version)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        isfav = try values.decodeIfPresent(Bool.self, forKey: .isfav)
    }
    
    
    init(newValue: CDApod) {
        self.copyright = newValue.copyright
        self.date = newValue.date
        self.explanation = newValue.explanation
        self.hdurl = newValue.hdurl
        self.media_type = newValue.media_type
        self.title = newValue.title
        self.service_version = newValue.service_version
        self.url = newValue.url
        self.isfav = newValue.isFavourite
    }
    
}
