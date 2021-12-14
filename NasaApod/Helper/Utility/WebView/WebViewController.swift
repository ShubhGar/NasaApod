//
//  PlayerViewController.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, StoryboardInitializable  {
    var url: URL?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        webView.navigationDelegate = self
        if let url = url{
            // create url request and open in webview
            let requestObj = URLRequest(url: url)
            self.webView.load(requestObj )
        }
    }
    
    
}
