//
//  NSObject+Extension.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

extension NSObject{
    // get class name
   class var identifier:String {
        get {
            return String(describing: self)
        }
    }
}
