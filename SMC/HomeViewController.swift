//
//  HomeViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/30/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//



import UIKit
import AVKit
import AVFoundation
import Kingfisher

class HomeViewController: UIViewController, GetAllUsersDelegate, GetAllVideoQuestionsDelegate, GetFilteredVideoQuestionsDelegate, GetSingleUserDelegate, UpdateVideosDelegate, IsQuestionLikedDelegate {
    
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    @IBOutlet weak var topCodeVisersCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var largeImageView: UIImageView!
    
    @IBOutlet weak var noPostLabel: UILabel!
    
    @IBOutlet weak var largePictureView: UIView!
    // categories array data which is shown in collection view
    var categories = ["Popular", "IOS", "Android", "Tech Tips", "Coding", "Front End", "Back End", "Languages", "Geeky Stuff", "UI UX", "Marketing"]
    var selectedItem = 0 as Int
    var arrayOfUsers = [User]()
    var arrayOfVideoQuestions = [NSMutableDictionary]()
    var arrayOfStaticVideoQuestions = [NSMutableDictionary]()
    var selectedVideo: NSDictionary?
    var selectedUser: User?
    var loadCount = 0
    var arrayOfVideosUsers = [User]()
    var selectedQuestion: NSMutableDictionary?
    var callDelegate: Bool = false
    var notificationFlag: Bool = false
   // let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImageView.image = UIImage.gif(name: "loadinganimation")
        UserDefaults.standard.setValue("HomeScreen", forKey: INITIAL_CONTROLLER)
        loadCount = 1
        if (UserDefaults.standard.value(forKey: "videoArray") != nil) {
            arrayOfStaticVideoQuestions = UserDefaults.standard.value(forKey: "videoArray") as! [NSMutableDictionary]
        }
        
