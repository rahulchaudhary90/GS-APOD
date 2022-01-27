//
//  WebViewVC.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 27/01/22.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Btn Action
    
    @IBAction func doneBtnAction(sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    
    /// Load the WebView from URL
    /// - Parameter url: webView request url
    func loadUrl(url: URL) {
         let _ = view// force load the view
        webView.load(URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
}
