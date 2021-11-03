//
//  DetailViewController.swift
//  CapitalCities
//
//  Created by JC on 12/9/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var capitalName: String!
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = capitalName
        guard let url = URL(string: "https://en.wikipedia.org/wiki/\(capitalName!)") else { return }
        webView.load(URLRequest(url: url))
    }
    
}
