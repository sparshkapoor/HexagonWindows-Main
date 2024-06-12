//
//  KeyLoc.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 6/12/24.
//

import Foundation
import SwiftUI

public enum KeyLoc {
    enum Keys {
        static let GPT_API_KEY = "GPT_API_KEY"
        static let STREET_API_KEY = "STREET_API_KEY"
    }
    ///Getting plist here
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found" )
        }
        return dict
    }()
    ///Get apiKey and baseurl from plist
    static let GPT_API_KEY: String = {
        guard let GPT_API_KEY_STRING = KeyLoc.infoDictionary[Keys.GPT_API_KEY] as? String else {
                fatalError("API Key not set in plist")
        }
        return GPT_API_KEY_STRING
    }()
    
    static let STREET_API_KEY: String = {
        guard let STREET_API_KEY_STRING = KeyLoc.infoDictionary[Keys.STREET_API_KEY] as? String else {
                fatalError("API Key not set in plist")
        }
        return STREET_API_KEY_STRING
    }()
}

