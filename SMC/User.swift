//
//  User.swift
//  Page
//
//  Created by JuicePhactree on 7/21/17.
//  Copyright © 2017 JuicePhactree. All rights reserved.
//

import Foundation
class User {
    
    private var _activitiesNode: UserActivities!
    private var _activities:String!
    private var _followActivitiesNode: UserActivities!
    private var _answers: String!
    private var _bio: String!
    private var _email: String!
    private var _fcm: String!
    private var _followers: String!
    private var _following: String!
    private var _id: String!
    private var _inApp: String!
    private var _lastseen: String!
    private var _likeNode: String!
    private var _name: String!
    private var _notification: String!
    private var _online: String!
    private var _phone: String!
    private var _posts: String!
    private var _profile: String!
    private var _region: String!
    private var _replies: String!
    private var _specialists: String!
    private var _userFollowersNode: String!
    private var _userFollowingsNode: String!
    private var _website: String!
    private var _password: String!
    private var _device: String!
    private var _profession: String!
    private var _accountType: String?
    private var _followRequestStatus: Int?
    
    
    
    init() {
        
    }
    
    init(userdict: NSDictionary) {
        _activities = userdict[USER_ACTIVITES] as? String
        _answers = userdict[USER_ANSWERS] as? String
        _bio = userdict[USER_BIO] as? String
        _email = userdict[USER_EMAIL] as? String
        _fcm = userdict[USER_FCM] as? String
        _followers = userdict[USER_FOLLOWERS] as? String
        _following = userdict[USER_FOLLOWING] as? String
        _id = userdict[USER_USERId] as? String
        _inApp = userdict[USER_INAPP] as? String
        _lastseen = String(describing: userdict[USER_LASTSEEN] as! NSNumber)
        _name = userdict[USER_NAME] as! String
        _notification = userdict[USER_NOTIFICATION] as? String
        _online = userdict[USER_ONLINE] as? String
        _phone = userdict[USER_PHONE] as? String
        _posts = userdict[USER_POSTS] as? String
        _profile = userdict[USER_PROFILE] as? String
        _region = userdict[USER_REGION] as? String
        _replies = userdict[USER_REPLIES] as? String
        _specialists = userdict[USER_SPECIALISTS] as? String
        _website = userdict[USER_WEBSITE] as? String
        _device = userdict[USER_DEVICE] as? String
        _profession = userdict[USER_PROFESSION] as? String
        _accountType = userdict[USER_ACCOUNT_TYPE] as? String
        _followRequestStatus = userdict[USER_FOLLOW_STATUS] as? Int
        
    }
    
    
    var activitiesNode : UserActivities{
        get {
            return _activitiesNode
        }
        set(newValue) {
            self._activitiesNode = newValue
        }
    }
    
    var activities : String{
        get {
            return _activities
        }
        set(newValue) {
            self._activities = newValue
        }
    }
    
    var followActivities : UserActivities{
        get {
            return _followActivitiesNode
        }
        set(newValue) {
            self._followActivitiesNode = newValue
        }
    }
    var answers : String{
        get {
            return _answers
        }
        set(newValue) {
            self._answers = newValue
        }
    }
    var bio : String{
        get {
            return _bio
        }
        set(newValue) {
            self._bio = newValue
        }
    }
    
    var email : String{
        get {
            return _email
        }
        set(newValue) {
            self._email = newValue
        }
    }
    var id : String{
        get {
            return _id
        }
        set(newValue) {
            self._id = newValue
        }
    }
    
    var followers : String{
        get {
            return _followers
        }
        set(newValue) {
            self._followers = newValue
        }
    }
    
    var following : String{
        get {
            return _following
        }
        set(newValue) {
            self._following = newValue
        }
    }
    
    var inApp : String{
        get {
            return _inApp
        }
        set(newValue) {
            self._inApp = newValue
        }
    }
    
    var mFcmId : String{
        get {
            return _fcm
        }
        set(newValue) {
            self._fcm = newValue
        }
    }
    
    
    
    var lastSeen : String{
        get {
            return _lastseen
        }
        set(newValue) {
            self._lastseen = newValue
        }
    }
    
 
    
    var likeNode : String{
        get {
            return _likeNode
        }
        set(newValue) {
            self._likeNode = newValue
        }
    }
    
  
    
    var username : String{
        get {
            return _name
        }
        set(newValue) {
            self._name = newValue
        }
    }
    
    var notification : String{
        get {
            return _notification
        }
        set(newValue) {
            self._notification = newValue
        }
    }
    
    var online : String{
        get {
            return _online
        }
        set(newValue) {
            self._online = newValue
        }
    }
    
    var phone : String{
        get {
            return _phone
        }
        set(newValue) {
            self._phone = newValue
        }
    }
    
    var posts : String{
        get {
            return _posts
        }
        set(newValue) {
            self._posts = newValue
        }
    }
    
    var profile : String{
        get {
            return _profile
        }
        set(newValue) {
            self._profile = newValue
        }
    }
    
    var region : String{
        get {
            return _region
        }
        set(newValue) {
            self._region = newValue
        }
    }
    
    var replies : String{
        get {
            return _replies
        }
        set(newValue) {
            self._replies = newValue
        }
    }
    
    var followRequestStatus : Int{
        get {
            if _followRequestStatus == nil {
                return 0
            }
            else {
                return _followRequestStatus!
            }
        }
        set(newValue) {
            self._followRequestStatus = newValue
        }
    }
    
    var specialists : String{
        get {
            return _specialists
        }
        set(newValue) {
            self._specialists = newValue
        }
    }
    
    var userFollowersNode : String{
        get {
            return _userFollowersNode
        }
        set(newValue) {
            self._userFollowersNode = newValue
        }
    }
    
    var userFollowingNode : String{
        get {
            return _userFollowingsNode
        }
        set(newValue) {
            self._userFollowingsNode = newValue
        }
    }
    
    var websites : String{
        get {
            return _website
        }
        set(newValue) {
            self._website = newValue
        }
    }
    
    var password : String{
        get {
            return _password
        }
        set(newValue) {
            self._password = newValue
        }
    }
    
    var device : String{
        get {
            return _device
        }
        set(newValue) {
            self._device = newValue
        }
    }
    
    var profession : String{
        get {
            return _profession
        }
        set(newValue) {
            self._profession = newValue
        }
    }
    
    var accountType : String{
        get {
            if _accountType == nil {
                return "Public"
            }
            else {
                return _accountType!
            }
            
        }
        set(newValue) {
            self._accountType = newValue
        }
    }

    
}
