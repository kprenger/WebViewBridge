//
//  ImagePickerDisplay.swift
//  WebViewBridgeFramework
//
//  Created by Kurt Prenger on 9/12/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

import Foundation
import MobileCoreServices

public protocol WebViewBrigeFrameworkDelegate {
    func imageReceived(_ image: String)
}

public class WebViewBrigeFramework {
    private var delegate: WebViewBrigeFrameworkDelegate?
    fileprivate lazy var imagePicker = CustomImagePickerController()
    
    public init(delegate: WebViewBrigeFrameworkDelegate?) {
        self.delegate = delegate
    }
    
    public func showImagePickerOn(_ viewController: UIViewController) -> Bool {
        guard UIImagePickerController.isSourceTypeAvailable(.camera),
            UIImagePickerController.isCameraDeviceAvailable(.front),
            let types = UIImagePickerController.availableMediaTypes(for: .camera),
            types.contains(kUTTypeMovie as String) else {
                
                print("no camera to record video available")
                return false
        }
        
        imagePicker.delegate = self
        return imagePicker.show(viewController)
    }
}

extension WebViewBrigeFramework: CustomImagePickerControllerDelegate {
    func imageReceived(_ image: String) {
        delegate?.imageReceived(image)
    }
}

fileprivate protocol CustomImagePickerControllerDelegate {
    func imageReceived(_ image: String)
}

private class CustomImagePickerController: UIViewController {
    var delegate: CustomImagePickerControllerDelegate?
    
    func show(_ vc: UIViewController) -> Bool {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.videoMaximumDuration = 10
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        vc.present(imagePicker, animated: true, completion: nil)
        return true
    }
}

extension CustomImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("SDK recieved image")
        picker.dismiss(animated: true, completion: nil)
        delegate?.imageReceived("the image received from the SDK")
    }
}
