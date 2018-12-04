//
//  Answers.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/1/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation

class Answers {
    
    private var _ansId:String!
    private var _comments:String!
    private var _date: String!
    private var _likes: String!
    private var _priority: String!
    private var _quesId: String!
    private var _selected: String!
    private var _userId: String!
    private var _videoLink: String!
    private var _videoThumbLink: String!
    
    
    init() {
        
    }
    
    init(ansDict: NSDictionary) {
        _ansId = ansDict[ANSWER_ANSID] as! String
        _comments = ansDict[ANSWER_COMMENTS] as! String
        _date = ansDict[ANSWER_DATE] as! String
        _likes = ansDict[ANSWER_LIKES] as! String
        _priority = "Free"
        _quesId = ansDict[ANSWER_QUESID] as! String
        _selected = ansDict[ANSWER_SELECTED] as! String
        _userId = ansDict[ANSWER_USERID] as! String
        _videoLink = ansDict[ANSWER_VIDEOLINK] as! String
        _videoThumbLink = ansDict[ANSWER_VIDEOLINK] as! String
    }
    
    
    var ansId : String{
        get {
            return _ansId
        }
        set(newValue) {
            self._ansId = newValue
        }
    }
    
    var comments : String{
        get {
            return _comments
        }
        set(newValue) {
            self._comments = newValue
        }
    }
    
    var date : String{
        get {
            return _date
        }
        set(newValue) {
            self._date = newValue
        }
    }
    var likes : String{
        get {
            return _likes
        }
        set(newValue) {
            self._likes = newValue
        }
    }
    var priority : String{
        get {
            return _priority
        }
        set(newValue) {
            self._priority = newValue
        }
    }
    
    var quesId : String{
        get {
            return _quesId
        }
        set(newValue) {
            self._quesId = newValue
        }
    }
    var selected : String{
        get {
            return _selected
        }
        set(newValue) {
            self._selected = newValue
        }
    }
    
    var userId : String{
        get {
            return _userId
        }
        set(newValue) {
            self._userId = newValue
        }
    }
    
    var videoLink : String{
        get {
            return _videoLink
        }
        set(newValue) {
            self._videoLink = newValue
        }
    }
    
    var thumbLink : String{
        get {
            return _videoThumbLink
        }
        set(newValue) {
            self._videoThumbLink = newValue
        }
    }
}
