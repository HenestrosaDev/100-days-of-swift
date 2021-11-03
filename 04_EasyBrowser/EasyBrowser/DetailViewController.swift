//
//  DetailViewController.swift
//  EasyBrowser
//
//  Created by JC on 27/8/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView : UIProgressView!
    var websites: [String]! = nil //= ["apple.com", "hackingwithswift.com"]
    var selectedWebsite: String! = nil
    
    //It gets called when loading the layout. loadView + viewDidLoad = onCreate() in Android
    override func loadView() {
        webView = WKWebView()
        //Whe any web page navigation happens, tell me the current view navigation controller
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //This, as the name leads to think, is just a spacer to organize the items
        let spacer = UIBarButtonItem( barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //The refresh item appears in the end of the toolbar because of the spacer
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        //Creates a UIProgressView instance, giving it the default style
        progressView = UIProgressView(progressViewStyle: .default)
        //Takes as much space as it needs to show the full progress view
        progressView.sizeToFit()
        //Adds the progressView to the toolbar
        let progressButton = UIBarButtonItem(customView: progressView)
        let backButton = UIBarButtonItem(barButtonSystemItem: .trash, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        
        //UIToolbar is an entire bar dedicated to items, the same ones that we place in the navigation controller as rightButtonItem. The toolbar appears in the bottom of the screen.
        toolbarItems = [progressButton, spacer, backButton, refresh, forwardButton]
        navigationController?.isToolbarHidden = false
        
        //self: who the observer is. forKeyPath: what property of webView we want to observe. options: we want the noew value of the keyPath to keep the progressView refreshed.
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://\(selectedWebsite!)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        //The .actionSheet displays a menu in the botton of the View Controller. It's not like a dialog or something like that.
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
            
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://\(actionTitle)") else { return }
        webView.load(URLRequest(url: url))
    }
    
    //Once the URL has been loaded in the WebView, then we set the title of the Navigation Controller
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    //Updated the value of the progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            //Challenge of instructor
            let alertController = UIAlertController(title: "Error", message: "\(url?.host ?? "The website") is blocked.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
        
        //If the url is not part of our authorized websites or the url is null, then don't allow the user to open the page
        decisionHandler(.cancel)
    }
    
}
