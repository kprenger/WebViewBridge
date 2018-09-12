//
//  ViewController.swift
//  WebViewBridge
//
//  Created by Kurt Prenger on 9/12/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.frame)
        
        guard let webView = webView, let resourceUrl = Bundle.main.resourceURL else { return }
        
        webView.configuration.userContentController.add(self, name: "takeSelfie")
        webView.configuration.userContentController.add(self, name: "closeWebView")
        
        let bundleUrl = resourceUrl.absoluteURL
        let html = bundleUrl.appendingPathComponent("webpage.html")
        
        webView.loadFileURL(html, allowingReadAccessTo: bundleUrl)
    }

    // MARK: - Button touches
    @IBAction func openWebview(_ sender: UIButton) {
        guard let webView = webView else { return }
        view.addSubview(webView)
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    func takeSelfie() {
        
    }
    
    func closeWebView() {
        
    }
}

