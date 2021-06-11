//
//  JsModule.swift
//  app
//
//  Created by peng on 2021/6/10.
//

import Foundation

public protocol JsReactor {
    func exec(path:String, args:String, callback: JsCallback) throws -> Bool
}
