//
//  UIViewController+Extension.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK:- Show alert on view controller
    func showAlert(withMessage message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.OK, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}
