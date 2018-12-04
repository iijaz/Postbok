//
//  Comments.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/1/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation

class Comments {
    
    private var _commentTime:String!
    private var _commentContent:String!
    private var _commentId: String!
    private var _name: String!
    private var _number: String!

    
    
    init() {
    }
    
    
    var commentTime : String{
        get {
            return _commentTime
        }
        set(newValue) {
            self._commentTime = newValue
        }
    }
    
    var commentContent : String{
        get {
            return _commentContent
        }
        set(newValue) {
            self._commentContent = newValue
        }
    }
    
    var commentId : String{
        get {
            return _commentId
        }
        set(newValue) {
            self._commentId = newValue
        }
    }
    
    var name : String{
        get {
            return _name
        }
        set(newValue) {
            self._name = newValue
        }
    }
    
    var number : String{
        get {
            return _number
        }
        set(newValue) {
            self._number = newValue
        }
    }
}
