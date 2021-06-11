//
//  JsNatives.swift
//  app
//
//  Created by peng on 2021/6/9.
//

import Foundation
import WebKit

public class JsNatives : NSObject, WKScriptMessageHandler{
    public static let DEBUG = false
    //
    private static let NATIVE_API = "_js2native"
    private static let JS_API = "_native2js"
    //
    public static let ERR_PATH_MISMATCH = "path mismatch."
    public static let ERR_DISCONNECTED = "invoker disconnected."
    //
    private var view: WKWebView? = nil
    private var reactors: [JsReactor] = []
    
    public func active(view: WKWebView){
        self.view = view
        view.configuration.userContentController.add(self, name: JsNatives.NATIVE_API)
    }
    
    public func modules(values: Array<JsReactor>) {
        reactors.append(contentsOf: values)
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard JsNatives.NATIVE_API == message.name else { return }
        if JsNatives.DEBUG { print("JsNative msg body: \(message.body)") }
        guard let dict = (message.body as? Dictionary<String, Any>) else { return }
        let params = ["path", "args", "cb"].map { key in
            return (dict[key] as? String) ?? ""
        }
        let callback = JsCallback(view: self.view, client: self, path: params[2])
        do{
            let executor = try reactors.first { reactor in
                return try reactor.exec(path: params[0], args: params[1], callback: callback)
            }
            guard nil != executor else { throw JsError(JsNatives.ERR_PATH_MISMATCH) }
        }catch let err as JsError{
            if JsNatives.DEBUG { print(err.msg) }
            callback.failure(err.msg)
        }catch{
            if JsNatives.DEBUG { print(error) }
            callback.failure(error.localizedDescription)
        }
    }
    
    public func js(path: String, payload: Any?, handler: ((Any?, Error?) -> Void)? = nil) {
        do {
            guard let webview = view else { throw JsError(JsNatives.ERR_DISCONNECTED) }
            let params = JSON.stringify(["path": path, "payload": payload])
            let script = "javascript:window.\(JsNatives.JS_API)(\(params))"
            if JsNatives.DEBUG { print(script) }
            webview.evaluateJavaScript(script, completionHandler: handler)
        }catch{
            handler?(nil, error)
        }
    }
}
