//
//  FollowActivityViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/22/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class FollowActivityViewController: UIViewController, GetUserFollowingActivitiesDelegate, GetSingleUserDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingAnimationImageView: UIImageView!
    
    
    var userAllActivites = [UserActivities]()
    var callDelegate: Bool = false
    var selectedUser: User?
    var fromActivity: Bool = false
    var activityUsersArray = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAnimationImageView.image = UIImage.gif(name: "loadinganimation")
        UserDefaults.standard.setValue("1", forKey: "constraintValue")
        UserDBHandler.Instance.getUserFollowingActivitiesDelegate = self
        UserDBHandler.Instance.getUserFollowingActivities()
        tableView.tableFooterView = UIView.init()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child("replies").setValue("0")
        self.ChangeTabIcons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            if self.userAllActivites.count > 0 {
                self.loadingAnimationImageView.isHidden = true
                self.loadingLabel.isHidden = true
            }
            else {
                self.loadingAnimationImageView.isHidden = true
                self.loadingLabel.isHidden = false
            }
        })
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserFollowingActivities(userFollowingActiviyDict:NSDictionary) {
        
        let tempStr = userFollowingActiviyDict["activities"] as? String
        if tempStr == nil {
            return
        }
        let activity = UserActivities(activityDict: userFollowingActiviyDict)
        let dateDict = userFollowingActiviyDict["date"]
        if dateDict == nil {
            return
        }
        let lDate = MyDate(dateDict: dateDict as! NSDictionary)
        activity.date = lDate
       // userAllActivites.append(activity)
        userAllActivites.insert(activity, at: 0)
        if userAllActivites.count > 0 {
            loadingAnimationImageView.isHidden = true
            loadingLabel.isHidden = true
        }
        fromActivity = true
        UserDBHandler.Instance.getSingleUserDelegate = self
        UserDBHandler.Instance.getSingleUser(userId: activity.userId)
       // tableView.reloadData()
    }
    
    func getSingleUser(userDict:NSDictionary) {
        
       // self.performSegue(withIdentifier: "goToProfile", sender: self)
        if fromActivity {
            let lUser = User(userdict: userDict)
            activityUsersArray.append(lUser)
            activityUsersArray.insert(lUser, at: 0)
            tableView.reloadData()
            return
        }
        
        if !callDelegate {
            return
        }
        selectedUser  = User(userdict: userDict)
        let vc = self.parent?.parent as! MyProfileViewController
        vc.GoToUserProfile(lUser: selectedUser!)
        callDelegate = false
    }
    
    @IBAction func DeleteActivityAction(_ sender: UIButton) {
        
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        let lActivity = userAllActivites[(indexPath?.item)!]
        UserDBHandler.Instance.deleteUserFollowingActivity(activityId: lActivity.activityId)
        userAllActivites.remove(at: (indexPath?.item)!)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfile" {
            let nextScene = segue.destination as! UserProfileViewController
            nextScene.selectedUser = selectedUser
            nextScene.viewControllerName = "Activity"
        }
    }
}

extension FollowActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if userAllActivites.count > 0 {
            loadingAnimationImageView.isHidden = true
        }
        return userAllActivites.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        let lActivity = userAllActivites[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        let lActivity = userAllActivites[indexPath.row]
        callDelegate = true
        fromActivity = false
        UserDBHandler.Instance.getSingleUserDelegate = self
        UserDBHandler.Instance.getSingleUser(userId: lActivity.id)
    }
}
