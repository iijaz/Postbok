//
//  FollowingsViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/9/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit

class FollowingsViewController: UIViewController, GetUserFollowingDelegate, GetSingleUserDelegate, CheckUserFollowingDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customHeaderView: UIView!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    var selectedUser: User?
    var arrayOfUsers = [User]()
    var arrayOfPendingUsers = [User]()
    var isFollowedArray = [Bool]()
    var isPendingArray = [Bool]()
    
    var sUser: User?
    var type: String?
    var quesId: String?
    var followingCall: Bool?
    var pendingCall: Bool?
    var countSingleUserDelgateCall = 0
    let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.init()
        tableView.tableHeaderView = UIView.init()
        UserDBHandler.Instance.getUserFollowingDelegate = self
        UserDBHandler.Instance.getSingleUserDelegate = self
        UserDBHandler.Instance.checkUserFollowingDelegate = self
        if type == USER_FOLLOWING {
            UserDBHandler.Instance.getUserFollowings(userId: (selectedUser?.id)!)
            followingLabel.text = "Following"
            tableView.tableHeaderView = UIView.init()
        }
        else if type == USER_FOLLOWERS {
            UserDBHandler.Instance.getUserFollowers(userId: (selectedUser?.id)!)
            followingLabel.text = "Followers"
        }
        
        else if type == "question" {
            UserDBHandler.Instance.getQuestionLikeUsers(questionId: quesId!)
            tableView.tableHeaderView = UIView.init()
        }
        
        if selectedUser?.id != accountId {
            tableView.tableHeaderView = UIView.init()
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        

        // Do any additional setup after loading the view.
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
    
    func getUserFollowing(userFollowingId:String) {
        if countSingleUserDelgateCall == 0 {
            UserDBHandler.Instance.getSingleUser(userId: userFollowingId)
        }
        
    }
    
    func getUserPendingRequests(userPendingId: String) {


    }
    
    func getSingleUser(userDict:NSDictionary) {
        let lUser = User(userdict: userDict)
        arrayOfUsers.append(lUser)
        UserDBHandler.Instance.checkUserFollowing(userId: lUser.id, accountId: accountId!)
    }
    
    func checkIsUserFollowing(followed:Bool) {
        
        isFollowedArray.append(followed)
        //tableView.reloadData()
    }
    
    func isRequested(request: Bool) {
        isPendingArray.append(request)
        tableView.reloadData()
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
      //  dismiss(animated: true, completion: nil)
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
    
    
    
    @IBAction func FollowButtonAction(_ sender: UIButton) {
        
        countSingleUserDelgateCall = 1
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        let lUser = arrayOfUsers[(indexPath?.row)!]
        let isFollowed = isFollowedArray[(indexPath?.row)!]
        if sender.titleLabel?.text?.lowercased() == "pending" {
            UserDBHandler.Instance.deleteFollowRequest(userId: accountId!, accountId: lUser.id)
            isPendingArray[(indexPath?.row)!] = false
            tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.none)
            return
        }
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let activityString: String?
        let otherString: String?
        let otherFollowString: String?
        var commentString: String?
        if isFollowed {
            activityString = "You just unfollowed "+lUser.username
            otherString = uniqueName+" just unfollowed "+lUser.username
            otherFollowString = uniqueName+" just unfollowed "+lUser.username
            commentString = uniqueName+" just unfollowed you"
            //isFollowedArray[(indexPath?.row)!] = "Follow"
            
        }
        else {
            if lUser.accountType.lowercased() == "private" {
                commentString = "exit"
                isPendingArray[(indexPath?.row)!] = true
                
            }
            else {
                 //isFollowedArray[(indexPath?.row)!] = "Following"
                activityString = "You started following "+lUser.username
                otherString = uniqueName+" started following "+lUser.username
                otherFollowString = uniqueName+" started following "+lUser.username
                
                commentString = uniqueName+" started following you"
                if lUser.device == "iphone" {
                    Common.sendPusNotification(userNumber: "", title: "", body: commentString!, fcmID: lUser.mFcmId)
                }
                else {
                    Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "temp", body: commentString!, fcmID: lUser.mFcmId)
                }

            }
            
            
        }
        if commentString != "exit" {
            UserDBHandler.Instance.setOtherUserFollowingActivities(activityString: commentString!, userId: lUser.id, accountId: accountId!)
            // UserDBHandler.Instance.setUserFollowingActivities(activityString: activityString!, questionId: "", answerId: "", otherString: otherString!, userId: lUser.id)
            
            UserDBHandler.Instance.setNoOfUserFollowing(userId: lUser.id, isFollowed: !isFollowed, accountId: accountId!)
        }

        UserDBHandler.Instance.setUserFollowing(userId: lUser.id, isFollowed: !isFollowed, accountId: accountId!, accountType: lUser.accountType)
        if lUser.accountType.lowercased() == "private" && !isFollowed {
            isFollowedArray[(indexPath?.row)!] = isFollowed
        }
        else {
           isFollowedArray[(indexPath?.row)!] = !isFollowed
        }
        
        tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.none)
    }
    
    @IBAction func DeleteRequestAction(_ sender: UIButton) {
    }
    
    
    @IBAction func ConfirmAction(_ sender: UIButton) {
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfile" {
            let nextScene = segue.destination as! UserProfileViewController
            nextScene.selectedUser = sUser
        }
    }
    

}

extension FollowingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFollowedArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        let lUser = arrayOfUsers[indexPath.row]
        let isFollowed = isFollowedArray[indexPath.row]
        let isPending = isPendingArray[indexPath.row]
        let profileString = lUser.profile
        if (profileString.characters.count) < 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "noProfileCell", for: indexPath as IndexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath as IndexPath)
        }
        
        let profileImgView = cell.viewWithTag(1) as! UIImageView
        let userNmae = cell.viewWithTag(2) as! UILabel
        let followBtn = cell.viewWithTag(3) as! UIButton
        followBtn.layer.cornerRadius = 5.0
        
        if isFollowed {
            //followBtn.backgroundColor = UIColor.white
            followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            followBtn.setTitle("Following", for: UIControlState.normal)
           // followBtn.layer.borderWidth = 1.0
        }
        
        else {
            if isPending {
                followBtn.setTitle("Pending", for: UIControlState.normal)
                followBtn.layer.borderWidth = 0.0
            }
            else {
                followBtn.setTitle("Follow", for: UIControlState.normal)
                followBtn.layer.borderWidth = 0.0
            }
            
        }
        
        if (profileString.characters.count) < 2 {
            print("no image")
        }
        else {
            let profileUrl = URL(string: profileString)
            profileImgView.kf.setImage(with: profileUrl)
        }
        
        if accountId! == lUser.id {
            followBtn.isHidden = true
        }
        else {
            followBtn.isHidden = false
        }
        
        userNmae.text = lUser.username
        profileImgView.roundImageView()
        profileImgView.layer.borderWidth = 1.0

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sUser = arrayOfUsers[indexPath.row]        
        DBProvider.Instance.userRef.child((sUser?.id)!).child("Blocked").observeSingleEvent(of: .value, with: { (snapshot) in
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            if snapshot.hasChild(accountId!) {
                return
            }
            else {
                self.performSegue(withIdentifier: "goToProfile", sender: self)
            }
            
        })
        
    }
}
