//
//  KeyDBHandler.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/31/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation

class KeyDBHandler {
    
    private static let _instance = KeyDBHandler()
    private init() {}
    static var Instance: KeyDBHandler {
        return _instance;
    }
}
