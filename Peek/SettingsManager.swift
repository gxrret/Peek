//
//  SettingsManager.swift
//  Peek
//
//  Created by Garret Koontz on 3/16/17.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class SettingsManager {
    
    static let enableNSFWContentKey = "enableNSFWContent"
    
    static var enableNSFWContent: Bool {
        get {
            return UserDefaults.standard.bool(forKey: enableNSFWContentKey)
        }
        set {
            UserDefaults.standard.set(false, forKey: enableNSFWContentKey)
        }
    }
}
