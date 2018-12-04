//
//  User_Activities.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/1/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation

class UserActivities {
    
    private var _activities:String!
    private var _activityId:String!
    private var _answerId: String!
    private var _date: MyDate!
    private var _id: String!
    private var _profilePicture: String!
    private var _questionId: String!
    private var _userId: String!
    private var _userName: String!
    
    
    init() {
        
    }
    
    init(activityDict: NSDictionary) {
        _activities = activityDict["activities"] as? String
        _activityId = activityDict["activityId"] as? String
        _answerId = activityDict["answerId"] as? String
        _id = activityDict["id"] as? String
        _profilePicture = activityDict["profilePicture"] as? String
        _questionId = activityDict["questionId"] as? String
        _userId = activityDict["userId"] as? String
        _userName = activityDict["userName"] as? String
        
        
    }
    
    
    var activities : String{
        get {
            return _activities
        }
        set(newValue) {
            self._activities = newValue
        }
    }
    
    var activityId : String{
        get {
            return _activityId
        }
        set(newValue) {
            self._activityId = newValue
        }
    }
    
    var answerId : String{
        get {
            return _answerId
        }
        set(newValue) {
            self._answerId = newValue
        }
    }
    var date : MyDate{
        get {
            return _date
        }
        set(newValue) {
            self._date = newValue
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
    
    var profilePicture : String{
        get {
            return _profilePicture
        }
        set(newValue) {
            self._profilePicture = newValue
        }
    }
    var questionId : String{
        get {
            return _questionId
        }
        set(newValue) {
            self._questionId = newValue
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
    
    var userName : String{
        get {
            return _userName
        }
        set(newValue) {
            self._userName = newValue
        }
    }

}
