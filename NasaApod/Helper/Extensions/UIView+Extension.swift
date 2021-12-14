//
//  UIView+Extension.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
import UIKit

extension UIView{
    
    /* Show Progress Indicator */
    func showProgressIndicator(time: Int = 10) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = false
            
            // Create and add the view to the screen.
            let progressIndicator = ProgressIndicator(text: Constants.WAIT)
            progressIndicator.tag = 99
            self.addSubview(progressIndicator)
            let dispatchAfter = DispatchTimeInterval.seconds(time)
            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
                self.isUserInteractionEnabled = true
                var view = self.viewWithTag(99)
                view?.removeFromSuperview()
                view = nil
            }
        }
    }
    
    /* Hide progress Indicator */
    func hideProgressIndicator() {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
            var view = self.viewWithTag(99)
            view?.removeFromSuperview()
            view = nil
        }
    }
    
}
