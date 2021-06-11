//
//  JsError.swift
//  app
//
//  Created by peng on 2021/6/10.
//

import Foundation

public class JsError: Error {
    public let msg:String
    
    public init(_ msg: String) {
        self.msg = msg
    }
}
