//
//  QuestionsDBHandler.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/31/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol GetAllVideoQuestionsDelegate:class {
    func getAllVideoQuestions(questionsDict:NSMutableDictionary, key: String)
}

protocol GetFilteredVideoQuestionsDelegate:class {
    func getFilteredVideoQuestions(questionsDict:NSMutableDictionary, key: String)
}

protocol GetCommentsDelegate:class {
    func getAllComments(commentsDict: NSDictionary)
}

protocol GetAnswerCommentsDelegate:class {
    func getAnswerComments(commentsDict: NSDictionary)
}

protocol GetAnswersDelegate:class {
    func getAllAnswers(answersDict: NSMutableDictionary, key: String)
}

protocol GetQuestionThumbLinkDelegate:class {
    func getQuestionThumb(thumbLink: String)
}
protocol GetSingleQuestionDelegate:class {
    func getSingleQuestion(qDict: NSDictionary)
}

protocol UpdateVideosDelegate:class {
    func updateVideosList()
}

class QuestionsDBHandler {
    var hanlde: UInt = 0
    var commentOberver: UInt = 0
    private static let _instance = QuestionsDBHandler()
    private init() {}
    
    weak var getAllVideoQuestionsDelegate: GetAllVideoQuestionsDelegate?
    weak var getFilteredVideoQuestionsDelegate: GetFilteredVideoQuestionsDelegate?
    weak var getCommentsDelegate: GetCommentsDelegate?
    weak var getAnswersDelegate: GetAnswersDelegate?
    weak var getAnswerCommentsDelegate: GetAnswerCommentsDelegate?
    weak var getQuestionThumbLinkDelegate: GetQuestionThumbLinkDelegate?
    weak var getSingleQuestionDelegate: GetSingleQuestionDelegate?
    weak var updateVideoListDelegate: UpdateVideosDelegate?
    
    static var Instance: QuestionsDBHandler {
        return _instance
    }
    
    func getVideoQuestions() {
        DBProvider.Instance.questionsRef.queryOrdered(byChild: QUESTION_PRIORITY).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            self.getAllVideoQuestionsDelegate?.getAllVideoQuestions(questionsDict: snapshot.value as!NSMutableDictionary, key: snapshot.key)
        }
        
        DBProvider.Instance.questionsRef.queryOrdered(byChild: QUESTION_PRIORITY).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            
            self.getAllVideoQuestionsDelegate?.getAllVideoQuestions(questionsDict: snapshot.value as!NSMutableDictionary, key: snapshot.key)
        }
    }
    
    func getAllVideoQuestionsForSearch() {
        DBProvider.Instance.questionsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSMutableDictionary {
               self.getAllVideoQuestionsDelegate?.getAllVideoQuestions(questionsDict: snapshot.value as!NSMutableDictionary, key: snapshot.key)
            }
            
        })
    }
    
    func updateTimeLine() {
        DBProvider.Instance.questionsRef.queryOrdered(byChild: QUESTION_PRIORITY).observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            
            self.updateVideoListDelegate?.updateVideosList()
        }

    }
    
    func getQuestionComments(questionKey: String) {
        commentOberver = DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_COMMENTS_NODE).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            print(snapshot.childrenCount)
            //self.getAllVideoQuestionsDelegate?.getAllVideoQuestions(questionsDict: snapshot.value as!NSDictionary)
            self.getCommentsDelegate?.getAllComments(commentsDict: snapshot.value as! NSDictionary)
        }
    }
    
    // this below method is not being used
    
    func countQuestionComments(questionId: String) {
        DBProvider.Instance.questionsRef.child(questionId).child(QUESTION_COMMENTS_NODE).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.childrenCount)
        })
    }
    
    func getQuestionAnswers(questionKey: String) {
        hanlde = DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            self.getAnswersDelegate?.getAllAnswers(answersDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
        }
    }
    
    func removeAnswerObserver(questionKey: String) {
        DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).removeObserver(withHandle: hanlde)
    }
    
    func removeCommentsObserver(questionKey: String) {
        DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_COMMENTS_NODE).removeObserver(withHandle: commentOberver)
    }
    
    func getAnswerComments(answerKey: String, questionKey: String) {
        DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child(QUESTION_COMMENTS_NODE).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getAnswerCommentsDelegate?.getAnswerComments(commentsDict: snapshot.value as! NSDictionary)
        }
    }
    
    func getFilteredQuestionsWithCategory(category: String) {
        
        DBProvider.Instance.questionsRef.queryOrdered(byChild: QUESTION_CATEGORY).queryEqual(toValue: category).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getFilteredVideoQuestionsDelegate?.getFilteredVideoQuestions(questionsDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
        }
        
    }
    
    func getFilteredQuestionsWithUserId(userId: String) {
        
//        DBProvider.Instance.questionsRef.queryOrdered(byChild: QUESTION_USERID).queryEqual(toValue: userId).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
//            self.getFilteredVideoQuestionsDelegate?.getFilteredVideoQuestions(questionsDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
//        }
//
//        DBProvider.Instance.questionsRef.queryOrdered(byChild: QUESTION_USERID).queryEqual(toValue: userId).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
//            self.getFilteredVideoQuestionsDelegate?.getFilteredVideoQuestions(questionsDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
//        }
        
        DBProvider.Instance.userRef.child(userId).child("Questions").observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getFilterdVideos(quesId: snapshot.key)
        }
        
