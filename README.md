# WebViewBridge
The purpose of this sample is to create a javascript bridge from a webview to the native app. The bridge is used to trigger a UIImagePickerController for taking a video with the front-facing camera.

It demonstrates using two different approaches to achieve the desired results:
1. Via a WKWebView talking directly to the root view controller - with the root view controller handling the display of the image picker and delegation of it.
2. Via a WKWebView talking directly to the root view controller - with the image picker controls obfuscated into a framework. Where the framework handles the display and delegation of the image picker, and passes data back to the root view controller via delegation itself.

This was quickly made to demonstrate a concept. I imagine there are improvements to be made.
