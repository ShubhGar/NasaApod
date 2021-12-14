//
//  UITableView+Extension.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
import UIKit

extension UITableView {
    //MARK:- Show message when no data on tableview
    func noDataLabel(message: String) {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text = message
        noDataLabel.textColor = UIColor.white
        noDataLabel.textAlignment = .center
        self.backgroundView  = noDataLabel
    }
    
}
