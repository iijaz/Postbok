//
//  AnswersDBHandler.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/31/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol GetUserAnswersDelegate:class {
    func getUserAnswers(answerDict:NSMutableDictionary, key: String)
}

protocol GetAnswerThumbLinkDelegate:class {
    func getAnswerThumb(thumbLink: String)
}
class AnswersDBHandler {
    private static let _instance = AnswersDBHandler()
    private init() {}
    weak var getAllUserAnswersDelegate: GetUserAnswersDelegate?
    weak var getAnswerThumblinkDelegate: GetAnswerThumbLinkDelegate?
    static var Instance: AnswersDBHandler {
        return _instance;
    }
    
    func getUserAnswers() {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        DBProvider.Instance.answersRef.child(accountId).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getAllUserAnswersDelegate?.getUserAnswers(answerDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
        }
        
        DBProvider.Instance.answersRef.child(accountId).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            self.getAllUserAnswersDelegate?.getUserAnswers(answerDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
        }
    }
    
    func uploadAnswerThumb(dataToUpload: Data, uniqueId: String, answerId: String, quesId: String) {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        let newChild = uniqueId+".jpg"
        let newRef = DBProvider.Instance.answerThumbRef.child(newChild)
        
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            DispatchQueue.main.async {
                DBProvider.Instance.answersRef.child(accountId).child(answerId).updateChildValues(["videoThumbLink" : (metadata.downloadURL()?.absoluteString)!])
                DBProvider.Instance.questionsRef.child(quesId).child("Answers").child(answerId).updateChildValues(["videoThumbLink" : (metadata.downloadURL()?.absoluteString)!])
                self.getAnswerThumblinkDelegate?.getAnswerThumb(thumbLink: (metadata.downloadURL()?.absoluteString)!)
            }
            
        }
    }
    
    func uploadAnswerVideo(dataToUpload: Data, uniqueId: String, answerId: String, quesId: String) {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        let newChild = uniqueId+".mp4"
        let newRef = DBProvider.Instance.answerVideoRef.child(newChild)
        
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            DispatchQueue.main.async {
                DBProvider.Instance.answersRef.child(accountId).child(answerId).updateChildValues(["videoLink" : (metadata.downloadURL()?.absoluteString)!])
                DBProvider.Instance.questionsRef.child(quesId).child("Answers").child(answerId).updateChildValues(["videoLink" : (metadata.downloadURL()?.absoluteString)!])
            }
            
        }
    }
}
