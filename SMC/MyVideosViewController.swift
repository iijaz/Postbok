//
//  MyVideosViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/20/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class MyVideosViewController: UIViewController, GetFilteredVideoQuestionsDelegate, GetUserAnswersDelegate, GetSingleUserDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noVideoView: UIView!
    @IBOutlet weak var loadingAnimationImageView: UIImageView!
    
    @IBOutlet weak var noPostLabel: UILabel!
    @IBOutlet weak var addPostBtn: UIButton!
    
    var arrayOfVideoQuestions = [NSDictionary]()
    var selectedVideo: NSDictionary?
    var selectedUser: NSDictionary?
    var callDelegate: Bool = false
    var isEditMode: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAnimationImageView.image = UIImage.gif(name: "loadinganimation")
        self.view.backgroundColor = UIColor.clear
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID)
        QuestionsDBHandler.Instance.getFilteredVideoQuestionsDelegate = self
        AnswersDBHandler.Instance.getAllUserAnswersDelegate = self
      QuestionsDBHandler.Instance.getFilteredQuestionsWithUserId(userId: accountId! as! String)
        //QuestionsDBHandler.Instance.getFilteredQuestionsWithUserId(userId: "126423844734346")
        
        AnswersDBHandler.Instance.getUserAnswers()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))


        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)

    }
    
    override func viewDidLayoutSubviews() {
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("in viewwillappear")
        UserDefaults.standard.setValue("1", forKey: "constraintValue")
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    if self.arrayOfVideoQuestions.count == 0 {
                        self.loadingAnimationImageView.isHidden = true
                        self.noPostLabel.isHidden = false
                        self.addPostBtn.isHidden = false
                    }
                })
        
        let str = UserDefaults.standard.value(forKey: "controller") as? String
        if str == "camera" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 30.0, execute: {
                for dictt in self.arrayOfVideoQuestions {
                    if dictt["videoThumbLink"] as? String == "" {
                        let ind = self.arrayOfVideoQuestions.index(of: dictt)
                        self.arrayOfVideoQuestions.remove(at: ind!)
                        let qStr = dictt["quesId"] as? String
                        QuestionsDBHandler.Instance.deleteSelectedVideo(videoId: qStr!, isQuestion: true, questionId: qStr!)
                        self.collectionView.reloadData()
                        self.view.makeToast("Uploading failed due to slow internet connection", duration: 2.0, position: .top)
                    }
                }
                
            })
            
        }
        else {
            for dictt in self.arrayOfVideoQuestions {
                if dictt["videoThumbLink"] as? String == "" {
                    let ind = self.arrayOfVideoQuestions.index(of: dictt)
                    if ind == 0 {
                        return
                    }
                    self.arrayOfVideoQuestions.remove(at: ind!)
                    let qStr = dictt["quesId"] as? String
                    QuestionsDBHandler.Instance.deleteSelectedVideo(videoId: qStr!, isQuestion: true, questionId: qStr!)
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.setValue("a", forKey: "controller")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getFilteredVideoQuestions(questionsDict:NSMutableDictionary, key: String) {
        questionsDict["key"] = key
        
        let str = UserDefaults.standard.value(forKey: "controller") as? String
        if str == "camera" {
            if arrayOfVideoQuestions.count > 0 {
                let dictt = arrayOfVideoQuestions.first
                if dictt!["videoThumbLink"] as! String == ""{
                    if questionsDict["videoThumbLink"] as! String == "" {
                        return
                    }
                }
                else {
                }
            }
            
        }
        else {
            if questionsDict["videoThumbLink"] as! String == "" {
                
                let qArray = arrayOfVideoQuestions.filter() {
                    ($0["videoThumbLink"] as! String).elementsEqual("")
                }
                if qArray.count > 0 {
                    let noThumbVideo = qArray[0]
                    let ind = self.arrayOfVideoQuestions.index(of: noThumbVideo)
                    arrayOfVideoQuestions.remove(at: ind!)
                    let qStr = noThumbVideo["quesId"] as? String
                    QuestionsDBHandler.Instance.deleteSelectedVideo(videoId: qStr!, isQuestion: true, questionId: qStr!)
                }
                
                //return
            }
        }
        
        let sArray = arrayOfVideoQuestions.filter() {($0["key"] as! String).contains((key))}
        if sArray.count > 0 {
            let duplicaeVid = sArray[0]
            let ind = self.arrayOfVideoQuestions.index(of: duplicaeVid)
            arrayOfVideoQuestions.remove(at: ind!)
            //arrayOfVideoQuestions.removeFirst()
        }
        
        //arrayOfVideoQuestions.insert(questionsDict, at: 0)
        arrayOfVideoQuestions.append(questionsDict)
        //collectionView.reloadData()
        arrayOfVideoQuestions.sort{
            (($0 as! Dictionary<String, AnyObject>)["date"] as? Int)! > (($1 as! Dictionary<String, AnyObject>)["date"] as? Int)!
        }
        collectionView.reloadData()
        
    }
    
    func getUserAnswers(answerDict:NSMutableDictionary, key: String) {
        answerDict["key"] = answerDict["ansId"] as? String
        
        let sArray = arrayOfVideoQuestions.filter() {($0["key"] as! String).contains((key))}
        if sArray.count > 0 {
            let duplicaeVid = sArray[0]
            let ind = self.arrayOfVideoQuestions.index(of: duplicaeVid)
            arrayOfVideoQuestions.remove(at: ind!)
           // arrayOfVideoQuestions.removeFirst()
        }
        
        arrayOfVideoQuestions.append(answerDict)
        
        
        arrayOfVideoQuestions.sort{
            (($0 as! Dictionary<String, AnyObject>)["date"] as? Int)! > (($1 as! Dictionary<String, AnyObject>)["date"] as? Int)!
        }
        collectionView.reloadData()
        
    }
    
    func getSingleUser(userDict:NSDictionary) {
        if callDelegate {
            selectedUser = userDict
            self.performSegue(withIdentifier: "goToAnswer", sender: self)
        }
        callDelegate = false
        
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            isEditMode = true
            collectionView.reloadData()
            return
        }
        
        let point = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let index = indexPath {
            var cell = self.collectionView.cellForItem(at: index)
        } else {
            print("Could not find index path")
        }
    }
    
    @IBAction func DeleteAction(_ sender: UIButton) {
        
        //let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        let collectionViewCell = sender.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: collectionViewCell)
        let dict = arrayOfVideoQuestions[(indexPath?.item)!] as NSDictionary
        let ansStr = dict["ansId"] as? String
        let qStr = dict["quesId"] as? String
        if (ansStr?.characters.count)! > 2 {
            QuestionsDBHandler.Instance.deleteSelectedVideo(videoId: ansStr!, isQuestion: false, questionId: qStr!)
        }
        else {
            let qStr = dict["quesId"] as? String
            QuestionsDBHandler.Instance.deleteSelectedVideo(videoId: qStr!, isQuestion: true, questionId: qStr!)
        }
        arrayOfVideoQuestions.remove(at: (indexPath?.item)!)
        collectionView.reloadData()

    }
    
    
    @IBAction func RecordVideo(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCamera", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayVideoController" {//goToFollowings
            let nextScene = segue.destination as! VideoViewController
            nextScene.selectedQuestion = selectedVideo as? NSMutableDictionary
        }
        else if segue.identifier == "goToAnswer" {
            let nextScene = segue.destination as! ReplyVideoViewController
            nextScene.selectedUser = selectedUser
            nextScene.selectedAnswer = selectedVideo as? NSMutableDictionary
            nextScene.questionKey = selectedVideo?["quesId"] as? String
            nextScene.vc = "myVideos"
        }
        else if segue.identifier == "goToCamera" {
            let nextScene = segue.destination as! CameraViewController
            nextScene.calledfrom = "smc"
        }
    }
}

extension MyVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if arrayOfVideoQuestions.count > 0 {
                collectionView.isHidden = false
                noVideoView.isHidden = true
            }
            else {
                collectionView.isHidden = true
                noVideoView.isHidden = false
            }
            return arrayOfVideoQuestions.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            var cell : UICollectionViewCell
            
            let lQuestion = arrayOfVideoQuestions[indexPath.item]
            let questionString = lQuestion["videoThumbLink"] as? String
            let serverDate = lQuestion["date"] as? NSNumber
            let imgUrl = URL(string: questionString!)
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoItem", for: indexPath as IndexPath)
            let questionImgView = cell.viewWithTag(1) as! UIImageView
            let deleteBtn = cell.viewWithTag(2) as! UIButton
            questionImgView.kf.setImage(with: imgUrl)
            questionImgView.roundImageView()
            let localDate = Date(timeIntervalSince1970: (TimeInterval((serverDate?.intValue)! / 1000)))
            print(localDate)
            let playImageView = cell.viewWithTag(4) as! UIImageView
            if (lQuestion["videoLink"] as! String) == "" {
               // playImageView.isHidden = true
                 playImageView.image = UIImage(named: "pictureDefault.png")
            }
            else {
               // playImageView.isHidden = false
                playImageView.image = UIImage(named: "round_video_play_button.png")
            }
            
            deleteBtn.isHidden = !isEditMode
            playImageView.isHidden = isEditMode
            
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
            let screenWidth: CGFloat = UIScreen.main.bounds.size.width-55
            
            let cellWidth = screenWidth/numberOfCell
            return CGSize(width: cellWidth, height: cellWidth)
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // handle tap events
            if isEditMode {
                isEditMode = false
                collectionView.reloadData()
                return
            }
            
            selectedVideo = arrayOfVideoQuestions[indexPath.item]
            if (selectedVideo!["videoThumbLink"] as! String) == "" {
               // self.view.makeToast("Uploading")
                self.view.makeToast("Uploading", duration: 0.3, position: .top)
                return
            }
            
//            if (selectedVideo!["videoLink"] as! String) == "" {
//                let vc = self.parent?.parent as! MyProfileViewController
//                vc.showUploadedImage(urlString: selectedVideo!["videoThumbLink"] as! String)
//                return
//            }
            
            let ansId = selectedVideo?["ansId"] as? String
            if (ansId?.characters.count)! > 2 {
                callDelegate = true
                UserDBHandler.Instance.getSingleUserDelegate = self
                UserDBHandler.Instance.getSingleUser(userId: selectedVideo?["userId"] as! String)
            }
            else {
                
                self.performSegue(withIdentifier: "goToPlayVideoController", sender: self)
            }
        }

}

