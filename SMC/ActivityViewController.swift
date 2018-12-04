//
//  ActivityViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/18/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, GetUserActivitiesDelegate, GetAnswersDelegate, GetSingleUserDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var loadingAnimationView: UIImageView!
    
    
    var selectedVideo: NSDictionary?
    var userAllActivites = [UserActivities]()
    var questionKey: String?
    var selectedUser: NSDictionary?
    var selectedActivity: UserActivities?
    var activityUsersArray = [User]()
    var callDelegate: Bool = false
    var fromActivity: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAnimationView.image = UIImage.gif(name: "loadinganimation")
        
        UserDBHandler.Instance.getUserActivitiesDelegate = self
        UserDBHandler.Instance.getUserActivities()
        
        tableView.tableFooterView = UIView.init()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(true)
        UserDefaults.standard.setValue("1", forKey: "constraintValue")
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        if let str = UserDefaults.standard.value(forKey: "ActivityImageTapped") as? String {
            if str == "YES" {
                DBProvider.Instance.userRef.child(accountId!).child("activities").setValue("0")
            }
            self.ChangeTabIcons()
            
        }
       // DBProvider.Instance.userRef.child(accountId!).child("activities").setValue("0")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            if self.userAllActivites.count > 0 {
                self.loadingAnimationView.isHidden = true
                self.noDataLabel.isHidden = true
            }
            else {
                self.loadingAnimationView.isHidden = true
                self.noDataLabel.isHidden = false
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ChangeTabIcons() {
        
        let userdict = UserDefaults.standard.value(forKey: USER_DICT)
        let lUser = User(userdict: userdict as! NSDictionary)
        
        if lUser.activities == "1" || lUser.replies == "1" {
            self.tabBarController?.tabBar.items![4].image = UIImage(named: "home_with_notification.png")
            self.tabBarController?.tabBar.items?[4].image = self.tabBarController?.tabBar.items?[4].image?.withRenderingMode(.alwaysOriginal)
            
            self.tabBarController?.tabBar.items![4].selectedImage = UIImage(named: "coloured_home_with_notification.png")
            self.tabBarController?.tabBar.items?[4].selectedImage = self.tabBarController?.tabBar.items?[4].selectedImage?.withRenderingMode(.alwaysOriginal)
        }
            
        else {
            
            self.tabBarController?.tabBar.items![4].image = UIImage(named: "profile_icon__gr.png")
            self.tabBarController?.tabBar.items?[4].image = self.tabBarController?.tabBar.items?[4].image?.withRenderingMode(.alwaysOriginal)
            
            self.tabBarController?.tabBar.items![4].selectedImage = UIImage(named: "selected4.png")
            self.tabBarController?.tabBar.items?[4].selectedImage = self.tabBarController?.tabBar.items?[4].selectedImage?.withRenderingMode(.alwaysOriginal)
            
        }
    }
    
    func getAllAnswers(answersDict: NSMutableDictionary, key: String) {
        if key == "Question" {
            answersDict["key"] = answersDict["quesId"]
            selectedVideo = answersDict
            
            self.performSegue(withIdentifier: "goToPlayVideoController", sender: self)
        }
        else if key == "Answer" {
            answersDict["key"] = answersDict["ansId"]
            selectedVideo = answersDict
            self.performSegue(withIdentifier: "goToAnswer", sender: self)
        }
        
    }
    
    func getSingleUser(userDict:NSDictionary) {
        if fromActivity {
            let lUser = User(userdict: userDict)
            activityUsersArray.append(lUser)
            activityUsersArray.insert(lUser, at: 0)
            if activityUsersArray.count > 25 {
                activityUsersArray.remove(at: 25)
            }
            tableView.reloadData()
            return
        }
        selectedUser = userDict
        
        if !callDelegate {
            return
        }
        callDelegate = false
        if selectedActivity?.questionId == "" {
            self.performSegue(withIdentifier: "goToUserProfile", sender: self)
        }
        QuestionsDBHandler.Instance.getVideoQuestionById(questionId: (selectedActivity?.questionId)!, answerId: (selectedActivity?.answerId)!)
    }
    
    func getUserActivities(userActiviyDict:NSDictionary) {
        
        let tempStr = userActiviyDict["activities"] as? String
        if tempStr == nil {
            return
        }
        let activity = UserActivities(activityDict: userActiviyDict)
        let dateDict = userActiviyDict["date"]
        if dateDict == nil {
            return
        }
        let lDate = MyDate(dateDict: dateDict as! NSDictionary)
        activity.date = lDate
       // userAllActivites.append(activity)
        let sArray = userAllActivites.filter() {$0.activityId.contains((activity.activityId))}
        if sArray.count > 0 {
            return
        }
       // userAllActivites.insert(activity, at: 0)
        userAllActivites.append(activity)
        if userAllActivites.count > 0 {
            loadingAnimationView.isHidden = true
            noDataLabel.isHidden = true
        }
        if userAllActivites.count > 25 {
            userAllActivites.remove(at: 0)
        }
        fromActivity = true
        tableView.reloadData()
        UserDBHandler.Instance.getSingleUserDelegate = self
        UserDBHandler.Instance.getSingleUser(userId: activity.userId)
        //tableView.reloadData()
        
    }
    
    @IBAction func DeleteActivityAction(_ sender: UIButton) {
        
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        let lActivity = userAllActivites[(indexPath?.item)!]
        UserDBHandler.Instance.deleteUserActivity(activityId: lActivity.activityId)
        userAllActivites.remove(at: (indexPath?.item)!)
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayVideoController" {
            let nextScene = segue.destination as! VideoViewController
            nextScene.selectedQuestion = selectedVideo as? NSMutableDictionary
        }
        
        else if segue.identifier == "goToAnswer" {
            let nextScene = segue.destination as! ReplyVideoViewController
            nextScene.selectedUser = selectedUser
            nextScene.selectedAnswer = selectedVideo as? NSMutableDictionary
            nextScene.questionKey = questionKey
            nextScene.vc = "myVideos"
        }
        else if segue.identifier == "goToUserProfile" {
            let nextScene = segue.destination as! UserProfileViewController
            nextScene.selectedUser = User(userdict: selectedUser!)
            nextScene.viewControllerName = "Home"
        }
    }
    

}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dict = UserDefaults.standard.value(forKey: USER_DICT) {
            
        }
        else {
            return 0
        }
        
        
        if userAllActivites.count > 0 {
            loadingAnimationView.isHidden = true
            
        }
        if userAllActivites.count > 24 {
            return 25
        }
        else {
            return userAllActivites.count
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 667
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        return topView
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        let lActivity = userAllActivites[userAllActivites.count-indexPath.row-1]
        let uDict = UserDefaults.standard.value(forKey: USER_DICT)
        let lUser = User(userdict: uDict as! NSDictionary)
        if (lUser.profile.characters.count) < 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "noProfileCell", for: indexPath as IndexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath as IndexPath)
        }

//        
        let profileImgView = cell.viewWithTag(1) as! UIImageView
        let activityText = cell.viewWithTag(2) as! UILabel
        if (lUser.profile.characters.count) < 2 {
            print("no image")
        }
        else {
            
            let sArray = activityUsersArray.filter() {$0.id.contains((lActivity.userId))}
            if sArray.count == 0 {
                return cell
            }
            let activityUser = sArray[0]
            
           // let activityUser = activityUsersArray[indexPath.row]
            let profileUrl = URL(string: activityUser.profile)
            profileImgView.kf.setImage(with: profileUrl)
        }
//
        activityText.text = lActivity.activities
        profileImgView.roundImageView()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  selectedIndexPath = indexPath.row
        let lActivity = userAllActivites[userAllActivites.count-indexPath.row-1]
        questionKey = lActivity.questionId
        selectedActivity = lActivity
        callDelegate = true
        fromActivity = false
        QuestionsDBHandler.Instance.getAnswersDelegate = self
        UserDBHandler.Instance.getSingleUserDelegate = self
        UserDBHandler.Instance.getSingleUser(userId: lActivity.userId)
    }
}

