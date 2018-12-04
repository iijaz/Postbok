//
//  SearchViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/27/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit
import SwiftGifOrigin
class SearchViewController: UIViewController, GetAllUsersDelegate, GetAllVideoQuestionsDelegate   {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var tagBtn: UIButton!
    @IBOutlet weak var professionBtn: UIButton!
    @IBOutlet weak var titleLine: UIImageView!
    @IBOutlet weak var nameLine: UIImageView!
    @IBOutlet weak var professionLine: UIImageView!
    
    @IBOutlet weak var magnifierView: UIView!
    
    @IBOutlet weak var tagLine: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingImage: UIImageView!
    
    var allVideos = [NSDictionary]()
    var allUsers = [User]()
    var isVideosSearchOn: Bool = false
    var isTagSearchOn: Bool = false
    var isSearching: Bool = false
    var isProfessionSearchOn: Bool = false
    
    var searchedUserArray = [User]()
    var searchedVideosArray = [NSDictionary]()
    
    var selectedVideo: NSDictionary?
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImage.image = UIImage.gif(name: "loadinganimation")
        tableView.tableFooterView = UIView.init()
       // nameBtn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        //nameBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        
        UserDBHandler.Instance.getAllUsersDelegate = self
        UserDBHandler.Instance.getAllRegisterdUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // UserDBHandler.Instance.getAllUsersDelegate = self
        QuestionsDBHandler.Instance.getAllVideoQuestionsDelegate = self
        QuestionsDBHandler.Instance.getAllVideoQuestionsForSearch()
       // UserDBHandler.Instance.getAllRegisterdUsers()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAllUsers(userDict:NSDictionary) {
//        allUsers.removeAll()
//        tableView.reloadData()
//        for item in userDict as NSDictionary {
//            if let userD = item.value as? NSDictionary {
//                if userD["name"] == nil {
//                    return
//                }
//                let lUser = User(userdict: userD)
//                allUsers.append(lUser)
//                tableView.reloadData()
//            }
//
//        }
        let lUser = User(userdict: userDict)
        allUsers.append(lUser)
        tableView.reloadData()
        
    }
    
    func getAllVideoQuestions(questionsDict:NSMutableDictionary, key: String) {
        allVideos.removeAll()
        tableView.reloadData()
        for item in questionsDict as NSDictionary {
            if let question = item.value as? NSMutableDictionary {
                if question["quesId"] == nil {
                    return
                }
                question["key"] = item.key
                allVideos.append(question)
                tableView.reloadData()
            }
            
        }
        
    }
    
    @IBAction func EditingChanged(_ sender: UITextField) {
        if searchTextField.text?.characters.count == 0 {
            isSearching = false
            if isVideosSearchOn || isTagSearchOn || isProfessionSearchOn {
               magnifierView.isHidden = false
            }
            
        }
        else {
            isSearching = true
            magnifierView.isHidden = true
        }
        if isProfessionSearchOn {
            searchedUserArray = allUsers.filter() {
                print($0.profession)
                return $0.profession.lowercased().contains((searchTextField.text?.lowercased())!)}
            
        }
        
        else if isTagSearchOn {
            searchedVideosArray = allVideos.filter() {
                let vidTitle = $0["tags"] as! String
                return vidTitle.lowercased().contains((searchTextField.text?.lowercased())!)}
        }
        else if isVideosSearchOn {
           searchedVideosArray = allVideos.filter() {
            let vidTitle = $0["title"] as! String
            return vidTitle.lowercased().contains((searchTextField.text?.lowercased())!)}
        }
        else {
            searchedUserArray = allUsers.filter() {$0.username.lowercased().contains((searchTextField.text?.lowercased())!)}
        }
        tableView.reloadData()
        
    }

    @IBAction func TitlePressed(_ sender: UIButton) {
        loadingImage.isHidden = true
        
        if isSearching {
            magnifierView.isHidden = true
        }
        else {
            magnifierView.isHidden = false
        }
        //titleBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
//        nameBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Regular", size: 15)
//        tagBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Regular", size: 15)
       // titleBtn.setTitleColor(UIColor.init(red: 91.0/255.0, green: 64.0/255.0, blue: 16.0/255.0, alpha: 1.0), for: .normal)
        titleBtn.setTitleColor(UIColor.black, for: .normal)
        tagBtn.setTitleColor(UIColor.black, for: .normal)
        nameBtn.setTitleColor(UIColor.black, for: .normal)
        professionBtn.setTitleColor(UIColor.black, for: .normal)
        
//        tagLine.isHidden = true
//        nameLine.isHidden = true
//        titleLine.isHidden = false
        
        tagLine.alpha = 0
        nameLine.alpha = 0
        titleLine.alpha = 1
        professionLine.alpha = 0
        
        isVideosSearchOn = true
        isProfessionSearchOn = false
        isTagSearchOn = false
        tableView.reloadData()
    }
    
    @IBAction func NamePressed(_ sender: Any) {
        magnifierView.isHidden = true
//        titleBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Regular", size: 15)
//        tagBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Regular", size: 15)
//        nameBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        
       // nameBtn.setTitleColor(UIColor.init(red: 91.0/255.0, green: 64.0/255.0, blue: 16.0/255.0, alpha: 1.0), for: .normal)
        nameBtn.setTitleColor(UIColor.black, for: .normal)
        tagBtn.setTitleColor(UIColor.black, for: .normal)
        titleBtn.setTitleColor(UIColor.black, for: .normal)
        professionBtn.setTitleColor(UIColor.black, for: .normal)
        
//        tagLine.isHidden = true
//        nameLine.isHidden = false
//        titleLine.isHidden = true
        
        tagLine.alpha = 0
        nameLine.alpha = 1
        titleLine.alpha = 0
        professionLine.alpha = 0
        
        isVideosSearchOn = false
        isTagSearchOn = false
        isProfessionSearchOn = false
        tableView.reloadData()
    }
    
    @IBAction func TagPressed(_ sender: UIButton) {
        loadingImage.isHidden = true
        if isSearching {
            magnifierView.isHidden = true
        }
        else {
            magnifierView.isHidden = false
        }
//        titleBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Regular", size: 15)
//        nameBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Regular", size: 15)
//        tagBtn.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        
      //  tagBtn.setTitleColor(UIColor.init(red: 91.0/255.0, green: 64.0/255.0, blue: 16.0/255.0, alpha: 1.0), for: .normal)
        tagBtn.setTitleColor(UIColor.black, for: .normal)
        nameBtn.setTitleColor(UIColor.black, for: .normal)
        titleBtn.setTitleColor(UIColor.black, for: .normal)
        professionBtn.setTitleColor(UIColor.black, for: .normal)
        
//        tagLine.isHidden = false
//        nameLine.isHidden = true
//        titleLine.isHidden = true
        
        tagLine.alpha = 1
        nameLine.alpha = 0
        titleLine.alpha = 0
        professionLine.alpha = 0
        
        isTagSearchOn = true
        isVideosSearchOn = false
        isProfessionSearchOn = false
        tableView.reloadData()
    }
    
    @IBAction func ProfessionPressed(_ sender: UIButton) {
        loadingImage.isHidden = true
        if isSearching {
            magnifierView.isHidden = true
        }
        else {
            magnifierView.isHidden = false
        }
       // professionBtn.setTitleColor(UIColor.init(red: 91.0/255.0, green: 64.0/255.0, blue: 16.0/255.0, alpha: 1.0), for: .normal)
        professionBtn.setTitleColor(UIColor.black, for: .normal)
        nameBtn.setTitleColor(UIColor.black, for: .normal)
        titleBtn.setTitleColor(UIColor.black, for: .normal)
        tagBtn.setTitleColor(UIColor.black, for: .normal)
        
        tagLine.alpha = 0
        nameLine.alpha = 0
        titleLine.alpha = 0
        professionLine.alpha = 1
        
        isTagSearchOn = false
        isVideosSearchOn = false
        isProfessionSearchOn = true
        tableView.reloadData()
    }
    
    
    func showHideLoadingAnimation(totalItems: Int) {
        if totalItems > 0 {
            loadingImage.isHidden = true
            tableView.isHidden = false
        }
        else {
            loadingImage.isHidden = false
            tableView.isHidden = true
        }
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
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isProfessionSearchOn {
            if isSearching {
                self.showHideLoadingAnimation(totalItems: searchedUserArray.count)
                loadingImage.isHidden = true
                return searchedUserArray.count
            }
            else {
                //self.showHideLoadingAnimation(totalItems: allVideos.count)
               // return allUsers.count
                return 0
            }
        }
        
        if isTagSearchOn {
            if isSearching {
                self.showHideLoadingAnimation(totalItems: searchedVideosArray.count)
                loadingImage.isHidden = true
                return searchedVideosArray.count
            }
            else {
                self.showHideLoadingAnimation(totalItems: allVideos.count)
                //return allVideos.count
                return 0
            }
        }
        
        if isVideosSearchOn {
            if isSearching {
                self.showHideLoadingAnimation(totalItems: searchedVideosArray.count)
                loadingImage.isHidden = true
                return searchedVideosArray.count
            }
            else {
                self.showHideLoadingAnimation(totalItems: allVideos.count)
                //return allVideos.count
                return 0
            }
            
        }
        else {
            
            if isSearching {
                self.showHideLoadingAnimation(totalItems: searchedUserArray.count)
                return searchedUserArray.count
            }
            else {
                self.showHideLoadingAnimation(totalItems: allUsers.count)
                if allUsers.count > 3 {
                    return 3
                }
                else {
                    return allUsers.count
                }
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        if isVideosSearchOn || isTagSearchOn {
            cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath as IndexPath)
            let lVideo: NSDictionary
            if isSearching {
                lVideo = searchedVideosArray[indexPath.row]
            }
            else {
                lVideo = allVideos[indexPath.row]
            }
            let profileImgView = cell.viewWithTag(1) as! UIImageView
            let title = cell.viewWithTag(2) as! UILabel
            let userName = cell.viewWithTag(3) as! UILabel
            let videoDate = cell.viewWithTag(4) as! UILabel
            let tagLabel = cell.viewWithTag(5) as! UILabel
            
            let playImageView = cell.viewWithTag(11) as! UIImageView
            if (lVideo["videoLink"] as! String) == "" {
                // playImageView.isHidden = true
                playImageView.image = UIImage(named: "pictureDefault.png")
            }
            else {
                
                playImageView.image = UIImage(named: "round_video_play_button.png")
                //  playImageView.isHidden = false
            }
            
            let thumbString = lVideo["videoThumbLink"] as! String
            let thumbUrl = URL(string: thumbString)
            profileImgView.kf.setImage(with: thumbUrl)
            profileImgView.roundImageView()
            profileImgView.layer.borderWidth = 1.0
            
            let userId = lVideo["userId"] as! String
            let sArray = allUsers.filter() {$0.id.contains((userId))}
            if sArray.count < 1 {
                return cell
            }
            let lUser = sArray[0]
            
            title.text = lVideo["title"] as? String
            userName.text = lUser.username
            videoDate.text = Common.convertDate(dateInteger: lVideo["date"] as! NSNumber)
            
            let tagString = lVideo["tags"] as? String
            var completeTag : String = ""
            let tagArray = tagString?.split(separator: " ")
            
            for item in tagArray! {
                completeTag = completeTag+"#"+item+" "
            }
            
            //tagLabel.text = lVideo["tags"] as? String
            tagLabel.text = completeTag
            profileImgView.layer.borderColor = UIColor.init(red: 206/255.0, green: 156.0/255.0, blue: 150/255.0, alpha: 1.0).cgColor
            
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath as IndexPath)
            let lUser: User
            if isSearching {
                lUser = searchedUserArray[indexPath.row]
            }
            else {
                lUser = allUsers[indexPath.row]
            }
            let profileImgView = cell.viewWithTag(1) as! UIImageView
            let userName = cell.viewWithTag(2) as! UILabel
            let profession = cell.viewWithTag(3) as! UILabel
            profession.text = lUser.profession
            userName.text = lUser.username
            let profileUrl = URL(string: lUser.profile)
            profileImgView.kf.setImage(with: profileUrl)
            profileImgView.roundImageView()
            profileImgView.layer.borderWidth = 1.0
            if isProfessionSearchOn {
                profession.isHidden = false
            }
            else {
                profession.isHidden = true
            }
            profileImgView.layer.borderColor = UIColor.init(red: 206/255.0, green: 156.0/255.0, blue: 150/255.0, alpha: 1.0).cgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isVideosSearchOn || isTagSearchOn {
            if isSearching {
                selectedVideo = searchedVideosArray[indexPath.row]
            }
            else {
                selectedVideo = allVideos[indexPath.row]
            }
            self.performSegue(withIdentifier: "goToPlayVideoController", sender: self)
        }
        else {
            if isSearching {
                selectedUser = searchedUserArray[indexPath.row]
            }
            else {
                selectedUser = allUsers[indexPath.row]
            }
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
    }
}
