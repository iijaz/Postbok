//
//  VideoViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/3/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import BMPlayer
import VGPlayer
import SnapKit

class VideoViewController: UIViewController, GetSingleUserDelegate, GetCommentsDelegate, GetAnswersDelegate, IsQuestionLikedDelegate, IsAnswerLikedDelegate, UIGestureRecognizerDelegate {
    
    var player : VGPlayer = {
        let playeView = VGPlayerView()
        let playe = VGPlayer(playerView: playeView)
        return playe
    }()
    var selectedQuestion: NSMutableDictionary?
    var arrayOfComments = [Comments]()
    var answersOfComments = [NSDictionary]()
    var answersLikes = [Bool]()
    var arrayOfAnsUsers = [NSDictionary]()
    var isAnsUser: Bool = false
    var selectedAnswer: NSDictionary?
    var selectedUser: NSDictionary?
    
    var capturedImage: UIImage?
    var isLiked: Bool = false
    var showAllComments: Bool = false
    var sUser: NSDictionary?
    let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var noOfLikes: UILabel!
    @IBOutlet weak var noOfComments: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var dateOfQuestion: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playerBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDBHandler.Instance.getSingleUserDelegate = self
        QuestionsDBHandler.Instance.getCommentsDelegate = self
        QuestionsDBHandler.Instance.getAnswersDelegate = self
        UserDBHandler.Instance.getSingleUser(userId: selectedQuestion?["userId"] as! String)
        QuestionsDBHandler.Instance.getQuestionComments(questionKey: selectedQuestion?["key"] as! String)
        QuestionsDBHandler.Instance.getQuestionAnswers(questionKey: selectedQuestion?["key"] as! String)
        UserDBHandler.Instance.isQuestionLikedDelegate = self
        UserDBHandler.Instance.isQuestionLiked(questionKey: selectedQuestion?["key"] as! String, userId: accountId!)
        profileImgView.roundImageView()
        
        if (selectedQuestion!["videoLink"] as! String) == "" {
            let urlString = selectedQuestion!["videoThumbLink"] as! String
            let imgUrl = URL(string: urlString)
            imgView.kf.setImage(with: imgUrl)
            collectionView.isHidden = true
            playerBottomConstraint.constant = 15
            return
        }
        commentsTableView.isHidden = true
        collectionView.isHidden = false
        playerBottomConstraint.constant = 40
        
        let vidUrlString = selectedQuestion?["videoLink"] as? String
        let vidUrl = URL(string: vidUrlString!)
        playVideoWithUrl(videoUrl: vidUrl!)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player.pause()
        QuestionsDBHandler.Instance.removeAnswerObserver(questionKey: selectedQuestion?["key"] as! String)
        QuestionsDBHandler.Instance.removeCommentsObserver(questionKey: selectedQuestion?["key"] as! String)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        QuestionsDBHandler.Instance.removeCommentsObserver(questionKey: selectedQuestion?["key"] as! String)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////////////////////////////////////////////////delegates//////////////////////////////////////////////////////////////////////////////
    
    func getSingleUser(userDict:NSDictionary) {
//        if isAnsUser {
//            arrayOfAnsUsers.append(userDict)
//            collectionView.reloadData()
//            //isAnsUser = false
//            return
//        }
        sUser = userDict
        let profileString = userDict["profile"] as? String
        let profileUrl = URL(string: profileString!)
        profileImgView.kf.setImage(with: profileUrl)
        userName.text = userDict["name"] as? String
        category.text = selectedQuestion?["categroy"] as? String
        videoTitle.text = selectedQuestion?["title"] as? String
        noOfLikes.text = selectedQuestion?["likes"] as? String
        dateOfQuestion.text = Common.convertDate(dateInteger: selectedQuestion?["date"] as! NSNumber)
        
        let tagString = selectedQuestion?["tags"] as? String
        var completeTag : String = ""
        let tagArray = tagString?.split(separator: " ")
        
        for item in tagArray! {
            completeTag = completeTag+"#"+item+" "
        }
        tagsLabel.text = completeTag
    }
    
    func getSpecificSingleUser(userDict:NSDictionary) {
        arrayOfAnsUsers.append(userDict)
        collectionView.reloadData()
    }
    
    func getUpdatedUser(userDict: NSDictionary) {
        //self.ChangeTabIcons()
        Common.ChangeTabIcons(vc: self)
    }
    
    func getAllComments(commentsDict: NSDictionary) {
        let pComment = Comments()
        pComment.commentId = commentsDict["commentId"] as! String
        pComment.commentContent = commentsDict["comment"] as! String
        pComment.commentTime = commentsDict["comentTime"] as! String
        pComment.name = commentsDict["name"] as! String
        pComment.number = commentsDict["number"] as! String
        arrayOfComments.append(pComment)
        noOfComments.text = String(arrayOfComments.count)
        commentsTableView.reloadData()
    }
    
