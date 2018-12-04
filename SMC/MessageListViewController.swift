//
//  MessageListViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/10/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit

class MessageListViewController: UIViewController, GetChatUsersDelegate, GetNewMessageUsersDelegate, GetSingleUserDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var noMessageLabel: UILabel!
    
    var chatUsers = [User]()
    var userConvIds = [String]()
    var newMessagesUserIds = [String]()
    var selectedIndexPath: Int?
    var loadCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImageView.image = UIImage.gif(name: "loadinganimation")
        UserDBHandler.Instance.getSingleUserDelegate = self
        UserDBHandler.Instance.getSingleUser(userId: "16475566924")


        tableView.tableFooterView = UIView.init()
        ChatingDBHandler.Instance.getChatUsersDelegate = self
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        ChatingDBHandler.Instance.getChatUsers(accounId: accountId!)
        
        loadCount = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UserDBHandler.Instance.getNewMessagedUserDelegate = self
        UserDBHandler.Instance.GetNewMessagesUsers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            if self.chatUsers.count == 0 {
                self.loadingImageView.isHidden = true
                self.noMessageLabel.isHidden = false
                self.tableView.reloadData()
            }
        })
        
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadCount = 0
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
        if lUser.id == "16475566924" {
            chatUsers.append(lUser)
        }
        
       
    }
    
    func getChatUsers(userDict:NSDictionary, conversationId: String, time: Int) {
        
        let lUser = User(userdict: userDict)
        chatUsers.append(lUser)
        userConvIds.append(conversationId)
        

        tableView.reloadData()
    }
    
    func getNewMessgedUsers(userDict:NSDictionary) {
        print("hi")
        newMessagesUserIds = userDict.allKeys as! [String]
        tableView.reloadData()
    }
    
    func showHideLoadingAnimation(totalItems: Int) {
        if totalItems > 0 {
            loadingImageView.isHidden = true
            tableView.isHidden = false
        }
        else {
            //loadingImageView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat" {
            let nextScene = segue.destination as! ChatViewController
            nextScene.selectedUser = chatUsers[selectedIndexPath!]
            if chatUsers[selectedIndexPath!].id == "16475566924" {
                nextScene.conversationId = "1"
            }
            else {
                nextScene.conversationId = userConvIds[selectedIndexPath!-1]
            }
            
        }
    }

}

extension MessageListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.showHideLoadingAnimation(totalItems: chatUsers.count)
        return chatUsers.count
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
//        if indexPath.row == chatUsers.count {
//            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath as IndexPath)
//            return cell
//        }
        let lUser = chatUsers[indexPath.row]
        let profileString = lUser.profile
        if (profileString.characters.count) < 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "noProfileCell", for: indexPath as IndexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath as IndexPath)
        }
        
        let profileImgView = cell.viewWithTag(1) as! UIImageView
        let notiImageView = cell.viewWithTag(3) as! UIImageView
        notiImageView.roundImageView()
        let userNmae = cell.viewWithTag(2) as! UILabel
        if (profileString.characters.count) < 2 {
            print("no image")
        }
        else {
            let profileUrl = URL(string: profileString)
            profileImgView.kf.setImage(with: profileUrl)
        }
        
        let sArray = newMessagesUserIds.filter() {$0.contains((lUser.id))}
        if sArray.count > 0 {
            notiImageView.isHidden = false
        }
        else {
            if lUser.id == "16475566924" {
                let notiVal = UserDefaults.standard.value(forKey: "isNewUser") as! Bool
                if notiVal {
                    notiImageView.isHidden = false
                }
                else {
                    notiImageView.isHidden = true
                }
            }
            else {
                notiImageView.isHidden = true
            }
            
        }
        
        userNmae.text = lUser.username
        profileImgView.roundImageView()

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == chatUsers.count {
//          self.performSegue(withIdentifier: "goToChat", sender: self)
//        }
        selectedIndexPath = indexPath.row
        self.performSegue(withIdentifier: "goToChat", sender: self)
    }
}
