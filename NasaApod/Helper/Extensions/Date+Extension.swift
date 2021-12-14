//
//  Date+Extension.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

extension Date {
    //MARK:- Convert date to String in given format
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
}
