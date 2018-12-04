//
//  Conversations.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/1/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation

class Conversation {
    
    private var _dateNode: MyDate!
    private var _date1Node: MyDate!
    private var _messageContent: String!
    private var _messageId: String!
    private var _photoUrl: String!
    private var _receiver: String!
    private var _sender: String!
    private var _sent: Bool!
    private var _status: String!
    
    
    init() {
        
    }
    
    init(conversationDict: NSDictionary, date: MyDate, date1: MyDate) {
        _messageContent = conversationDict["msg"] as! String
        _messageId = conversationDict["msgId"] as! String
        //_photoUrl = conversationDict["photUrl"] as! String
        _receiver = conversationDict["receiver"] as! String
        _sender = conversationDict["sender"] as! String
        _sent = conversationDict["sent"] as! Bool
        _status = String(describing: conversationDict["status"] as! NSNumber)
        
        _dateNode = date
        _date1Node = date1
    }
    
    
    var dateNode : MyDate{
        get {
            return _dateNode
        }
        set(newValue) {
            self._dateNode = newValue
        }
    }
    
    var date1Node : MyDate{
        get {
            return _date1Node
        }
        set(newValue) {
            self._date1Node = newValue
        }
    }
    
    var messageContent : String{
        get {
            return _messageContent
        }
        set(newValue) {
            self._messageContent = newValue
        }
    }
    var messageId : String{
        get {
            return _messageId
        }
        set(newValue) {
            self._messageId = newValue
        }
    }
    var photoUrl : String{
        get {
            return _photoUrl
        }
        set(newValue) {
            self._photoUrl = newValue
        }
    }
    
    var sender : String{
        get {
            return _sender
        }
        set(newValue) {
            self._sender = newValue
        }
    }
    var receiver : String{
        get {
            return _receiver
        }
        set(newValue) {
            self._receiver = newValue
        }
    }
    
    var status : String{
        get {
            return _status
        }
        set(newValue) {
            self._status = newValue
        }
    }
    
    var  sent : Bool{
        get {
            return _sent
        }
        set(newValue) {
            self._sent = newValue
        }
    }

}
