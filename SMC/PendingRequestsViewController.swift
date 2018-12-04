//
//  PendingRequestsViewController.swift
//  SMC
//
//  Created by JuicePhactree on 7/2/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit

class PendingRequestsViewController: UIViewController,  GetUserFollowingDelegate, GetSingleUserDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfPendingUsers = [User]()
    var sUser: User?
    let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.init()
        UserDBHandler.Instance.getUserFollowingDelegate = self
        UserDBHandler.Instance.getSingleUserDelegate = self
        UserDBHandler.Instance.getUserFollowings(userId: accountId!)
        DBProvider.Instance.userRef.child(accountId!).child("followerRequestStatus").setValue(0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserFollowing(userFollowingId:String) {
       // UserDBHandler.Instance.getSingleUser(userId: userFollowingId)
    }
    
    func getUserPendingRequests(userPendingId: String) {
        UserDBHandler.Instance.getSingleUser(userId: userPendingId)
    }
    
    func getSingleUser(userDict:NSDictionary) {
        let lUser = User(userdict: userDict)
        arrayOfPendingUsers.append(lUser)
        tableView.reloadData()
    }
    
    @IBAction func DeleteRequestAction(_ sender: UIButton) {
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        let lUser = arrayOfPendingUsers[(indexPath?.row)!]
        arrayOfPendingUsers.remove(at: (indexPath?.row)!)
        UserDBHandler.Instance.deleteFollowRequest(userId: lUser.id, accountId: accountId!)
        tableView.reloadData()
        
    }
    
    @IBAction func ConfirmRequestAction(_ sender: UIButton) {
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
        let lUser = arrayOfPendingUsers[(indexPath?.row)!]
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        UserDBHandler.Instance.acceptFollowRequest(userId: lUser.id, accountId: accountId!)
        arrayOfPendingUsers.remove(at: (indexPath?.row)!)
        let commentString = lUser.username+" started following you"
        let commentString2 = uniqueName+" accepted your Follow Request"
        UserDBHandler.Instance.setOtherUserFollowingActivities(activityString: commentString, userId: accountId!, accountId: lUser.id)
        UserDBHandler.Instance.setOtherUserFollowingActivities(activityString: commentString2, userId: lUser.id, accountId: accountId!)
        UserDBHandler.Instance.setNoOfUserFollowing(userId: accountId!, isFollowed: true, accountId: lUser.id)
        DBProvider.Instance.userRef.child(lUser.id).child("replies").setValue("1")
        tableView.reloadData()
    }
    
    
    @IBAction func GoBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PendingRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPendingUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        let lUser = arrayOfPendingUsers[indexPath.row]
        let profileString = lUser.profile
        if (profileString.characters.count) < 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "pendingCell", for: indexPath as IndexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "pendingCell", for: indexPath as IndexPath)
        }
        
        let profileImgView = cell.viewWithTag(1) as! UIImageView
        let userNmae = cell.viewWithTag(2) as! UILabel
        let followBtn = cell.viewWithTag(3) as! UIButton
        let deleteBtn = cell.viewWithTag(4) as! UIButton
        followBtn.layer.cornerRadius = 5.0
        deleteBtn.layer.cornerRadius = 5.0
        deleteBtn.layer.borderColor = UIColor.darkGray.cgColor
        deleteBtn.layer.borderWidth = 1.0
        
        
        if (profileString.characters.count) < 2 {
            print("no image")
        }
        else {
            let profileUrl = URL(string: profileString)
            profileImgView.kf.setImage(with: profileUrl)
        }
        
        
        userNmae.text = lUser.username
        profileImgView.roundImageView()
        profileImgView.layer.borderWidth = 1.0
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sUser = arrayOfPendingUsers[indexPath.row]
    }
}