        setAllDelegates()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
//        if loadCount == 0 {
//            QuestionsDBHandler.Instance.getAllVideoQuestionsDelegate = self
//            QuestionsDBHandler.Instance.getVideoQuestions()
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            if self.arrayOfVideoQuestions.count == 0 {
                self.loadingImageView.isHidden = true
                self.noPostLabel.isHidden = false
                self.tableView.reloadData()
            }
        })
        
        tableView.reloadData()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadCount = 0
    }
    
    func setAllDelegates() {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        UserDBHandler.Instance.getAllUsersDelegate = self
        UserDBHandler.Instance.getSingleUserDelegate = self
        QuestionsDBHandler.Instance.getAllVideoQuestionsDelegate = self
        QuestionsDBHandler.Instance.getFilteredVideoQuestionsDelegate = self
        QuestionsDBHandler.Instance.updateVideoListDelegate = self
        UserDBHandler.Instance.isQuestionLikedDelegate = self
        
        UserDBHandler.Instance.getUsers()
        UserDBHandler.Instance.getSingleUser(userId: accountId!)
        QuestionsDBHandler.Instance.getVideoQuestions()
        
        QuestionsDBHandler.Instance.updateTimeLine()
    }
    
    //////////////////////////////All delegates////////////////////////////////////////////////////////
    
    func updateVideosList() {
        arrayOfVideoQuestions.removeAll()
        QuestionsDBHandler.Instance.getVideoQuestions()
    }
    
    func getAllUsers(userDict:NSDictionary) {
        if userDict["name"] == nil {
            return
        }
        let lUser = User(userdict: userDict)
        arrayOfUsers.insert(lUser, at: 0)
        topCodeVisersCollectionView.reloadData()
        
    }
    
    func getAllVideoQuestions(questionsDict:NSMutableDictionary, key: String) {
        //arrayOfVideoQuestions.append(questionsDict)
        if loadCount == 1 {
            loadCount = 0
            arrayOfVideoQuestions.removeAll()
        }
        
        
        
        if questionsDict["quesId"] as? String == nil {
            return
        }
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let uId =  questionsDict["userId"] as! String
        DispatchQueue.main.async {
            DBProvider
                .Instance.userRef.child(uId).child(USER_ACCOUNT_TYPE).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let accountTypeVal = snapshot.value as? String {
                        if accountTypeVal.lowercased() == "private" {
                            
                            DBProvider.Instance.userRef.child(uId).child(USER_USERFOLLOWERS_NODE).child(accountId!).observeSingleEvent(of: .value, with: { (snapshot) in
                                if let likedVal = snapshot.value as? String {
                                    print(likedVal)
                                    //self.isBeingFollowedDelegate?.isBeingFollowed(followed: true)
                                }
                                else {
                                    let ind = self.arrayOfVideoQuestions.index(of: questionsDict)
                                    self.arrayOfVideoQuestions.remove(at: ind!)
                                    self.tableView.reloadData()
                                    return
                                }
                            })
                            
                        }
                    }
                })
        }
        
        
        
        if let blockedUsersList = UserDefaults.standard.value(forKey: BLOCKED_USERS) as? NSDictionary {
            for blockedId in blockedUsersList.allKeys {
                if questionsDict["userId"] as! String == blockedId as! String {
                    return
                }
            }
        }
        if let gotBlockedUsersList = UserDefaults.standard.value(forKey: GOT_BLOCKED) as? NSDictionary {
            for gotBlockedId in gotBlockedUsersList.allKeys {
                if questionsDict["userId"] as! String == gotBlockedId as! String {
                    return
                }
            }
        }
        
        if let reportedPostList = UserDefaults.standard.value(forKey: REPORTED_POSTS) as? NSDictionary {
            for reportedPostId in reportedPostList.allKeys {
                if questionsDict["quesId"] as! String == reportedPostId as! String {
                    return
                }
            }
        }


        
        
        let questionId = questionsDict["quesId"] as! String
         var sArray = arrayOfVideoQuestions.filter() {
            
            ($0["quesId"] as! String).contains((questionId))
            
        }
        if sArray.count > 0 {
           let ind = arrayOfVideoQuestions.index(of: sArray[0])
            arrayOfVideoQuestions.remove(at: ind!)
            let dic = sArray[0]
            questionsDict["isliked"] = dic["isliked"]
            questionsDict["key"] = key
            arrayOfVideoQuestions.insert(questionsDict, at: ind!)
            let indexPath = IndexPath(row: ind!, section: 0)
            //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            tableView.reloadData()
           // sArray[0] = questionsDict
            return
        }
        if questionsDict["videoThumbLink"] as! String == "" || questionsDict["date"] as! NSNumber == 0 {
            return
        }
        questionsDict["key"] = key
        questionsDict["isliked"] = "false"
        if key == "Questions"{
            return
        }
        
        DBProvider
            .Instance.userRef.child(accountId!).child(USER_LIKE_NODE).child(questionsDict["quesId"] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            if let likedVal = snapshot.value as? String {
                print(likedVal)
                questionsDict["isliked"] = "true"
                self.arrayOfVideoQuestions.insert(questionsDict, at: 0)
                self.callDelegate = true
                UserDBHandler.Instance.getSingleUserDelegate = self
                UserDBHandler.Instance.getSingleUser(userId: questionsDict["userId"] as! String)
            }
            else {
                questionsDict["isliked"] = "false"
                self.arrayOfVideoQuestions.insert(questionsDict, at: 0)
                self.callDelegate = true
                UserDBHandler.Instance.getSingleUserDelegate = self
                UserDBHandler.Instance.getSingleUser(userId: questionsDict["userId"] as! String)
            }
        })
        
        
    }
    
    func getFilteredVideoQuestions(questionsDict:NSMutableDictionary, key: String) {
        questionsDict["key"] = key
        if questionsDict["priority"] as? String == "Paid" {
            arrayOfVideoQuestions.insert(questionsDict, at: 0)
        }
        else {
            arrayOfVideoQuestions.append(questionsDict)
        }
       
       // questionsCollectionView.reloadData()
    }
    
    func getSingleUser(userDict:NSDictionary) {
        if notificationFlag {
            let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
            let commentString = uniqueName+" Liked your video"
            if userDict["device"] as! String == "iphone" {
               Common.sendPusNotification(userNumber: uniqueName, title: "", body: commentString, fcmID: userDict["fcm"] as! String)
            }
            else {
                Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "temp", body: commentString, fcmID: userDict["fcm"] as! String)
            }
            notificationFlag = false
            return
        }
        
        if callDelegate {
            arrayOfVideosUsers.insert(User(userdict: userDict), at: 0)
            
            //arrayOfVideosUsers.append(User(userdict: userDict))
            //questionsCollectionView.reloadData()
            tableView.reloadData()
        }
        else {
            UserDefaults.standard.set(userDict, forKey: USER_DICT)
        }
    }
    
    func getUpdatedUser(userDict: NSDictionary) {
        //self.ChangeTabIcons()
        Common.ChangeTabIcons(vc: self)
    }
    
    func isQuestionLiked(liked:Bool) {
        if liked {
            
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    func addTempUser() {
        UserDefaults.standard.set("12345", forKey: USER_ACCOUNT_ID)
        let tempUser = User()
        tempUser.username = "ijaz"
        tempUser.id = "12345"
        tempUser.region = "Canada"
        
        UserDBHandler.Instance.addNewUserToFirebaseDatabase(user: tempUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "sampleVideo", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.view.frame = self.view.bounds
        self.view.addSubview(playerController.view)
        player.play()
    }
    
    
    @IBAction func LikeAction(_ sender: UIButton) {
        var isLiked: Bool = false
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        
        let lVideo = arrayOfVideoQuestions[(indexPath?.row)!]
        let noOfLikes = tableViewCell.viewWithTag(7) as! UILabel
        let userName = tableViewCell.viewWithTag(2) as! UILabel
        let btnImg = tableViewCell.viewWithTag(6) as! UIButton
        
        
        let userId = lVideo["userId"] as! String
        
        if lVideo["isliked"] as! String == "true" {
            isLiked = false
            btnImg.setBackgroundImage(UIImage(named: "dislike_punch.png"), for: UIControlState.normal)
            let activityString = "You dislike "+userName.text!+" Question"
            let otherString = uniqueName+" dislike your Question"
            UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: lVideo["quesId"] as! String, answerId: "", otherString: otherString, userId: userId)
            lVideo["likes"] = String(Int(noOfLikes.text!)! - 1)
            lVideo["isliked"] = "false"
        }
        else {
            lVideo["isliked"] = "true"
            isLiked = true
            btnImg.setBackgroundImage(UIImage(named: "like_punch.png"), for: UIControlState.normal)
            if noOfLikes.text == nil {
                noOfLikes.text = "1"
                lVideo["likes"] = "1"
            }
            else {
                lVideo["likes"] = String(Int(noOfLikes.text!)! + 1)
            }
            
            var activityString: String!
            var otherString: String!
            if lVideo["videoLink"] as! String == "" {
                activityString = "You liked "+userName.text!+" Image"
                otherString = uniqueName+" liked your Image"
            }
            else {
                activityString = "You liked "+userName.text!+" Video"
                otherString = uniqueName+" liked your Video"
            }
            
            UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: lVideo["quesId"] as! String, answerId: "", otherString: otherString, userId: userId)
            
            UserDBHandler.Instance.getSingleUserDelegate = self
            UserDBHandler.Instance.getSingleUser(userId: userId)
            notificationFlag = true
        }
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        QuestionsDBHandler.Instance.setLikeOfVideoQuestion(questionKey: lVideo["quesId"] as! String, isLiked: isLiked)
        UserDBHandler.Instance.setLikeOfVideoQuestionInUserNode(questionKey: lVideo["quesId"] as! String, userId: accountId!, isLiked: isLiked)
        QuestionsDBHandler.Instance.setLikeOfVideoQuestionInQuestionNode(questionKey: lVideo["quesId"] as! String, userId: accountId!, isLiked: isLiked)
        noOfLikes.text = lVideo["likes"] as? String
        tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.none)
        
    }
    
    @IBAction func ReportPostAction(_ sender: UIButton) {
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        let lVideo = arrayOfVideoQuestions[(indexPath?.row)!]
        self.openActionSheet(lVideoQuestion: lVideo, indexPath: indexPath!)
        
    }
    
    func openActionSheet(lVideoQuestion: NSMutableDictionary, indexPath: IndexPath) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Report this Post", message: "Are you sure you want to report this post?", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let reportPost: UIAlertAction = UIAlertAction(title: "Report Post", style: .default) { action -> Void in
           // self.openCamera()
            let ind = self.arrayOfVideoQuestions.index(of: lVideoQuestion)
            self.arrayOfVideoQuestions.remove(at: ind!)
            //self.tableView.reloadData()
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
            UserDBHandler.Instance.reportSelectedPost(quesId: lVideoQuestion["quesId"] as! String)
            self.view.makeToast("Post has been reported", duration: 2.0, position: .top)
            
        }
        actionSheetController.addAction(reportPost)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func goToUserProfile(_ sender: UIButton) {
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        let lQuestion = arrayOfVideoQuestions[(indexPath?.item)!]
        
        let uid = lQuestion["userId"] as! String
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        if uid == accountId {
            self.tabBarController?.selectedIndex = 4
            return
        }
        let sArray = arrayOfVideosUsers.filter() {$0.id.contains((uid))}
        if sArray.count == 0 {
            return
        }
        let lUser = sArray[0]
        selectedUser = lUser
        DBProvider.Instance.userRef.child((selectedUser?.id)!).child("Blocked").observeSingleEvent(of: .value, with: { (snapshot) in
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            if snapshot.hasChild(accountId!) {
                return
            }
            else {
                self.performSegue(withIdentifier: "goToProfile", sender: self)
            }
        })
        
        
        
    }
    
    @IBAction func hideLargeView(_ sender: UIButton) {
        largePictureView.isHidden = true
    }
    
    
    func showHideLoadingAnimation(totalItems: Int) {
        if totalItems > 0 {
            loadingImageView.isHidden = true
            tableView.isHidden = false
        }
        else {
           // loadingImageView.isHidden = false
            tableView.isHidden = true
        }
        
        
    }
    
    @IBAction func CommentAction(_ sender: UIButton) {
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        selectedVideo = arrayOfVideoQuestions[(indexPath?.item)!]
        self.performSegue(withIdentifier: "goToComments", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayVideoController" {
            let nextScene = segue.destination as! VideoViewController
            nextScene.selectedQuestion = selectedVideo as? NSMutableDictionary
        }
        else if segue.identifier == "goToProfile" {
            let nextScene = segue.destination as! UserProfileViewController
            nextScene.selectedUser = selectedUser
            nextScene.viewControllerName = "Home"
        }
        else if segue.identifier == "goToComments" {
            let nextScene = segue.destination as! CommentsViewController
            //nextScene.allComments = arrayOfComments
            nextScene.selectedVideo = selectedVideo
            nextScene.typeOfVideo = "question"
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //collection view delegate methods
    
    /*
     Notes
     first colleciton view which is "top codevisers" has tag 1
     second collection view which is "categories" has tag 2
     third collection view which is "main colleciton view" has tag 3
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return arrayOfUsers.count
        }
        else if collectionView.tag == 2 {
            return categories.count
        }
        else if collectionView.tag == 3 {
            return arrayOfVideoQuestions.count
        }
        else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell
        if collectionView.tag == 1 {
            let lUser = arrayOfUsers[indexPath.item]
            let profileString = lUser.profile
            if (profileString.characters.count) < 2 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noProfilePictureItem", for: indexPath as IndexPath)
            }
            else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePictureItem", for: indexPath as IndexPath)
            }
            
            let profileImgView = cell.viewWithTag(1) as! UIImageView
            let userNmae = cell.viewWithTag(2) as! UILabel
            if (profileString.characters.count) < 2 {
                print("no image")
            }
            else {
                let profileUrl = URL(string: profileString)
                profileImgView.kf.setImage(with: profileUrl)
                profileImgView.layer.borderWidth = 1.0
                profileImgView.layer.borderColor = UIColor.init(red: 206/255.0, green: 156.0/255.0, blue: 150/255.0, alpha: 1.0).cgColor
            }
            
            userNmae.text = lUser.username
            
            profileImgView.roundImageView()
            
        }
        
        else if collectionView.tag == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath)
            let categoryImage = cell.viewWithTag(1) as! UIImageView
            let categoryName = cell.viewWithTag(2) as! UILabel
            var imgName: String
            
            if selectedItem == indexPath.item {
                imgName = "clicked"+String(indexPath.item)+".png"
            }
            else {
                imgName = "unClicked"+String(indexPath.item)+".png"
            }
            categoryImage.image = UIImage(named: imgName)
            categoryName.text = categories[indexPath.item]
        }
        else {
            let lQuestion = arrayOfVideoQuestions[indexPath.item]
            let questionString = lQuestion["videoThumbLink"] as? String
            let questionType = lQuestion["priority"] as? String
            let serverDate = lQuestion["date"] as? NSNumber
            let imgUrl = URL(string: questionString!)
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoItem", for: indexPath as IndexPath)
            let questionImgView = cell.viewWithTag(1) as! UIImageView
            let priorityImgView = cell.viewWithTag(2) as! UIImageView
            questionImgView.kf.setImage(with: imgUrl)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let date = dateFormatter.date(from: String(describing: serverDate))
            
            let localDate = Date(timeIntervalSince1970: (TimeInterval((serverDate?.intValue)! / 1000)))
            print(localDate)
            
            if questionType == "Free" {
                priorityImgView.isHidden = true
            }
            else {
                priorityImgView.isHidden = false
            }
            
            
        }
        
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView.tag == 3 {
                let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
                let screenWidth: CGFloat = UIScreen.main.bounds.size.width-4
                
                let cellWidth = screenWidth/numberOfCell
                return CGSize(width: cellWidth, height: cellWidth)

            }
            else if collectionView.tag == 1 {
               return CGSize(width: 80, height: 95)
            }
            else {
                return CGSize(width: 80, height: 70)
            }
        }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView.tag == 1 {
            selectedUser = arrayOfUsers[indexPath.item]            
            DBProvider.Instance.userRef.child((selectedUser?.id)!).child("Blocked").observeSingleEvent(of: .value, with: { (snapshot) in
                let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
                if snapshot.hasChild(accountId!) {
                    return
                }
                else {
                    self.performSegue(withIdentifier: "goToProfile", sender: self)
                }
            })
            
        }
        if collectionView.tag == 2 {
            selectedItem = indexPath.item
            arrayOfVideoQuestions.removeAll()
            questionsCollectionView.reloadData()
            if indexPath.item == 0 {
                QuestionsDBHandler.Instance.getVideoQuestions()
            }
            else {
                QuestionsDBHandler.Instance.getFilteredQuestionsWithCategory(category: categories[indexPath.item])
            }
            
        }
        if collectionView.tag == 3 {
            selectedVideo = arrayOfVideoQuestions[indexPath.row]
             if (selectedVideo!["videoLink"] as! String) == "" {
                largePictureView.isHidden = false
                let urlString = selectedVideo!["videoThumbLink"] as! String
                let imgUrl = URL(string: urlString)
                largeImageView.kf.setImage(with: imgUrl)
                return
            }
            performSegue(withIdentifier: "goToPlayVideoController", sender: nil)
        }
        collectionView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       //  UserDefaults.standard.set(arrayOfVideoQuestions, forKey: "videoArray")
        self.showHideLoadingAnimation(totalItems: arrayOfVideoQuestions.count)
//        if arrayOfVideoQuestions.count > 0 {
//            return arrayOfVideoQuestions.count
//        }
//        else {
//            return arrayOfStaticVideoQuestions.count
//        }

        return arrayOfVideoQuestions.count
        
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 667
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        return topView
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell")!
        
        let lQuestion = arrayOfVideoQuestions[indexPath.item]
        QuestionsDBHandler.Instance.countQuestionComments(questionId: lQuestion["quesId"] as! String)
        let uid = lQuestion["userId"] as! String
        let questionString = lQuestion["videoThumbLink"] as? String
        let imgUrl = URL(string: questionString!)
        
        
        let sArray = arrayOfVideosUsers.filter() {$0.id.contains((uid))}
        if sArray.count == 0 {
            return cell
        }
        let lUser = sArray[0]
        
        
        //let lUser = arrayOfVideosUsers[indexPath.row]
        let userImageUrl = URL(string: lUser.profile)
        
        print(lUser.id)
        
        let userImageView = cell.viewWithTag(1) as! UIImageView
        let userName = cell.viewWithTag(2) as! UILabel
        let videoDate = cell.viewWithTag(3) as! UILabel
        let questionImgView = cell.viewWithTag(4) as! UIImageView
        let qTitle = cell.viewWithTag(5) as! UILabel
        let likeBtn = cell.viewWithTag(6) as! UIButton
        let commentBtn = cell.viewWithTag(8) as! UIButton
        let likeLabel = cell.viewWithTag(7) as! UILabel
        let commentLabel = cell.viewWithTag(9) as! UILabel
        let tagLabel = cell.viewWithTag(10) as! UILabel
        let loadingImageView = cell.viewWithTag(20) as! UIImageView
       // loadingImageView.image = UIImage.gif(name: "loadinganimation")
        
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.borderColor = UIColor.init(red: 206/255.0, green: 156.0/255.0, blue: 150/255.0, alpha: 1.0).cgColor
        
        let tagString = lQuestion["tags"] as? String
        var completeTag : String = ""
        let tagArray = tagString?.split(separator: " ")
        
        for item in tagArray! {
            completeTag = completeTag+"#"+item+" "
        }
        
        //tagLabel.text = lVideo["tags"] as? String
        tagLabel.text = completeTag
        
        let playImageView = cell.viewWithTag(11) as! UIImageView
        if (lQuestion["videoLink"] as! String) == "" {
           // playImageView.isHidden = true
            playImageView.image = UIImage(named: "pictureDefault.png")
        }
        else if (lQuestion["videoThumbLink"] as! String) == "" {
            // playImageView.isHidden = true
            playImageView.image = UIImage.gif(name: "loadinganimation")
        }
        else {
            
            playImageView.image = UIImage(named: "round_video_play_button.png")
          //  playImageView.isHidden = false
        }
        
        if lQuestion["isliked"] as! String == "true"{
            likeBtn.setBackgroundImage(UIImage(named: "like_punch.png"), for: UIControlState.normal)
        }
        else {
            likeBtn.setBackgroundImage(UIImage(named: "dislike_punch.png"), for: UIControlState.normal)
        }

        
        DBProvider.Instance.questionsRef.child(lQuestion["quesId"] as! String).child(QUESTION_COMMENTS_NODE).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.childrenCount)
            commentLabel.text = String(snapshot.childrenCount)
        })
        
        userImageView.kf.setImage(with: userImageUrl)
        questionImgView.kf.setImage(with: imgUrl)
        userName.text = lUser.username
        videoDate.text = Common.convertDate(dateInteger: lQuestion["date"] as! NSNumber)
        qTitle.text = lQuestion["title"] as? String
        likeLabel.text = lQuestion["likes"] as? String
        userImageView.roundImageView()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVideo = arrayOfVideoQuestions[indexPath.row]
//        if (selectedVideo!["videoLink"] as! String) == "" {
//            largePictureView.isHidden = false
//            let urlString = selectedVideo!["videoThumbLink"] as! String
//            let imgUrl = URL(string: urlString)
//            largeImageView.kf.setImage(with: imgUrl)
//            return
//        }

        performSegue(withIdentifier: "goToPlayVideoController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
}

extension UIImageView {
    public func roundImageView() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        
    }
}