//        DBProvider.Instance.userRef.child(userId).child("Questions").observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
//            self.getFilterdVideos(quesId: snapshot.key)
//        }
        DBProvider.Instance.questionsRef.queryOrdered(byChild: QUESTION_USERID).queryEqual(toValue: userId).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            self.getFilteredVideoQuestionsDelegate?.getFilteredVideoQuestions(questionsDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
        }
        
    }
    
    func getFilterdVideos(quesId: String) {
//        DBProvider.Instance.questionsRef.child(quesId).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
//            self.getFilteredVideoQuestionsDelegate?.getFilteredVideoQuestions(questionsDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
//        }
//
//        
//        DBProvider.Instance.questionsRef.child(quesId).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
//            self.getFilteredVideoQuestionsDelegate?.getFilteredVideoQuestions(questionsDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
//        }
        
        DBProvider.Instance.questionsRef.child(quesId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSMutableDictionary {
                self.getFilteredVideoQuestionsDelegate?.getFilteredVideoQuestions(questionsDict: snapshot.value as! NSMutableDictionary, key: snapshot.key)
            }
            
            
        })
    }
    
    ////////////////////////////////////////////qestion lieks and comments methods
    
    func setLikeOfVideoQuestion(questionKey: String, isLiked: Bool) {
        DBProvider.Instance.questionsRef.child(questionKey).child("likes").observeSingleEvent(of: .value, with: { (snapshot) in
            print("hi")
            var totalLikes = snapshot.value as? String
            if isLiked {
                if totalLikes == nil {
                    totalLikes = String(1)
                }
                else {
                    totalLikes = String(Int(totalLikes!)! + 1)
                }
               
            }
            else {
                totalLikes = String(Int(totalLikes!)! - 1)
            }
            
            DBProvider.Instance.questionsRef.child(questionKey).child("likes").setValue(totalLikes)
        })
    }
    
    func setLikeOfVideoQuestionInQuestionNode(questionKey: String, userId: String, isLiked: Bool) {
        DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_LIKES_NODE).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            print("hi")
            if isLiked {
                DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_LIKES_NODE).child(userId).setValue(userId)
            }
            else {
                DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_LIKES_NODE).child(userId).removeValue()
            }
        })
    }
    func addCommentToQuestion(questionKey: String, userId: String, commentData: Comments) {
        DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_COMMENTS_NODE).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let uniqueId = DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_COMMENTS_NODE).childByAutoId().key
            let data: Dictionary<String, Any> = [QUESTION_COMMENTS_COMMENTTIME: commentData.commentTime,
                                                 QUESTION_COMMENTS_COMMENT: commentData.commentContent,
                                                 QUESTION_COMMENTS_COMMENTID: uniqueId,
                                                 QUESTION_COMMENTS_NAME: commentData.name,
                                                 QUESTION_COMMENTS_NUMBER: commentData.number
                ]
            DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_COMMENTS_NODE).child(uniqueId).setValue(data)
        })
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func setLikeOfVideoAnswer(questionKey: String, answerKey: String, isLiked: Bool) {
        DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child("likes").observeSingleEvent(of: .value, with: { (snapshot) in
            print("hi")
            var totalLikes = snapshot.value as? String
            if isLiked {
                if totalLikes == nil {
                    totalLikes = "1"
                }
                else {
                    totalLikes = String(Int(totalLikes!)! + 1)
                }
                
            }
            else {
                totalLikes = String(Int(totalLikes!)! - 1)
            }
            
            DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child("likes").setValue(totalLikes)
        })
    }
    
    func setLikeOfVideoAnswerInAnswerNode(questionKey: String, answerKey: String, userId: String, isLiked: Bool) {
        DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child("Likes").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            print("hi")
            if isLiked {
                DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child("Likes").child(userId).setValue(userId)
            }
            else {
                DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child("Likes").child(userId).removeValue()
            }
        })
    }
    
    func addCommentToAnswer(questionKey: String, answerKey: String, userId: String, commentData: Comments) {
        DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child("Comments").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let uniqueId = DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child("Comments").childByAutoId().key
            let data: Dictionary<String, Any> = [QUESTION_COMMENTS_COMMENTTIME: commentData.commentTime,
                                                 QUESTION_COMMENTS_COMMENT: commentData.commentContent,
                                                 QUESTION_COMMENTS_COMMENTID: uniqueId,
                                                 QUESTION_COMMENTS_NAME: commentData.name,
                                                 QUESTION_COMMENTS_NUMBER: commentData.number
            ]
            DBProvider.Instance.questionsRef.child(questionKey).child(QUESTION_ANSWERS_NODE).child(answerKey).child("Comments").child(uniqueId).setValue(data)
        })
    }
    
    func getQuestionByQuesId(questionId: String) {
        
        DBProvider.Instance.questionsRef.child(questionId).observeSingleEvent(of: .value, with: { (snapshot) in
           self.getSingleQuestionDelegate?.getSingleQuestion(qDict: snapshot.value as! NSDictionary)
        })
        
    }
    
    func addVideo(questionDict: Questions) {
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
           // let uniqueId = DBProvider.Instance.questionsRef.childByAutoId().key
            let data: Dictionary<String, Any> = [QUESTION_ANSID: questionDict.ansId,
                                                 QUESTION_COMMENTS: questionDict.comments,
                                                 QUESTION_DATE: NSNumber(value: Int(questionDict.date)!),
                                                 QUESTION_QUESID: questionDict.quesId,
                                                 QUESTION_SELECTED: false,
                                                 QUESTION_TAGS: questionDict.tag,
                                                 QUESTION_TITLE: questionDict.title,
                                                 QUESTION_USERID: accountId!,
                                                 QUESTION_VIDEOLINK: questionDict.videoLink,
                                                 QUESTION_VIDEOTHUMBLINK: questionDict.thumbLink,
                                                 QUESTION_LIKES: "0"
                                                 
            ]
          //  DBProvider.Instance.questionsRef.child(questionDict.quesId).setValue(data)
        DBProvider.Instance.questionsRef.child(questionDict.quesId).setValue(data) { (error, dbr) in
        }
        let data1: Dictionary<String, Any> = [questionDict.quesId: questionDict.quesId]
        
        DBProvider.Instance.userRef.child(accountId!).child("Questions").child(questionDict.quesId).setValue(questionDict.quesId)
    }
    
    func addVideoAnswer(answerDict: Answers, questionId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        //let uniqueId = DBProvider.Instance.questionsRef.child(questionId).child("Answers").childByAutoId().key
        let data: Dictionary<String, Any> = [ANSWER_ANSID: answerDict.ansId,
                                             ANSWER_COMMENTS: answerDict.comments,
                                             ANSWER_DATE: NSNumber(value: Int(answerDict.date)!),
                                             ANSWER_QUESID: questionId,
                                             ANSWER_SELECTED: false,
                                             ANSWER_USERID: accountId!,
                                             ANSWER_VIDEOLINK: answerDict.videoLink,
                                             ANSWER_VIDEOTHUMBLINK: answerDict.thumbLink,
                                             ANSWER_LIKES: "0"
            
        ]
        DBProvider.Instance.questionsRef.child(questionId).child("Answers").child(answerDict.ansId).setValue(data)
        
        DBProvider.Instance.answersRef.child(accountId!).child(answerDict.ansId).setValue(data)
    }
    
    func uploadQuestionThumb(dataToUpload: Data, uniqueId: String, questionId: String) {
        let newChild = uniqueId+".jpg"
        let newRef = DBProvider.Instance.questionThumbRef.child(newChild)
        
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            
            DispatchQueue.main.async {
                DBProvider.Instance.questionsRef.child(questionId).updateChildValues(["videoThumbLink" : (metadata.downloadURL()?.absoluteString)!])
                self.getQuestionThumbLinkDelegate?.getQuestionThumb(thumbLink: (metadata.downloadURL()?.absoluteString)!)
            }
            
        }
    }
    
    func uploadQuestionImage(dataToUpload: Data, uniqueId: String, questionId: String) {
        let newChild = uniqueId+".jpg"
        let newRef = DBProvider.Instance.questionImageRef.child(newChild)
        
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            DispatchQueue.main.async {
                DBProvider.Instance.questionsRef.child(questionId).updateChildValues(["videoThumbLink" : (metadata.downloadURL()?.absoluteString)!])
                self.getQuestionThumbLinkDelegate?.getQuestionThumb(thumbLink: (metadata.downloadURL()?.absoluteString)!)
            }
            
        }
    }
    
    func uploadQuestionVideoData(dataToUpload: Data, uniqueId: String, questionId: String) {
        
        let newChild = uniqueId+".mp4"
        let newRef = DBProvider.Instance.questionVideoRef.child(newChild)
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("network error no upload")
                QuestionsDBHandler.Instance.deleteSelectedVideo(videoId: questionId, isQuestion: true, questionId: questionId)
                
                return
            }

            DBProvider.Instance.questionsRef.child(questionId).updateChildValues(["videoLink" : (metadata.downloadURL()?.absoluteString)!])
        }
        
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let videoDataPath = documentsPath + "/" + "WATCH.mp4"
//        let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
//
//        newRef.putFile(from: tempUrl as URL, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                return
//            }
//
//            DBProvider.Instance.questionsRef.child(questionId).updateChildValues(["videoLink" : (metadata.downloadURL()?.absoluteString)!])
//        }
    }
    
    
    func deleteSelectedVideo(videoId: String, isQuestion: Bool, questionId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)!
        if isQuestion {
            DBProvider.Instance.userRef.child(accountId).child("Questions").child(videoId).removeValue()
            DBProvider.Instance.questionsRef.child(videoId).removeValue()
        }
        else {
            DBProvider.Instance.answersRef.child(accountId).child(videoId).removeValue()
            DBProvider.Instance.questionsRef.child(questionId).child(QUESTION_ANSWERS_NODE).child(videoId).removeValue()
        }
    }
    
    func getVideoQuestionById(questionId: String, answerId: String) {
        
        if answerId.characters.count > 3  {
            
             DBProvider.Instance.questionsRef.child(questionId).child("Answers").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(answerId) {
                    DBProvider.Instance.questionsRef.child(questionId).child("Answers").child(answerId).observeSingleEvent(of: .value, with: { (snapshot) in
                        self.getAnswersDelegate?.getAllAnswers(answersDict: snapshot.value as! NSMutableDictionary, key: "Answer")
                    })

                }
                
             })
            
//            DBProvider.Instance.questionsRef.child(questionId).child("Answers").child(answerId).observeSingleEvent(of: .value, with: { (snapshot) in
//                self.getAnswersDelegate?.getAllAnswers(answersDict: snapshot.value as! NSMutableDictionary, key: "Answer")
//            })
        }
        else if questionId.characters.count > 3 {
            
            DBProvider.Instance.questionsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(questionId) {
                    DBProvider.Instance.questionsRef.child(questionId).observeSingleEvent(of: .value, with: { (snapshot) in
                        self.getAnswersDelegate?.getAllAnswers(answersDict: snapshot.value as! NSMutableDictionary, key: "Question")
                    })
                }
                
            })
            
        }
        
        else if questionId.characters.count < 3 {
           // self.getAnswersDelegate?.getAllAnswers(answersDict: nil, key: "Question")
            
        }
        
    }
}

