//
//  ViewController.swift
//  JsNativesCross
//
//  Created by 726676435@qq.com on 06/11/2021.
//  Copyright (c) 2021 726676435@qq.com. All rights reserved.
//

import UIKit
import WebKit
import JsNativesCross


class ViewController: UIViewController, WKUIDelegate {
    private var webView: WKWebView!
    private let jsNatives = JsNatives()
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        jsNatives.modules(values: [JSConsole()])
        jsNatives.active(view: webView)
        view = webView
        self.perform(#selector(delayExecution), with: nil, afterDelay: 0.5)
    }
    
    @objc func delayExecution(){
        let dict: Dictionary<String, Any> = [
            "count": 1,
            "msg": "call by iOS"
        ]
        jsNatives.js(path: "Print/console", payload: dict, handler: { (result:Any?, error:Error?)->Void in
            if let panic = error {
                print("Print/console error: \(panic)")
            }else if let value = result{
                print("Print/console value: \(value)")
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "Assets/web/index", withExtension: "html")
        webView.loadFileURL(url!, allowingReadAccessTo: Bundle.main.bundleURL)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
        let alert = UIAlertController(title: "Title", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