    func getAllAnswers(answersDict: NSMutableDictionary, key: String) {
        answersDict["key"] = key
        answersOfComments.append(answersDict)
        isAnsUser = true
       // UserDBHandler.Instance.getSingleUser(userId: answersDict["userId"] as! String)
        UserDBHandler.Instance.getSpecificSingleUser(userId: answersDict["userId"] as! String)
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        UserDBHandler.Instance.isAnswerLikedDelegate = self
        UserDBHandler.Instance.isAnswerLiked(answerKey: key, userId: accountId!)
        
    }
    
    func isAnswerLiked(liked:Bool) {
        answersLikes.append(liked)
        collectionView.reloadData()
    }
    
    func isQuestionLiked(liked:Bool) {
        if liked {
            likeButton.setBackgroundImage(UIImage(named: "like_punch.png"), for: UIControlState.normal)
        }
        else {
            likeButton.setBackgroundImage(UIImage(named: "dislike_punch.png"), for: UIControlState.normal)
        }
        isLiked = liked
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func playVideoWithUrl(videoUrl: URL) {
        self.player.replaceVideo(videoUrl)
        player.displayView.closeButton.isHidden = true
        self.topView.addSubview(self.player.displayView)
        self.player.play()
        self.player.backgroundMode = .suspend
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(60)
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(1) // you can 9.0/16.0
        }
        //player.pause()
    }
    
    //All button actions here
    
    @IBAction func BackAction(_ sender: UIButton) {
        //QuestionsDBHandler.Instance.removeCommentsObserver(questionKey: selectedQuestion?["key"] as! String)
        //self.dismiss(animated: true, completion: nil)
        
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
        
        player.pause()
        
    }
    
    @IBAction func LikeTapped(_ sender: UIButton) {
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let userId = selectedQuestion?["userId"] as! String
        if isLiked {
            likeButton.setBackgroundImage(UIImage(named: "dislike_punch.png"), for: UIControlState.normal)
            selectedQuestion?["likes"] = String(Int(noOfLikes.text!)! - 1)
            selectedQuestion?["isliked"] = "false"
            isLiked = false
            let activityString = "You dislike "+userName.text!+" Video"
            let otherString = uniqueName+" dislike your Video"
            
            UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: selectedQuestion?["key"] as! String, answerId: "", otherString: otherString, userId: userId)
        }
        else {
            likeButton.setBackgroundImage(UIImage(named: "like_punch.png"), for: UIControlState.normal)
            selectedQuestion?["isliked"] = "true"
            
            if noOfLikes.text == nil {
                selectedQuestion?["likes"] = String(1)
            }
            else {
                selectedQuestion?["likes"] = String(Int(noOfLikes.text!)! + 1)
            }
            isLiked = true
            
            var activityString: String!
            var otherString: String!
            let commentString: String!
            if selectedQuestion?["videoLink"] as! String == "" {
                activityString = "You liked "+userName.text!+" Image"
                otherString = uniqueName+" liked your Image"
                commentString = uniqueName+" Liked your Image"
            }
            else {
                activityString = "You liked "+userName.text!+" Video"
                otherString = uniqueName+" liked your Video"
                commentString = uniqueName+" Liked your video"
            }
            
            
            UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: selectedQuestion?["key"] as! String, answerId: "", otherString: otherString, userId: userId)
            if sUser!["device"] as! String == "iphone" {
                Common.sendPusNotification(userNumber: uniqueName, title: "", body: commentString, fcmID: sUser!["fcm"] as! String)
            }
            else {
                Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "temp", body: commentString, fcmID: sUser!["fcm"] as! String)
            }
            
        }
        
        QuestionsDBHandler.Instance.setLikeOfVideoQuestion(questionKey: selectedQuestion?["key"] as! String, isLiked: isLiked)
        UserDBHandler.Instance.setLikeOfVideoQuestionInUserNode(questionKey: selectedQuestion?["key"] as! String, userId: accountId!, isLiked: isLiked)
        QuestionsDBHandler.Instance.setLikeOfVideoQuestionInQuestionNode(questionKey: selectedQuestion?["key"] as! String, userId: accountId!, isLiked: isLiked)
        noOfLikes.text = selectedQuestion?["likes"] as? String
        
        
    }
    
    @IBAction func LikeLongPress(_ sender: UIButton) {
        print("this is long press")
        self.performSegue(withIdentifier: "goToFollowings", sender: self)
    }
    
    
    @IBAction func GoToUserProfile(_ sender: UIButton) {
        DBProvider.Instance.userRef.child((sUser!["id"])! as! String).child("Blocked").observeSingleEvent(of: .value, with: { (snapshot) in
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            if snapshot.hasChild(accountId!) {
                return
            }
            else {
                self.performSegue(withIdentifier: "goToProfile", sender: self)
            }
            
        })
        
    }
    
    @IBAction func OpenLikers(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .ended {
            self.performSegue(withIdentifier: "goToFollowings", sender: self)
        }
    }
    
    @IBAction func CommentTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToComments", sender: self)
    }
    
    
    @IBAction func ViewAllComments(_ sender: UIButton) {
        showAllComments = true
        commentsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        QuestionsDBHandler.Instance.removeCommentsObserver(questionKey: selectedQuestion?["key"] as! String)
        if segue.identifier == "goToComments" {
            let nextScene = segue.destination as! CommentsViewController
            //nextScene.allComments = arrayOfComments
            nextScene.selectedVideo = selectedQuestion
            nextScene.typeOfVideo = "question"
        }
        else if segue.identifier == "goToAnswer" {
            let nextScene = segue.destination as! ReplyVideoViewController
            nextScene.selectedUser = selectedUser
            nextScene.selectedAnswer = selectedAnswer as? NSMutableDictionary
            nextScene.questionKey = selectedQuestion?["key"] as? String
        }
        else if segue.identifier == "recordAnswer" {
           let nextScene = segue.destination as! CameraViewController
            nextScene.calledfrom = "question"
            nextScene.questionId = selectedQuestion?["quesId"] as? String
            nextScene.selectedUser = sUser
        }
        else if segue.identifier == "goToFollowings" {
            let nextScene = segue.destination as! FollowingsViewController
            nextScene.type = "question"
            nextScene.quesId = selectedQuestion?["quesId"] as? String
        }
        else if segue.identifier == "goToProfile" {
            let nextScene = segue.destination as! UserProfileViewController
            let lUser = User(userdict: sUser!)
            nextScene.selectedUser = lUser
           // nextScene.viewControllerName = "Home"
        }
    }
    

}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2 {
            if showAllComments {
                return arrayOfComments.count+1
            }
            else {
                if arrayOfComments.count < 5 {
                    return arrayOfComments.count
                }
                else {
                    return 5
                }
            }
            
        }
        return 1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 667
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return topView
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if tableView.tag == 2 {
            var lComment: Comments!
            if arrayOfComments.count > 4 {
                if indexPath.row == 0 {
                    let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell0")!
                    return cell1
                }
                lComment = arrayOfComments[indexPath.item-1]
            }
            else {
                lComment = arrayOfComments[indexPath.item]
            }
            
            
            //let lComment = arrayOfComments[indexPath.item-1]
            
            let userNmae = cell.viewWithTag(2) as! UILabel
            let commentText = cell.viewWithTag(3) as! UILabel
            
            userNmae.text = lComment.name
            userName.sizeToFit()
            commentText.text = lComment.commentContent
            
        }

        return cell
    }

}

