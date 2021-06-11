//
//  JsCallback.swift
//  app
//
//  Created by peng on 2021/6/10.
//

import Foundation
import WebKit

public class JsCallback {
    public let view:WKWebView?
    private let client:JsNatives
    private let path:String
    
    init(view: WKWebView?, client: JsNatives, path: String) {
        self.view = view
        self.client = client
        self.path = path
    }
    
    func call(_ value: Any) {
        client.js(path: self.path, payload: value)
    }
    
    public func failure(_ msg: String = "failed") {
        call(["success": false, "msg": msg])
    }
    
    public func success(_ value: Any) {
        call(["success": true, "data": value])
    }
}
