//
//  JSON.swift
//  app
//
//  Created by peng on 2021/6/10.
//

import Foundation

public class JSON {
    
    public static func stringify(_ obj:Any?) -> String{
        guard let value: Any = obj else { return "" }
        if value is String {
            return value as! String
        }else if JSONSerialization.isValidJSONObject(value) {
            let data = try?JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
            guard let bytes: Data = data else { return "" }
            guard let json :String = String(data:bytes, encoding: .utf8) else { return "" }
            return json
        }else{
            return ""
        }
    }
    
    public static func parse(_ str: String?) -> [String: Any]?{
        guard let json:String = str else { return nil }
        if json.count <= 0 { return nil }
        guard let bytes:Data = json.data(using: String.Encoding.utf8) else { return nil}
        let value = try? JSONSerialization.jsonObject(with: bytes, options: .mutableContainers)
        if let dict = value as? [String : Any] {
            return dict
        }
        return nil
    }
}
