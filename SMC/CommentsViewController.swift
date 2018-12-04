//
//  CommentsViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/6/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, GetSingleUserDelegate, GetCommentsDelegate, GetAnswerCommentsDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    var callDelegate: Bool = false
    var videoUser: User?
    
    ////Constraints outlets
    @IBOutlet weak var bottomSpaceConstraints: NSLayoutConstraint!

    
    
    var allComments = [Comments]()
    var arrayOfCommentsUsers = [User]()
    var selectedVideo: NSDictionary?
    var questionKey: String?
    var typeOfVideo: String?
    let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
    let userName = UserDefaults.standard.string(forKey: USER_SERVER_NAME)
    let user = User(userdict: UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if typeOfVideo == "question" {
            QuestionsDBHandler.Instance.getCommentsDelegate = self
            QuestionsDBHandler.Instance.getQuestionComments(questionKey: selectedVideo?["key"] as! String)
        }
        else {
            QuestionsDBHandler.Instance.getAnswerCommentsDelegate = self
            QuestionsDBHandler.Instance.getAnswerComments(answerKey: selectedVideo?["key"] as! String, questionKey: questionKey!)
        }
        
        
        tableView.tableFooterView = UIView.init()
        UserDBHandler.Instance.getSingleUserDelegate = self
        self.getCommentsUsers()
        
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = UIColor.darkGray.cgColor
        
        ///keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tableViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped(tapGestureRecognizer:)))
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tableViewTapGestureRecognizer)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getAllComments(commentsDict: NSDictionary) {
        if callDelegate {
            //callDelegate = false
            return
        }
        let pComment = Comments()
        pComment.commentId = commentsDict["commentId"] as! String
        pComment.commentContent = commentsDict["comment"] as! String
        pComment.commentTime = commentsDict["comentTime"] as! String
        pComment.name = commentsDict["name"] as! String
        pComment.number = commentsDict["number"] as! String
        allComments.append(pComment)
        
        UserDBHandler.Instance.getSingleUserDelegate = self
        self.getCommentsUsers()
        
        tableView.reloadData()
    }
    
    func getAnswerComments(commentsDict: NSDictionary) {
        if callDelegate {
           // callDelegate = false
            return
        }
        let pComment = Comments()
        pComment.commentId = commentsDict["commentId"] as! String
        pComment.commentContent = commentsDict["comment"] as! String
        pComment.commentTime = commentsDict["comentTime"] as! String
        pComment.name = commentsDict["name"] as! String
        pComment.number = commentsDict["number"] as! String
        
        allComments.append(pComment)
        
        UserDBHandler.Instance.getSingleUserDelegate = self
        self.getCommentsUsers()
        tableView.reloadData()
    }
    
    ///////////////////////////////////////////////////////keyboar methods//////////////////////////////////////////////////////
    
    func keyboardWillShow(_ notification: NSNotification){
        var keyboardHeight: CGFloat?
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            bottomSpaceConstraints.constant = keyboardRectangle.height
            
//            var contentInsets:UIEdgeInsets
//            contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight!, 0.0)
//            self.tableView.contentInset = contentInsets
//            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
            DispatchQueue.main.async {
                UIView.setAnimationsEnabled(false)
                self.tableView.beginUpdates()
                
                self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
                self.tableView.endUpdates()
                self.scrollToLastRow()
                UIView.setAnimationsEnabled(true)
                
            }

        }
        
    }
    
    func scrollToLastRow() {
        UIView.setAnimationsEnabled(false)
        // let indexPath = NSIndexPath(forRow: messages.count - 1, section: 0)
        if arrayOfCommentsUsers.count > 0 {
            let indexPath = IndexPath(row: arrayOfCommentsUsers.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        bottomSpaceConstraints.constant = 1
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////delegates/////////////////////////////////////////////////////////
    
    func getSingleUser(userDict:NSDictionary) {
        if callDelegate {
            let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
            let lUser = User(userdict: userDict)
            videoUser = lUser
            
            if typeOfVideo == "question" {
                var activityString: String!
                var otherString: String!
                let commentString: String!
                if selectedVideo?["videoLink"] as! String == "" {
                    activityString = "You Commented on "+lUser.username+" Image"
                    otherString = uniqueName+" Commented on your Image"
                    commentString = uniqueName+" commented on your Image"
                }
                else {
                    activityString = "You Commented on "+lUser.username+" video"
                    otherString = uniqueName+" Commented on your video"
                    commentString = uniqueName+" commented on your video"
                }
                
                UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: selectedVideo?["key"] as! String, answerId: "", otherString: otherString, userId: lUser.id)
                
                if videoUser?.device == "iphone" {
                    Common.sendPusNotification(userNumber: uniqueName, title: "", body: commentString, fcmID: (videoUser?.mFcmId)!)
                }
                else {
                    Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "temp", body: commentString, fcmID: (videoUser?.mFcmId)!)
                }
            }
            else {
                let activityString = "You Commented on "+lUser.username+" response"
                let otherString = uniqueName+" Commented on your response"
                UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: questionKey!, answerId: selectedVideo?["key"] as! String, otherString: otherString, userId: lUser.id)
                let commentString = uniqueName+" commented on your video"
                if videoUser?.device == "iphone" {
                    Common.sendPusNotification(userNumber: uniqueName, title: "", body: commentString, fcmID: (videoUser?.mFcmId)!)
                }
                else {
                    Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "", body: commentString, fcmID: (videoUser?.mFcmId)!)
                }
                
            }
            
            return
        }
        let lUser = User(userdict: userDict)
        arrayOfCommentsUsers.append(lUser)
        tableView.reloadData()
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func getCommentsUsers() {
//        for lComment in allComments {
//            UserDBHandler.Instance.getSingleUser(userId: lComment.number)
//        }
        if allComments.count > 0 {
            UserDBHandler.Instance.getSingleUser(userId: allComments[allComments.count-1].number)
        }
        
    }
    
    func tableViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        textView.resignFirstResponder()
    }
    


    @IBAction func goBack(_ sender: UIButton) {
        
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                self.navigationController?.popViewController(animated: true)
                return
            }
        }

        
        if self.presentingViewController == nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func PostComment(_ sender: UIButton) {
        if textView.text.characters.count == 0 {
            return
        }
        let pComment = Comments()
        pComment.commentContent = textView.text
        pComment.commentId = "1"
        pComment.commentTime = Common.convertDateToString(lDate: Date())
        pComment.name = userName!
        pComment.number = accountId!
        
        textView.text = ""
        placeHolderLabel.isHidden = false
        callDelegate = true
        UserDBHandler.Instance.getSingleUser(userId: selectedVideo?["userId"] as! String)
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        if typeOfVideo == "question" {
            QuestionsDBHandler.Instance.addCommentToQuestion(questionKey: selectedVideo?["key"] as! String, userId: accountId!, commentData: pComment)
        }
        else {
            QuestionsDBHandler.Instance.addCommentToAnswer(questionKey: questionKey!, answerKey: selectedVideo?["key"] as! String, userId: accountId!, commentData: pComment)
            let commentString = uniqueName+" commented on your response"
            if videoUser?.device == "iphone" {
              //  Common.sendPusNotification(userNumber: uniqueName, title: "", body: commentString, fcmID: (videoUser?.mFcmId)!)
            }
            else {
               // Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "", body: commentString, fcmID: (videoUser?.mFcmId)!)
            }
            
            
        }
        allComments.append(pComment)
        arrayOfCommentsUsers.append(user)
        DBProvider.Instance.userRef.child(selectedVideo?["userId"] as! String).child("activities").setValue("1")
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.arrayOfCommentsUsers.count-1, section: 0)
            UIView.setAnimationsEnabled(false)
            self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.none)
            UIView.setAnimationsEnabled(true)
            self.scrollToLastRow()
        }
    }
    
    
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCommentsUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var cell : UITableViewCell
        let lComment = allComments[indexPath.item]
        let lUser = arrayOfCommentsUsers[indexPath.row]
        let profileString = lUser.profile
        if (profileString.characters.count) < 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "noProfileCell", for: indexPath as IndexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath as IndexPath)
        }
        
        let profileImgView = cell.viewWithTag(1) as! UIImageView
        let userNmae = cell.viewWithTag(2) as! UILabel
        let commentText = cell.viewWithTag(3) as! UILabel
        if (profileString.characters.count) < 2 {
            print("no image")
        }
        else {
            let profileUrl = URL(string: profileString)
            profileImgView.kf.setImage(with: profileUrl)
            profileImgView.layer.borderWidth = 1.0
        }
        
        userNmae.text = lUser.username
        commentText.text = lComment.commentContent
        
        profileImgView.roundImageView()
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}

extension CommentsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        }
        else {
            placeHolderLabel.isHidden = true
        }
    }
}
