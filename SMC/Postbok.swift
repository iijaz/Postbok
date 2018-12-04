//
//  Postbok.swift
//  SMC
//
//  Created by JuicePhactree on 8/16/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import Foundation

class Postbok {
    
    private var _mediaPath:String!
    private var _mediaType:String!
    private var _postId: String!
    private var _postText: String!
    private var _thumbImage: String?
    
    
    
    init() {
    }
    
    init(postMediaDict: NSDictionary) {
        _mediaPath = postMediaDict[POSTBOK_MEDIAPATH] as? String
        _mediaType = postMediaDict[POSTBOK_MEDIATYPE] as? String
        _postId = postMediaDict[POSTBOK_POSTID] as? String
        _postText = postMediaDict[POSTBOK_POSTTEXT] as? String
        _thumbImage = postMediaDict[POSTBOK_THUMBIMAGE] as? String
        
    }
    
    
    var mediaPath : String{
        get {
            return _mediaPath
        }
        set(newValue) {
            self._mediaPath = newValue
        }
    }
    
    var mediaType : String{
        get {
            return _mediaType
        }
        set(newValue) {
            self._mediaType = newValue
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
    var thumbImage : String?{
        get {
            return _thumbImage
        }
        set(newValue) {
            self._thumbImage = newValue
        }
    }
}
