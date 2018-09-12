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

import WebViewBridgeFramework

class ViewController: UIViewController {
    
    private let takeSelfieMsg = "takeSelfie"
    private let takeSelfieSDKMsg = "takeSelfieSDK"
    private let closeWebViewMsg = "closeWebView"
    
    private lazy var webViewController = UIViewController()
    
    private var webViewBridgeFramework: WebViewBrigeFramework?
    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.frame)
        
        guard let webView = webView, let resourceUrl = Bundle.main.resourceURL else { return }
        
        webView.configuration.userContentController.add(self, name: takeSelfieMsg)
        webView.configuration.userContentController.add(self, name: takeSelfieSDKMsg)
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
        case takeSelfieSDKMsg:
            takeSelfieWithSDK()
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
    
    func takeSelfieWithSDK() {
        webViewBridgeFramework = WebViewBrigeFramework(delegate: self)
        
        guard let webViewBridgeFramework = webViewBridgeFramework,
            webViewBridgeFramework.showImagePickerOn(webViewController) else {
            print("framework not working")
            closeWebView()
            return
        }
    }
    
    func closeWebView() {
        webViewController.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("got an image")
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: WebViewBrigeFrameworkDelegate {
    func imageReceived(_ image: String) {
        print(image)
    }
}
