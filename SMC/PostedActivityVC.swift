//
//  PostedActivityVC.swift
//  SMC
//
//  Created by JuicePhactree on 8/26/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit

class PostedActivityVC: UIViewController,GetAllPublishPostMediaDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noActivityView: UIView!
    
    @IBOutlet weak var navView: UIView!
    
    var arrayofPublishedMedia = [PublishPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        navView.layer.shadowColor = UIColor.darkGray.cgColor
        navView.layer.shadowOpacity = 5.0
        navView.layer.shadowOffset = CGSize(width: 0, height: 1)
        navView.layer.shadowRadius = 10
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        PublishPostDBHandler.Instance.getAllPublishMediaDelegate = self
        PublishPostDBHandler.Instance.getUserPublishedMedia(userId: accountId!)
        tableView.tableFooterView = UIView.init()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    @IBAction func GoBackAction(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func DeleteMediaAction(_ sender: UIButton) {
        
        let tableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)
//        let lPublishMedia = arrayofPublishedMedia[(indexPath?.row)!]
//        PublishPostDBHandler.Instance.deleteSelectedPublishedMedia(publishId: lPublishMedia.postId)
//        arrayofPublishedMedia.remove(at: (indexPath?.row)!)
//        tableView.reloadData()
        openDeleteMeidaActionSheet(selectedRow: (indexPath?.row)!)
    }
    
    func openDeleteMeidaActionSheet(selectedRow: Int){
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete selected Media", message: "Are you sure you want to delete this?", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let deleteMedia: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action -> Void in
            let lPublishMedia = self.arrayofPublishedMedia[selectedRow]
            PublishPostDBHandler.Instance.deleteSelectedPublishedMedia(publishId: lPublishMedia.postId)
            self.arrayofPublishedMedia.remove(at: selectedRow)
            self.tableView.reloadData()
        }
        
        actionSheetController.addAction(deleteMedia)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func getAllPublishMedia(mediaDict:NSDictionary) {
        
        let lPublishPost = PublishPost(postMediaDict: mediaDict)
        //arrayofPublishedMedia.append(lPublishPost)
        var sArray = arrayofPublishedMedia.filter() {
            
            $0.postId.contains(lPublishPost.postId)
        }
        
        if sArray.count > 0 {
            
            let loc = arrayofPublishedMedia.index(where: { (tempObject) -> Bool in
                
                tempObject.postId = sArray[0].postId
                return true
            })
            print("i")
            
            arrayofPublishedMedia.remove(at: loc!)
            arrayofPublishedMedia.insert(lPublishPost, at: loc!)
            tableView.reloadData()
            return
        }
        
        arrayofPublishedMedia.insert(lPublishPost, at: 0)
        noActivityView.isHidden = true
        tableView.reloadData()
        
    }

}

extension PostedActivityVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayofPublishedMedia.count == 0 {
            noActivityView.isHidden = false
        }
        else {
            noActivityView.isHidden = true
        }
        return arrayofPublishedMedia.count
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
        cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath as IndexPath)
        var imgCount = 0
        let lPublishMedia = arrayofPublishedMedia[indexPath.row]
        
        let publishedImage = cell.viewWithTag(1) as! UIImageView
        let imgView1 = cell.viewWithTag(2) as! UIImageView
        let imgView2 = cell.viewWithTag(3) as! UIImageView
        let imgView3 = cell.viewWithTag(4) as! UIImageView
        let view1 = cell.viewWithTag(10) as! UIView
        let view2 = cell.viewWithTag(11) as! UIView
        let playImageView = cell.viewWithTag(8) as! UIImageView
        let postedText = cell.viewWithTag(9) as! UILabel
        
        
        
       // view1.layer.cornerRadius = 10.0
        //view2.layer.cornerRadius = 10.0
        //publishedImage.layer.cornerRadius = 10.0
        
        let postImageUrl = URL(string: lPublishMedia.mediaPath)
        
        publishedImage.kf.setImage(with: postImageUrl)
        
        if lPublishMedia.mediaType == "video" {
            playImageView.isHidden = false
        }
        else {
            playImageView.isHidden = true
        }
        
        if lPublishMedia.mediaType == "text" {
            publishedImage.isHidden = true
            postedText.text = lPublishMedia.postText
            postedText.isHidden = false
        }
        else {
            publishedImage.isHidden = false
            postedText.isHidden = true
        }
        
        ////////////////////////////twitter////////////////////////////
        
        if lPublishMedia.twitter == "yes" {
            //imgView1.isHidden = false
            imgCount = 1
            imgView1.image = UIImage(named: "twitterActivity.png")
        }

        
        ////////////////////////////instagram////////////////////////////
        if lPublishMedia.instagram == "yes" {
           // imgView2.isHidden = false
            if imgCount == 0 {
                imgView1.image = UIImage(named: "instagramActivity.png")
            }
            else {
                imgView2.image = UIImage(named: "instagramActivity.png")
            }
            imgCount = imgCount+1
        }
//        else {
//            if imgCount == 1 {
//                imgView1.image = UIImage(named: "twitter.png")
//            }
//            else {
//                imgView1.image = UIImage(named: "")
//            }
//        }
        
        ////////////////////////////pinterest////////////////////////////
        if lPublishMedia.pinterest == "yes" {
            if imgCount == 0 {
                imgView1.image = UIImage(named: "pinterestActivity.png")
            }
            else if imgCount == 1 {
                imgView2.image = UIImage(named: "pinterestActivity.png")
            }
            else {
                imgView3.image = UIImage(named: "pinterestActivity.png")
            }
            imgCount = imgCount+1
           // imgView3.isHidden = false
        }
        
        if imgCount == 1 {
            imgView1.isHidden = false
            imgView2.isHidden = true
            imgView3.isHidden = true
        }
        else if imgCount == 2 {
            imgView1.isHidden = false
            imgView2.isHidden = false
            imgView3.isHidden = true
        }
        else if imgCount == 3 {
            imgView1.isHidden = false
            imgView2.isHidden = false
            imgView3.isHidden = false
        }
        else if imgCount == 0 {
            imgView1.isHidden = true
            imgView2.isHidden = true
            imgView3.isHidden = true
        }
        
        if lPublishMedia.mediaType == "video" {
            imgView2.isHidden = true
            imgView3.isHidden = true
            imgView1.isHidden = false
            imgView1.image = UIImage(named: "instagramActivity.png")
        }
        else {
            
        }

        
        return cell
    }
}
