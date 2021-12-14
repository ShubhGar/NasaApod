//
//  StoryboardInitializable.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    // Initalize view controller from storyboard
    static func initFromStoryboard(name: Storyboards = .Main) -> Self {
        let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}

enum Storyboards: String {
    case Main
    case WebView
}
