//
//  PublishPost.swift
//  SMC
//
//  Created by JuicePhactree on 8/30/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import Foundation

class PublishPost {
    
    private var _mediaPath:String!
    private var _postId: String!
    private var _postText: String!
    private var _timeStamp: String!
    private var _postedOn: String?
    private var _scheduledOn: String?
    private var _mediaType: String?
    private var _twitter: String?
    private var _pinterest: String?
    private var _instagram: String?
    private var _linkedin: String?
    private var _facebook: String?
    
    
    
    init() {
    }
    
    init(postMediaDict: NSDictionary) {
        _mediaPath = postMediaDict[PUBLISH_MEDIAPATH] as? String
        _timeStamp = String(describing: postMediaDict[PUBLISH_TIMESTAMP] as! NSNumber)
        _postId = postMediaDict[PUBLISH_POST_KEY] as? String
        _postText = postMediaDict[PUBLISH_POSTTEXT] as? String
        _postedOn = postMediaDict[PUBLISH_POSTEDON] as? String
        _scheduledOn = postMediaDict[PUBLISH_SCHEDULING] as? String
        _mediaType = postMediaDict[PUBLISH_MEDIATYPE] as? String
        
        _twitter = postMediaDict[PUBLISH_TWITTER] as? String
        _pinterest = postMediaDict[PUBLISH_PINTEREST] as? String
        _instagram = postMediaDict[PUBLISH_INSTAGRAM] as? String
        _linkedin = postMediaDict[PUBLISH_LINKEDIN] as? String
        _facebook = postMediaDict[PUBLISH_FACEBOOK] as? String
        
        
        
    }
    
    
    var mediaPath : String{
        get {
            return _mediaPath
        }
        set(newValue) {
            self._mediaPath = newValue
        }
    }
    
    var timeStamp : String{
        get {
            return _timeStamp
        }
        set(newValue) {
            self._timeStamp = newValue
        }
    }
    
    var postId : String{
        get {
            return _postId
        }
        set(newValue) {
            self._postId = newValue
        }
    }
    
    var postText : String{
        get {
            return _postText
        }
        set(newValue) {
            self._postText = newValue
        }
    }
    
    var postedOn : String?{
        get {
            if _postedOn == nil {
                return ""
            }
            return _postedOn
        }
        set(newValue) {
            self._postedOn = newValue
        }
    }
    
    var scheduledOn : String?{
        get {
            return _scheduledOn
        }
        set(newValue) {
            self._scheduledOn = newValue
        }
    }
    
    var mediaType : String?{
        get {
            
            if _mediaType == nil {
                return "image"
            }
            return _mediaType
        }
        set(newValue) {
            self._mediaType = newValue
        }
    }
    
    var twitter : String?{
        get {
            if _twitter == nil {
                return ""
            }
            else {
               return _twitter
            }
            
        }
        set(newValue) {
            self._twitter = newValue
        }
    }
    
    var pinterest : String?{
        get {
            if _pinterest == nil {
                return ""
            }
            else {
                return _pinterest
            }
            
        }
        set(newValue) {
            self._pinterest = newValue
        }
    }
    
    var instagram : String?{
        get {
            if _instagram == nil {
                return ""
            }
            else {
                return _instagram
            }
            
        }
        set(newValue) {
            self._instagram = newValue
        }
    }
    
    var linkedin : String?{
        get {
            if _linkedin == nil {
                return ""
            }
            else {
                return _linkedin
            }
            
        }
        set(newValue) {
            self._linkedin = newValue
        }
    }
    
    var facebook : String?{
        get {
            if _facebook == nil {
                return ""
            }
            else {
                return _facebook
            }
            
        }
        set(newValue) {
            self._facebook = newValue
        }
    }


}

