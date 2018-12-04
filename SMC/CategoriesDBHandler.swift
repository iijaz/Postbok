//
//  CategoriesDBHandler.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/31/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class CategoriesDBHandler {
    
    private static let _instance = CategoriesDBHandler()
    private init() {}
    static var Instance: CategoriesDBHandler {
        return _instance;
    }
}
