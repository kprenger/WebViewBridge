//
//  ViewController.swift
//  WebViewBridge
//
//  Created by Kurt Prenger on 9/12/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

import MobileCoreServices
import UIKit
import WebKit

class ViewController: UIViewController {
    
    private let takeSelfieMsg = "takeSelfie"
    private let closeWebViewMsg = "closeWebView"
    
    private var webView: WKWebView?
    private var webViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.frame)
        
        guard let webView = webView, let resourceUrl = Bundle.main.resourceURL else { return }
        
        webView.configuration.userContentController.add(self, name: takeSelfieMsg)
        webView.configuration.userContentController.add(self, name: closeWebViewMsg)
        
        let bundleUrl = resourceUrl.absoluteURL
        let html = bundleUrl.appendingPathComponent("webpage.html")
        
        webView.loadFileURL(html, allowingReadAccessTo: bundleUrl)
        webViewController.view.addSubview(webView)
    }

    // MARK: - Button touches
    @IBAction func openWebview(_ sender: UIButton) {
        present(webViewController, animated: true, completion: nil)
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case closeWebViewMsg:
            closeWebView()
        case takeSelfieMsg:
            takeSelfie()
        default:
            closeWebView()
        }
    }
    
    func takeSelfie() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera),
            UIImagePickerController.isCameraDeviceAvailable(.front),
            let types = UIImagePickerController.availableMediaTypes(for: .camera),
            types.contains(kUTTypeMovie as String) else {
            
            print("no camera to record video available")
            closeWebView()
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.videoMaximumDuration = 10
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        webViewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func closeWebView() {
        webViewController.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("got an image")
    }
}
