//
//  ReplyVideoViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/6/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit
import VGPlayer
import SnapKit

class ReplyVideoViewController: UIViewController, GetAnswerCommentsDelegate, IsAnswerLikedDelegate, GetSingleQuestionDelegate, UIGestureRecognizerDelegate {

    var player : VGPlayer = {
        let playeView = VGPlayerView()
        let playe = VGPlayer(playerView: playeView)
        return playe
    }()
    
    var selectedUser: NSDictionary?
    var selectedAnswer: NSMutableDictionary?
    var questionKey: String?
    var answerComments = [Comments]()
    var sQuestion: NSMutableDictionary?
    var vc: String?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfileImageview: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var noOfLikes: UILabel!
    @IBOutlet weak var noOfComments: UILabel!
    @IBOutlet weak var dateOfAnswer: UILabel!
    var isLiked: Bool = false
    let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDBHandler.Instance.isAnswerLikedDelegate = self
        QuestionsDBHandler.Instance.getSingleQuestionDelegate = self
        UserDBHandler.Instance.isAnswerLiked(answerKey: selectedAnswer?["key"] as! String, userId: accountId!)
        
        QuestionsDBHandler.Instance.getAnswerCommentsDelegate = self
        QuestionsDBHandler.Instance.getAnswerComments(answerKey: selectedAnswer?["key"] as! String, questionKey: questionKey!)
        // Do any additional setup after loading the view.
        let vidUrlString = selectedAnswer?["videoLink"] as? String
        let vidUrl = URL(string: vidUrlString!)
        playVideoWithUrl(videoUrl: vidUrl!)
        userProfileImageview.roundImageView()
        userName.text = selectedUser?["name"] as? String
        let profileString = selectedUser?["profile"] as? String
        let profileUrl = URL(string: profileString!)
        userProfileImageview.kf.setImage(with: profileUrl)
        noOfLikes.text = selectedAnswer?["likes"] as? String
        noOfComments.text = selectedAnswer?["comments"] as? String
        dateOfAnswer.text = Common.convertDate(dateInteger: (selectedAnswer?["date"] as? NSNumber)! )
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        player.pause()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func isAnswerLiked(liked:Bool) {
        if liked {
            likeBtn.setBackgroundImage(UIImage(named: "like_punch.png"), for: UIControlState.normal)
        }
        else {
            likeBtn.setBackgroundImage(UIImage(named: "dislike_punch.png"), for: UIControlState.normal)
        }
        isLiked = liked
    }
    
    func getAnswerComments(commentsDict: NSDictionary) {
        
        let pComment = Comments()
        pComment.commentId = commentsDict["commentId"] as! String
        pComment.commentContent = commentsDict["comment"] as! String
        pComment.commentTime = commentsDict["comentTime"] as! String
        pComment.name = commentsDict["name"] as! String
        pComment.number = commentsDict["number"] as! String

        
        answerComments.append(pComment)
        noOfComments.text = String(answerComments.count)
    }
    
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
    }
    
    @IBAction func GoBackToQuestion(_ sender: UIButton) {
        if vc == "myVideos" {
            QuestionsDBHandler.Instance.getQuestionByQuesId(questionId: questionKey!)

        }
        else {
            DispatchQueue.main.async {
                self.player.pause()
            }
            
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
        
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.player.pause()
        }
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
    
    
    func getSingleQuestion(qDict: NSDictionary) {
        sQuestion = qDict as? NSMutableDictionary
        sQuestion?["key"] = qDict["quesId"]
        self.performSegue(withIdentifier: "goToQuestion", sender: self)
    }
    
    func getUpdatedUser(userDict: NSDictionary) {
        //self.ChangeTabIcons()
        Common.ChangeTabIcons(vc: self)
    }
    
    @IBAction func ShowComments(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToComments", sender: self)
    }
    
    @IBAction func LikeVideo(_ sender: UIButton) {
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let userId = selectedAnswer?["userId"] as! String
        if isLiked {
            likeBtn.setBackgroundImage(UIImage(named: "dislike_punch.png"), for: UIControlState.normal)
            selectedAnswer?["likes"] = String(Int(noOfLikes.text!)! - 1)
            isLiked = false
            let activityString = "You dislike "+userName.text!+" Answer"
             let otherString = uniqueName+" dislike your Answer"
        
             UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: questionKey!, answerId: selectedAnswer?["key"] as! String, otherString: otherString, userId: userId)
        }
        else {
            likeBtn.setBackgroundImage(UIImage(named: "like_punch.png"), for: UIControlState.normal)
            if noOfLikes.text == nil {
                selectedAnswer?["likes"] = String(1)
            }
            else {
                selectedAnswer?["likes"] = String(Int(noOfLikes.text!)! + 1)
            }

            isLiked = true
            let activityString = "You like "+userName.text!+" Answer"
            let otherString = uniqueName+" liked your Answer"
             UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: questionKey!, answerId: selectedAnswer?["key"] as! String, otherString: otherString, userId: userId)
            
            let commentString = uniqueName+" Liked your response"
            if selectedUser!["device"] as! String == "iphone" {
               Common.sendPusNotification(userNumber: uniqueName, title: "", body: commentString, fcmID: selectedUser!["fcm"] as! String)
            }
            else {
                Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "temp", body: commentString, fcmID: selectedUser!["fcm"] as! String)
            }
            
        }
        
        UserDBHandler.Instance.setLikeOfVideoAnswerInUserNode(answerKey: selectedAnswer?["key"] as! String, userId: accountId!, isLiked: isLiked)
        QuestionsDBHandler.Instance.setLikeOfVideoAnswer(questionKey: questionKey!, answerKey: selectedAnswer?["key"] as! String, isLiked: isLiked)
        QuestionsDBHandler.Instance.setLikeOfVideoAnswerInAnswerNode(questionKey: questionKey!, answerKey:selectedAnswer?["key"] as! String , userId: accountId!, isLiked: isLiked)
        noOfLikes.text = selectedAnswer?["likes"] as? String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToComments" {
            
            let nextScene = segue.destination as! CommentsViewController
           // nextScene.allComments = answerComments
            nextScene.selectedVideo = selectedAnswer
            nextScene.typeOfVideo = "answer"
            nextScene.questionKey = questionKey
        }
        else if segue.identifier == "goToQuestion" {//goToFollowings
            let nextScene = segue.destination as! VideoViewController
            nextScene.selectedQuestion = sQuestion
        }
    }
    

}

extension ReplyVideoViewController: VGPlayerDelegate {
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

extension ReplyVideoViewController: VGPlayerViewDelegate {
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

extension ReplyVideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }
    
}