extension VideoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAnsUsers.count+1
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath as IndexPath)
            return cell
        }
        
        let lUser = arrayOfAnsUsers[indexPath.item-1]
        
        let profileString = lUser["profile"] as? String
        if (profileString?.characters.count)! < 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noProfilePictureItem", for: indexPath as IndexPath)
        }
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePictureItem", for: indexPath as IndexPath)
        }

        let profileImgView = cell.viewWithTag(1) as! UIImageView
        let userNmae = cell.viewWithTag(2) as! UILabel
        let likeImageView = cell.viewWithTag(4) as! UIImageView
        let noOfAnsLikes = cell.viewWithTag(3) as! UILabel
        let blackLayer = cell.viewWithTag(10) as! UIImageView
        
        if (profileString?.characters.count)! < 2 {
            print("no image")
        }
        else {
            let profileUrl = URL(string: profileString!)
            profileImgView.kf.setImage(with: profileUrl)
        }
        
        userNmae.text = lUser["name"] as? String
        
        profileImgView.roundImageView()
        blackLayer.roundImageView()
        profileImgView.layer.borderWidth = 1.0
        
        let lAnswer = answersOfComments[indexPath.item-1]
        if answersLikes.count >= indexPath.item-1 {
            
            let isLAnswerLiked = answersLikes[indexPath.item-1]
            
            noOfAnsLikes.text = lAnswer["likes"] as? String
            
            if isLAnswerLiked {
                likeImageView.image = UIImage(named: "like_punch.png")
            }
            else {
                likeImageView.image = UIImage(named: "dislike_punch.png")
            }
        }
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            self.performSegue(withIdentifier: "recordAnswer", sender: self)
            return
        }
        selectedAnswer = answersOfComments[indexPath.row-1]
        selectedUser = arrayOfAnsUsers[indexPath.row-1]
        self.performSegue(withIdentifier: "goToAnswer", sender: self)
    }

}

extension VideoViewController: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}

extension VideoViewController: VGPlayerViewDelegate {
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
    }
}
