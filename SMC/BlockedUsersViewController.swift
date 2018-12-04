//
//  BlockedUsersViewController.swift
//  SMC
//
//  Created by JuicePhactree on 4/17/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit

class BlockedUsersViewController: UIViewController, GetSingleUserDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var blockedUserLabel: UILabel!
    var selectedUser: User?
    var arrayOfUsers = [User]()
    var sUser: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.init()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
//        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
//        DBProvider.Instance.userRef.child(accountId!).child("Blocked").observeSingleEvent(of: .value, with: { (snapshot) in
//            let dict = snapshot.value as! NSDictionary
//            UserDefaults.standard.setValue(dict, forKey: BLOCKED_USERS)
//
//        })
        
        if let blockDict = UserDefaults.standard.value(forKey: BLOCKED_USERS) as? NSDictionary {
            let blockIdArray = blockDict.allKeys
            for idItem in blockIdArray {
                UserDBHandler.Instance.getSingleUserDelegate = self
                UserDBHandler.Instance.getSingleUser(userId: idItem as! String)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSingleUser(userDict:NSDictionary) {
        let lUser = User(userdict: userDict)
        arrayOfUsers.append(lUser)
        tableView.reloadData()
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfile" {
            let nextScene = segue.destination as! UserProfileViewController
            nextScene.selectedUser = sUser
            nextScene.viewControllerName = "Home"
        }
    }


}

extension BlockedUsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayOfUsers.count == 0 {
            blockedUserLabel.isHidden = false
        }
        else {
            blockedUserLabel.isHidden = true
        }
        return arrayOfUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        let lUser = arrayOfUsers[indexPath.row]
        let profileString = lUser.profile

        cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath as IndexPath)
        
        let profileImgView = cell.viewWithTag(1) as! UIImageView
        let userNmae = cell.viewWithTag(2) as! UILabel
        let followBtn = cell.viewWithTag(3) as! UIButton
        followBtn.layer.cornerRadius = 5.0
        
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
