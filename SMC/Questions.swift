//
//  Questions.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/1/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation

class Questions {
    
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
    private var _answersNode: Answers!
    private var _likesNode: String!
    private var _commentsNode: Comments!
    private var _category: String!
    private var _tag: String!
    private var _title: String!
    private var _shorDesc: String!
    
    
    init() {
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
    
    var answerNode : Answers{
        get {
            return _answersNode
        }
        set(newValue) {
            self._answersNode = newValue
        }
    }
    
    var commentsNode : Comments{
        get {
            return _commentsNode
        }
        set(newValue) {
            self._commentsNode = newValue
        }
    }
    
    var likesNode : String{
        get {
            return _likesNode
        }
        set(newValue) {
            self._likesNode = newValue
        }
    }
    
    var category : String{
        get {
            return _category
        }
        set(newValue) {
            self._category = newValue
        }
    }
    
    var tag : String{
        get {
            return _tag
        }
        set(newValue) {
            self._tag = newValue
        }
    }
    
    var title : String{
        get {
            return _title
        }
        set(newValue) {
            self._title = newValue
        }
    }
    
    var shortDescription : String{
        get {
            return _shorDesc
        }
        set(newValue) {
            self._shorDesc = newValue
        }
    }
}
