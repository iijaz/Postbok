//
//  ChatingDBHandler.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/31/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol GetChatUsersDelegate:class {
    func getChatUsers(userDict:NSDictionary, conversationId: String, time: Int)
}

protocol GetConversationDelegate:class {
    func getConversation(convDict:NSDictionary)
}

protocol GetConvIdDelegate:class {
    func getConvId(convId:String)
}

class ChatingDBHandler {
    var hanlde: UInt = 0
    var handle1: UInt = 0
    private static let _instance = ChatingDBHandler()
    private init() {}
    
    weak var getChatUsersDelegate: GetChatUsersDelegate?
    weak var getConversationDelegate: GetConversationDelegate?
    weak var getConvIdDelegate: GetConvIdDelegate?
    
    static var Instance: ChatingDBHandler {
        return _instance;
    }
    
    func getChatUsers(accounId: String) {
        
        DBProvider.Instance.codeviseChattingRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            if snapshot.key.contains(accounId) {
                let uId: String?
                let convId = snapshot.key.components(separatedBy: "_")
                
                if convId[0] == accounId {
                    uId = convId[1]
                }
                else {
                    uId = convId[0]
                }
                let snapDict = snapshot.value as! NSDictionary
                let dateArr = snapDict.allKeys as NSArray
                let dateDict = snapDict[dateArr.lastObject as Any] as! NSDictionary
                let lastDict = dateDict["date"] as! NSDictionary
                let time = lastDict["time"] as! Int
                
                DBProvider.Instance.userRef.child(uId!).observeSingleEvent(of: .value, with: { (sShot) in
                    self.getChatUsersDelegate?.getChatUsers(userDict: sShot.value as! NSDictionary, conversationId: snapshot.key, time: time)
                })
            }
        }
    }
    
    func getConversationByConvId(convId: String) {
       hanlde = DBProvider.Instance.codeviseChattingRef.child(convId).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in

            self.getConversationDelegate?.getConversation(convDict: snapshot.value as! NSDictionary)
        }
        
        handle1 = DBProvider.Instance.codeviseChattingRef.child(convId).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            
            //self.getConversationDelegate?.getConversation(convDict: snapshot.value as! NSDictionary)
        }
                
    }
    
    func removeConversationObserver(convId: String) {
        DBProvider.Instance.codeviseChattingRef.child(convId).removeObserver(withHandle: hanlde)
        DBProvider.Instance.codeviseChattingRef.child(convId).removeObserver(withHandle: handle1)
        }
    
    func addMessage(convers: Conversation, convsationId: String) {
        let lSenderDate = convers.dateNode
        let lReceiverDate = convers.date1Node
        
        //DBProvider.Instance.codeviseChattingRef.child(convsationId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let uniqueId = DBProvider.Instance.codeviseChattingRef.child(convsationId).childByAutoId().key
        
            let data: Dictionary<String, Any> = [CODEVISECHATING_MSG: convers.messageContent,
                                                 CODEVISECHATING_MSGID: uniqueId,
                                                 CODEVISECHATING_RECEIVER: convers.receiver,
                                                 CODEVISECHATING_SENDER: convers.sender,
                                                 CODEVISECHATING_SENT: convers.sent,
                                                 CODEVISECHATING_STATUS: NSNumber(value: Int(convers.status)!)
            ]
          //  DBProvider.Instance.codeviseChattingRef.child(convsationId).child(uniqueId).setValue(data)
        
        
        
        let data1: Dictionary<String, Any> = ["date": NSNumber(value: Int(lSenderDate.date)!),
                                              "day": NSNumber(value: Int(lSenderDate.day)!),
                                              "hours": NSNumber(value: Int(lSenderDate.hours)!),
                                              "minutes": NSNumber(value: Int(lSenderDate.minutes)!),
                                              "month": NSNumber(value: Int(lSenderDate.months)!),
                                              "seconds": NSNumber(value: Int(lSenderDate.seconds)!),
                                              "time": NSNumber(value: Int(lSenderDate.time)!),
                                              "timezoneOffset": NSNumber(value: 500),
                                              "year": NSNumber(value: Int(lSenderDate.year)!)
            
        ]
        
      //  DBProvider.Instance.codeviseChattingRef.child(convsationId).child(uniqueId).child("date").setValue(data1)
        DBProvider.Instance.userRef.child(convers.receiver).child("message").child(convers.sender).setValue(convers.sender)
        DBProvider.Instance.userRef.child(convers.receiver).child("notification").setValue("1")
        
        let data2: Dictionary<String, Any> = ["date": NSNumber(value: Int(lReceiverDate.date)!),
                                              "day": NSNumber(value: Int(lReceiverDate.day)!),
                                              "hours": NSNumber(value: Int(lReceiverDate.hours)!),
                                              "minutes": NSNumber(value: Int(lReceiverDate.minutes)!),
                                              "month": NSNumber(value: Int(lReceiverDate.months)!),
                                              "seconds": NSNumber(value: Int(lReceiverDate.seconds)!),
                                              "time": NSNumber(value: Int(lReceiverDate.time)!),
                                              "timezoneOffset": NSNumber(value: 500),
                                              "year": NSNumber(value: Int(lReceiverDate.year)!)
            
        ]
        
        
        let datea: Dictionary<String, Any> = [CODEVISECHATING_MSG: convers.messageContent,
                                             CODEVISECHATING_MSGID: uniqueId,
                                             CODEVISECHATING_RECEIVER: convers.receiver,
                                             CODEVISECHATING_SENDER: convers.sender,
                                             CODEVISECHATING_SENT: convers.sent,
                                             "date": data1,
                                             "date1": data2,
                                             CODEVISECHATING_STATUS: NSNumber(value: Int(convers.status)!)
        ]
        DBProvider.Instance.codeviseChattingRef.child(convsationId).child(uniqueId).setValue(datea)
        
      //  DBProvider.Instance.codeviseChattingRef.child(convsationId).child(uniqueId).child("date1").setValue(data2)
    }
    
    func getConvId(userId: String, accountId: String) {
        
        DBProvider.Instance.codeviseChattingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let chatingKey1 = userId+"_"+accountId
            let chatingKey2 = accountId+"_"+userId
            
            if snapshot.hasChild(chatingKey1) {
                self.getConvIdDelegate?.getConvId(convId: chatingKey1)
            }
            else {
                self.getConvIdDelegate?.getConvId(convId: chatingKey2)
                
            }
            
            //self.checkUserFollowingDelegate?.checkIsUserFollowing(followed: snapshot.hasChild(userId))
            
        })
    }
}
