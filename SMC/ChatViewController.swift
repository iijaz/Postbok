//
//  ChatViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/10/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit
import Firebase
import Social
class ChatViewController: UIViewController, GetConversationDelegate, GetOnlineUserDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lastSeen: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noProfileImageView: UIImageView!
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var bottomSpaceConstraints: NSLayoutConstraint!
    
    var conversationId: String?
    var selectedUser: User?
    var allMessages = [Conversation]()
    let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
    var accountUser: User?
    var observerFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBlockedUser()
        
        if selectedUser?.id == "16475566924" {
            textView.isUserInteractionEnabled = false
            placeHolderLabel.text = "You can't reply to this message"
            UserDefaults.standard.setValue(false, forKey: "isNewUser")
        }
        
        
        if selectedUser?.online == "true" {
            lastSeen.text = "online"
        }
        else {
           lastSeen.text = selectedUser?.lastSeen
            lastSeen.text = ""
        }
        
        userName.text = selectedUser?.username
        
        // let sTime = NSNumber(value: Int((selectedUser?.lastSeen)!)!)
        let sTime = NSNumber(value: (Int((selectedUser?.lastSeen)!))!)
        lastSeen.text = Common.convertDate(dateInteger: sTime)
        let profileUrl = URL(string: (selectedUser?.profile)!)
        lastSeen.text = ""
        userImageView.kf.setImage(with: profileUrl)
        userImageView.roundImageView()
        
        if (selectedUser?.profile.characters.count)! < 2 {
            //userImageView.isHidden = true
            userImageView.backgroundColor = UIColor.white
        }
        else {
            noProfileImageView.isHidden = true
        }
        
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = UIColor.darkGray.cgColor
        
        let userdict = UserDefaults.standard.value(forKey: USER_DICT)
        accountUser = User(userdict: userdict as! NSDictionary)
        ChatingDBHandler.Instance.getConversationDelegate = self
        if conversationId != "1" {
            ChatingDBHandler.Instance.getConversationByConvId(convId: conversationId!)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tableViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped(tapGestureRecognizer:)))
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tableViewTapGestureRecognizer)
        
        UserDBHandler.Instance.getOnlineUserDelegate = self
        UserDBHandler.Instance.getOnlineUserStatus(userId: (selectedUser?.id)!)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        // Do any additional setup after loading the view.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        DBProvider.Instance.userRef.child(accountId!).child("message").child((selectedUser?.id)!).removeValue()
        DBProvider.Instance.userRef.child(accountId!).child("notification").setValue("0")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        checkBlockedUser()
        
        ChatingDBHandler.Instance.removeConversationObserver(convId: conversationId!)
      DBProvider.Instance.userRef.child(accountId!).child("message").child((selectedUser?.id)!).removeValue()
        DBProvider.Instance.userRef.child(accountId!).child("notification").setValue("0")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if self.presentingViewController == nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkBlockedUser() {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child("GotBlocked").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                UserDefaults.standard.setValue(dict, forKey: GOT_BLOCKED)
                if let gotBlockedUsersList = UserDefaults.standard.value(forKey: GOT_BLOCKED) as? NSDictionary {
                    for gotBlockedId in gotBlockedUsersList.allKeys {
                        if self.selectedUser?.id == gotBlockedId as? String {
                            self.textView.isUserInteractionEnabled = false
                            self.profileBtn.isUserInteractionEnabled = false
                        }
                    }
                }
            }
        })
        
        if let blockedUsersList = UserDefaults.standard.value(forKey: BLOCKED_USERS) as? NSDictionary {
            for blockedId in blockedUsersList.allKeys {
                if self.selectedUser?.id == blockedId as? String {
                    self.textView.isUserInteractionEnabled = false
                    self.profileBtn.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    func getOnlineUser(userDict: NSDictionary) {
        let lUser = User(userdict: userDict)
        if lUser.online == "true" {
            lastSeen.text = "online"
        }
        else {
            lastSeen.text = lUser.lastSeen
            let sTime = NSNumber(value: (Int((lUser.lastSeen)))!)
            lastSeen.text = Common.convertDate(dateInteger: sTime)
            lastSeen.text = ""
        }
    }
    
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
    
    func keyboardWillHide(_ notification: NSNotification){
        bottomSpaceConstraints.constant = 1
    }
    
    func tableViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        textView.resignFirstResponder()
    }
    
    func getConversation(convDict:NSDictionary) {
        
        let msgString = convDict["msg"] as! String
        if msgString == ""  {
            return
        }
        if convDict["date"] == nil || convDict["date1"] == nil {
            return
        }
        let sender = convDict["sender"] as! String
        if sender == accountId! {
            //return
        }
        
        let lDate = MyDate(dateDict: convDict["date"] as! NSDictionary )
        let lDate1 = MyDate(dateDict: convDict["date1"] as! NSDictionary)
        let lConv = Conversation(conversationDict: convDict, date: lDate, date1: lDate1)
        if lConv.sender == accountId! && observerFlag {
            observerFlag = false
            return
        }
        
        allMessages.append(lConv)
        tableView.reloadData()
        self.scrollToLastRow()
        
    }
    
    func scrollToLastRow() {
        UIView.setAnimationsEnabled(false)
        // let indexPath = NSIndexPath(forRow: messages.count - 1, section: 0)
        if allMessages.count > 0 {
            let indexPath = IndexPath(row: allMessages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }
        UIView.setAnimationsEnabled(true)
        
    }
    
//    func sendTweet() {
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
//
//            // 2
//            let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//
//            // 3
//            if let tweetSheet = tweetSheet {
//                tweetSheet.setInitialText("Look at this nice picture!")
//                tweetSheet.add(userImageView.image)
//
//                // 4
//                self.present(tweetSheet, animated: true, completion: nil)
//            }
//        } else {
//
//            // 5
//            print("error")
//        }
//
//    }
    
    @IBAction func SendMessageAction(_ sender: UIButton) {
      //  ChatingDBHandler.Instance.removeConversationObserver(convId: conversationId!)
        if textView.text.characters.count == 0 {
            return
        }
        if selectedUser?.id == "16475566924" {
            return
        }
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekDay = calendar.component(.weekdayOrdinal, from: date)
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let ldate = MyDate()
        ldate.date = String(day)
        ldate.day = String(weekDay)
        ldate.hours = String(hours)
        ldate.minutes = String(minutes)
        ldate.months = String(month)
        ldate.seconds = String(seconds)
        ldate.time = String(Date().millisecondsSince1970)
        ldate.year = String(year)
        ldate.timezoneOffset = TimeZone.current.abbreviation()!
        
        let ldate1 = MyDate()
        ldate1.date = String(day)
        ldate1.day = String(weekDay)
        ldate1.hours = String(hours)
        ldate1.minutes = String(minutes)
        ldate1.months = String(month)
        ldate1.seconds = String(seconds)
        ldate1.time = String(Date().millisecondsSince1970)
        ldate1.year = String(year)
        ldate1.timezoneOffset = TimeZone.current.abbreviation()!
        
        let conv = Conversation()
        conv.messageContent = textView.text
        conv.receiver = (selectedUser?.id)!
        conv.sender = accountId!
        conv.sent = true
        conv.status = "1"
        conv.dateNode = ldate
        conv.date1Node = ldate1
        
        textView.text = ""
        placeHolderLabel.isHidden = false
        
        allMessages.append(conv)
        observerFlag = true
        ChatingDBHandler.Instance.addMessage(convers: conv, convsationId: conversationId!)
        if selectedUser?.device == "iphone" {
              //Common.sendPusNotification(userNumber: (accountUser?.username)!, title: "", body: conv.messageContent, fcmID: (selectedUser?.mFcmId)!)
        }
        else {
           //Common.sendPusNotificationToAndroid(userNumber:(accountUser?.username)!, title: "temp", body: conv.messageContent, fcmID: (selectedUser?.mFcmId)!)
        }
        
       // Common.sendPusNotification(userNumber:"ijaz0066", title: "a", body: conv.messageContent, fcmID: "d2XGU6roAVg:APA91bF2w9khMlK3oAMdAslgfib2ixnOMkMDlD6nbqPF7g9-tw3ovgmsy4MMwTN8QDrl9Hi93YicFLpITKk0pGRsoo5UYl7Smg8HyhcoCiUW8MynOG9BVRWse0BM82O0tNbu3aW35UHD")
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.allMessages.count-1, section: 0)
            UIView.setAnimationsEnabled(false)
            self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.none)
            UIView.setAnimationsEnabled(true)
            self.scrollToLastRow()
        }
        
        
        
        
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        
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
    
    @IBAction func GoToUserProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfile" {
            let nextScene = segue.destination as! UserProfileViewController
            nextScene.selectedUser = selectedUser
        }
    }
    

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedUser?.id == "16475566924" {
            return 1
        }
        return allMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        if selectedUser?.id == "16475566924" {
            cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath as IndexPath)
            let profileString = selectedUser?.profile
            
            let profileImgView = cell.viewWithTag(1) as! UIImageView
            let noProfileImgView = cell.viewWithTag(3) as! UIImageView
            let dateLabel = cell.viewWithTag(4) as! UILabel
            let msgText = cell.viewWithTag(2) as! UILabel
            
            let profileUrl = URL(string: profileString!)
            profileImgView.kf.setImage(with: profileUrl)
            profileImgView.roundImageView()
            dateLabel.isHidden = true
            msgText.text = "Welcome to Your Social Media Crad (Smc) powered by Anna. Our team thank you for being amongst the first supporters of the beta version.  SMC is free for all our users, but our first batch of early users will get every future feature for free for life, as a token of appreciation for Your initial support and feedback.Thanks Again!"
            noProfileImgView.isHidden = true
            return cell
            
        }
        let lMessage = allMessages[indexPath.row]
        let senderDate = lMessage.dateNode
        let receiveDate = lMessage.date1Node
        let senderNumber = lMessage.sender
        let profileString: String?
        let dateString: String?
        if senderNumber == accountId {
            cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath as IndexPath)
            profileString = accountUser?.profile
            let sTime = NSNumber(value: Int(senderDate.time)!)
            dateString = Common.convertDate(dateInteger: sTime)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath as IndexPath)
            profileString = selectedUser?.profile
            let sTime = NSNumber(value: Int(receiveDate.time)!)
            dateString = Common.convertDate(dateInteger: sTime)
        }
//        
        let profileImgView = cell.viewWithTag(1) as! UIImageView
        let noProfileImgView = cell.viewWithTag(3) as! UIImageView
        let dateLabel = cell.viewWithTag(4) as! UILabel
        let msgText = cell.viewWithTag(2) as! UILabel
        if (profileString?.characters.count)! < 2 {
            noProfileImgView.isHidden = false
            profileImgView.isHidden = true
            
        }
        else {
            noProfileImgView.isHidden = true
            profileImgView.isHidden = false
            let profileUrl = URL(string: profileString!)
            profileImgView.kf.setImage(with: profileUrl)
        }
//        
//        userNmae.text = lUser.username
        msgText.text = lMessage.messageContent
        dateLabel.text = dateString
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

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        }
        else {
            placeHolderLabel.isHidden = true
        }
    }
}
