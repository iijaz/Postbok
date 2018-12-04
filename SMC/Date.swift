//
//  Date.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/1/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation

class MyDate {
    
    private var _date:String!
    private var _day:String!
    private var _hours: String!
    private var _minutes: String!
    private var _months: String!
    private var _seconds: String!
    private var _time: String!
    private var _timezoneOffset: String!
    private var _year: String!
    
    
    init() {
        
    }
    
    init(dateDict: NSDictionary) {
        _date = String(describing: dateDict["date"] as! NSNumber)
        _day = String(describing: dateDict["day"] as! NSNumber)
        _hours = String(describing: dateDict["hours"] as! NSNumber)
        _minutes = String(describing: dateDict["minutes"] as! NSNumber)
        _months = String(describing: dateDict["month"] as! NSNumber)
        _seconds = String(describing: dateDict["seconds"] as! NSNumber)
        _time = String(describing: dateDict["time"] as! NSNumber)
        _timezoneOffset = String(describing: dateDict["timezoneOffset"] as! NSNumber)
    }
    
    
    var date : String{
        get {
            return _date
        }
        set(newValue) {
            self._date = newValue
        }
    }
    
    var day : String{
        get {
            return _day
        }
        set(newValue) {
            self._day = newValue
        }
    }
    
    var hours : String{
        get {
            return _hours
        }
        set(newValue) {
            self._hours = newValue
        }
    }
    var minutes : String{
        get {
            return _minutes
        }
        set(newValue) {
            self._minutes = newValue
        }
    }
    var seconds : String{
        get {
            return _seconds
        }
        set(newValue) {
            self._seconds = newValue
        }
    }
    
    var timezoneOffset : String{
        get {
            return _timezoneOffset
        }
        set(newValue) {
            self._timezoneOffset = newValue
        }
    }
    var time : String{
        get {
            return _time
        }
        set(newValue) {
            self._time = newValue
        }
    }
    
    var year : String{
        get {
            return _year
        }
        set(newValue) {
            self._year = newValue
        }
    }
    
    var  months : String{
        get {
            return _months
        }
        set(newValue) {
            self._months = newValue
        }
    }

}
