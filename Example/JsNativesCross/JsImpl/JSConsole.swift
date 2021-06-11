//
//  JSConsole.swift
//  JsNativesCross_Example
//
//  Created by peng on 2021/6/11.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import JsNativesCross

public class JSConsole : JsReactor {
    
    public func exec(path: String, args: String, callback: JsCallback) throws -> Bool {
        if !path.hasPrefix("Console/") {
            return false
        }
        print("Console print: \(args)")
        callback.success("print success.")
        return true
    }
}
