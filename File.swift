//
//  File.swift
//  mapDemo
//
//  Created by Mobile Team 3 on 19/02/20.
//  Copyright © 2020 jci. All rights reserved.
//

import Foundation
import UIKit

struct MockDataFlags {
    static var isMockData = false
}

struct GlobalConstants {
    static let defaultString: String = ""
}

let kRequestParameterValueKey = "1"
let kRequestParameterKey = "RequestParameter"
let kDummyPlist = "Dummy"
let kPlistKey = "plist"


struct DummyDataHandler {
    
    public static func getDummyData(for endPoint: String, requestParam: String) -> Any? {
        
        if let path = Bundle.main.path(forResource: kDummyPlist, ofType: kPlistKey) {
            
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                let dictKey = self.getKeyFrom(dict: dict, endPoint: endPoint)
                
                if !dictKey.isEmpty {
                    if let keyValue = dict.value(forKey: dictKey) as? NSDictionary {
                        
                        var key = self.getKeyFrom(dict: keyValue, endPoint: endPoint)
                        if key.isEmpty {
                            key = kRequestParameterKey
                        }
                        if let requestParam = keyValue[key] as? [String: String] {
                            let jsonString = requestParam[kRequestParameterValueKey]
                            guard let jsonData = jsonString?.data(using: .utf8) else {
                                return GlobalConstants.defaultString
                            }

                            do {
                                let object = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                                return object
                                
                            } catch {
                                return GlobalConstants.defaultString
                            }
                        }
                    }
                }
            }
        }
        
        return GlobalConstants.defaultString
    }
    
    static func getKeyFrom(dict: NSDictionary, endPoint: String) -> String {
        let allKeys = dict.allKeys
        for keyObject in allKeys {
            guard let key = keyObject as? String else {
                return GlobalConstants.defaultString
            }
            if endPoint.contains(key) {
                return key
            }
        }
        return GlobalConstants.defaultString
    }
}
