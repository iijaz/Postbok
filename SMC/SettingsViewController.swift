//
//  SettingsViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/15/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, VerifyUserNameDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var newUsername: UITextField!
    
    
    @IBOutlet weak var updateUsernameView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var loadingIndicator: UIActivityIndicatorView?
    
    var dataSourceArray = [NSDictionary]()
    var lUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDBHandler.Instance.verifyUserNameDelegate = self
        cardView.roundViewAndSetShadow()
        let dict = UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary
        lUser = User(userdict: dict)
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        tableview.addGestureRecognizer(swipeRight)
        
       let username = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let firstcellString = "My smc id @"+username
        dataSourceArray = [["textLabel":firstcellString,"imageName":"smc_id_icon.png"],["textLabel":"Change name","imageName":"username_icon.png"], ["textLabel":"Add/Delete network","imageName":"add_delete_icon.png"], ["textLabel":"Privacy and Terms of Use","imageName":"privacy_icon.png"], ["textLabel":"Support","imageName":"terms_of_use.png"], ["textLabel":"Blocked Users","imageName":"terms_of_use.png"],["textLabel":"Private Account","imageName":"terms_of_use.png"]]
       // self.tabBarController?.tabBar.backgroundImage = UIImage(named: "club_background3.png")

        // Do any additional setup after loading the view.
        
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
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        UIView.animate(withDuration: 6.0,
                       delay: TimeInterval(3),
                       options: UIViewAnimationOptions.transitionFlipFromRight,
                       animations: {
                        self.navigationController?.popViewController(animated: true)
                        self.view.layoutIfNeeded()
        },
                       completion: { (true) in
        })
    }
    
    func verifyUserName(usersDict:NSDictionary) {
        for item in usersDict as NSDictionary {
            let userD = item.value as! NSDictionary
            let str = userD["name"] as? String
            if str?.lowercased() == newUsername.text?.lowercased() {
                DoRegisteruser(exist: true)
                return
            }
        }
        DoRegisteruser(exist: false)
        
    }
    
    func DoRegisteruser(exist: Bool) {
       // stopLoadingIndicator()
        errorLabel.text = "This username already exist please try another"
        
        if exist {
            //self.informativeAlert(msg: "This username is already exist please try another")
            self.errorLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.errorLabel.isHidden = true
            })
            stopLoadingIndicator()
            
        }
        else {
            UserDefaults.standard.set(newUsername.text, forKey: USER_UNIQUE_NAME)
            UserDefaults.standard.setValue(newUsername.text, forKey: USER_SERVER_NAME)
            UserDBHandler.Instance.updateUserName(userName: newUsername.text!)
            updateUsernameView.isHidden = true
            newUsername.resignFirstResponder()
            self.view.makeToast("Username updated successfully")
            stopLoadingIndicator()
            
            
            print("this is unique")
        }
    }
    
    @IBAction func CopyButton(_ sender: UIButton) {
        let uniqueName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
        let someText = "https://www.thesmc.xyz/"+uniqueName!
        UIPasteboard.general.string = someText
        self.view.makeToast("Your profile link copied")
    }
    
    @IBAction func HideUserNameView(_ sender: UIButton) {
        updateUsernameView.isHidden = true
        newUsername.resignFirstResponder()
    }
    
    @IBAction func ChangeUserName(_ sender: UIButton) {
        showLoadingIndicater()
        UserDBHandler.Instance.verifyUserName(userId: errorLabel.text!)
    }
    
    func showLoadingIndicater() {
        let screenSize: CGRect = UIScreen.main.bounds
        let indicatorWidth = screenSize.width+100
        let indicatorHeight = screenSize.height-75
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: indicatorWidth/2, y: indicatorHeight/2, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator?.startAnimating()
        self.view.addSubview(loadingIndicator!)
    }
    
    func stopLoadingIndicator() {
        loadingIndicator?.stopAnimating()
        self.loadingIndicator?.removeFromSuperview()
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ValueChanged(_ sender: UISwitch) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        if sender.isOn {
            print("private")
            DBProvider.Instance.userRef.child(accountId!).child(USER_ACCOUNT_TYPE).setValue("Private")
        }
        else {
            print("public")
            DBProvider.Instance.userRef.child(accountId!).child(USER_ACCOUNT_TYPE).setValue("Public")
        }
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let data = dataSourceArray[indexPath.row]
        var cell : UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        let imgView = cell.viewWithTag(1) as! UIImageView
        let label = cell.viewWithTag(2) as! UILabel
        let copyImageView = cell.viewWithTag(3) as! UIButton
        let privateSwitch = cell.viewWithTag(4) as! UISwitch
        
        
        
        imgView.image = UIImage(named: data["imageName"] as! String)
        label.text = data["textLabel"] as? String
        if indexPath.row == 0 {
            copyImageView.isHidden = false
        }
        else {
            copyImageView.isHidden = true
        }
        
        if indexPath.row == 6 {
            privateSwitch.isHidden = false
            if lUser?.accountType.lowercased() == "private" {
                privateSwitch.isOn = true
            }
            else {
                privateSwitch.isOn = false
            }
        }
        else {
            privateSwitch.isHidden = true
        }
        
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 2 {
          self.performSegue(withIdentifier: "goToSocial", sender: self)
        }
        else if indexPath.item == 1 {
            updateUsernameView.isHidden = false
        }
        else if indexPath.item == 3 {
           self.performSegue(withIdentifier: "privacy", sender: self)
        }
        else if indexPath.item == 4 {
            self.performSegue(withIdentifier: "support", sender: self)
        }
        else if indexPath.item == 5 {
            self.performSegue(withIdentifier: "blockedUsers", sender: self)
        }
    }
}

