//
//  VisitorVideoViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/27/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class VisitorVideoViewController: UIViewController, GetFilteredVideoQuestionsDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noVideoView: UIView!
    
    var arrayOfVideoQuestions = [NSDictionary]()
    var selectedVideo: NSDictionary?
    var selectedUser: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionsDBHandler.Instance.getFilteredVideoQuestionsDelegate = self
        QuestionsDBHandler.Instance.getFilteredQuestionsWithUserId(userId: (selectedUser?.id)!)
        UserDefaults.standard.setValue("1", forKey: "userConstraintValue")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getFilteredVideoQuestions(questionsDict:NSMutableDictionary, key: String) {
        
//        if selectedUser?.accountType.lowercased() == "private" {
//            return
//        }
        questionsDict["key"] = key
        
        let questionId = questionsDict["quesId"] as! String
        let sArray = arrayOfVideoQuestions.filter() {($0["quesId"] as! String).contains((questionId))}
        if sArray.count > 0 {
            return
        }
        
        arrayOfVideoQuestions.insert(questionsDict, at: 0)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayVideoController" {//goToFollowings
            let nextScene = segue.destination as! VideoViewController
            nextScene.selectedQuestion = selectedVideo as? NSMutableDictionary
        }
    }

}

extension VisitorVideoViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let playImageView = cell.viewWithTag(2) as! UIImageView
        questionImgView.kf.setImage(with: imgUrl)
        questionImgView.roundImageView()
        let localDate = Date(timeIntervalSince1970: (TimeInterval((serverDate?.intValue)! / 1000)))
        print(localDate)
        if (lQuestion["videoLink"] as! String) == "" {
            playImageView.image = UIImage(named: "pictureDefault.png")
        }
        else {
            playImageView.image = UIImage(named: "round_video_play_button.png")
        }
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 3 {
            let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
            let screenWidth: CGFloat = UIScreen.main.bounds.size.width-20
            
            let cellWidth = screenWidth/numberOfCell
            return CGSize(width: cellWidth, height: cellWidth)
            
        }
        else if collectionView.tag == 1 {
            return CGSize(width: 80, height: 95)
        }
        else {
            return CGSize(width: 80, height: 70)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        selectedVideo = arrayOfVideoQuestions[indexPath.item]
        self.performSegue(withIdentifier: "goToPlayVideoController", sender: self)
    }
}

