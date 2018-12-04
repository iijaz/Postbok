//
//  VisitorSocialViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/27/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class VisitorSocialViewController: UIViewController, GetSelectedSocialNetworksDelegate {

    var networksArray = [SocialNetworks]()
    var happeningArray = [NSDictionary]()
    var selectedUser: User?
    var tTimer: Timer?
    var isViewdidloadCalled: Bool = false
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noNetworkView: UIView!

    @IBOutlet weak var loadingAnimationImageView: UIImageView!
    @IBOutlet weak var noNetworkLabel: UILabel!
    @IBOutlet weak var noNetworkImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        isViewdidloadCalled = true
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tTimer?.invalidate()
        UserDBHandler.Instance.getSelectedSocialNetworkDelegate = self
        UserDBHandler.Instance.getSelectedSocialNetworks(accountId: (selectedUser?.id)!)
        let screenHight: CGFloat = UIScreen.main.bounds.size.height
        let str = UserDefaults.standard.value(forKey: "userConstraintValue") as! String
        if str == "0" {
            isViewdidloadCalled = false
            if screenHight == 736 {
                bottomSpaceConstraint.constant = 100.0
                topConstraint.constant = 20
            }
            else {
                bottomSpaceConstraint.constant = 135.0
            }
            
        }
        else {
            bottomSpaceConstraint.constant = 75.0
        }
        
        DBProvider.Instance.userRef.child((selectedUser?.id)!).child("Happening").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                for item in dict {
                    self.happeningArray.append(item.value as! NSDictionary)
                    self.collectionView.reloadData()
                    print("hello")
                }
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSelectedNetworks(networkDict:NSDictionary) {
        networksArray.removeAll()
        
//        if selectedUser?.accountType.lowercased() == "private" {
//
//            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
//            self.collectionView.isHidden = true
//            DBProvider.Instance.userRef.child((selectedUser?.id)!).child(USER_USERFOLLOWERS_NODE).child(accountId!).observeSingleEvent(of: .value, with: { (snapshot) in
//                if let likedVal = snapshot.value as? String {
//                    print(likedVal)
//                    self.collectionView.isHidden = false
//                   // self.isBeingFollowedDelegate?.isBeingFollowed(followed: true)
//                }
//                else {
//                    //self.isBeingFollowedDelegate?.isBeingFollowed(followed: false)
//                    self.loadingAnimationImageView.isHidden = true
//                    self.noNetworkLabel.isHidden = false
//                    self.noNetworkLabel.alpha = 1.0
//                    self.noNetworkImageView.isHidden = false
//                    self.noNetworkImageView.image = UIImage(named: "lockImage.png")
//
//                    self.networksArray.removeAll()
//                    self.collectionView.reloadData()
//                    return
//                }
//            })
//
//
//        }
        
        for item in networkDict as NSDictionary {
//            if networkDict.count == 1 {
//                break
//            }
            if networkDict.allKeys[0] as! String == "value" {
                break
            }
            let network = item.value as! NSDictionary
            let lNetwork = SocialNetworks(networkDict: network)
            if lNetwork.networkStatus == "1" {
                networksArray.append(lNetwork)
            }
            
        }
        if networksArray.count > 0 {
            self.loadingAnimationImageView.isHidden = true
            self.noNetworkLabel.isHidden = true
            self.noNetworkImageView.isHidden = true
        }
        else {
            self.loadingAnimationImageView.isHidden = true
            self.noNetworkLabel.isHidden = false
            self.noNetworkImageView.isHidden = false
        }
        
        collectionView.reloadData()
    }
    
    func onTimerEvent(timer: Timer) {
       // self.imageView.isHidden = !self.imageView.isHidden
        let imgView = timer.userInfo as! UIImageView
        //imgView.isHidden = !imgView.isHidden
        if imgView.alpha == 0 {
            imgView.alpha = 1
        }
        else {
            imgView.alpha = 0
        }
    }

}

extension VisitorSocialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if networksArray.count > 0 {
            collectionView.isHidden = false
            noNetworkView.isHidden = true
            loadingAnimationImageView.image = UIImage.gif(name: "loadinganimation")
        }
        else {
            collectionView.isHidden = true
            noNetworkView.isHidden = false
            loadingAnimationImageView.image = UIImage.gif(name: "loadinganimation")
        }
        return networksArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        let lNetwork = networksArray[indexPath.item]
        let imgString = lNetwork.networkPath
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "socialItem", for: indexPath as IndexPath)
        let imgView = cell.viewWithTag(1) as! UIImageView
        
        let networkName = cell.viewWithTag(2) as! UILabel
        let redCirculeImageview = cell.viewWithTag(3) as! UIImageView
        
       // let imgUrl = URL(string: imgString)
        let imgs = lNetwork.networkTitle.lowercased()+".png"
        imgView.image = UIImage(named: imgs)
       // imgView.kf.setImage(with: imgUrl)
        
        networkName.text = lNetwork.networkTitle
        
        let sArray = happeningArray.filter() {($0["Id"] as! String).contains((lNetwork.networkTempData))}
        if sArray.count > 0 {
            let tTime = sArray[0]["time"] as! Int
            let sTime =  Date().millisecondsSince1970 - 86400000
//            redCirculeImageview.animationImages = [img1!, img2!]
//            redCirculeImageview.animationDuration = 3.0
            
            
            if sTime < tTime {
                redCirculeImageview.isHidden = false
               //tTimer =  Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(onTimerEvent(timer:)), userInfo: redCirculeImageview, repeats: true)
            }
            else {
                redCirculeImageview.isHidden = true
            }
            
        }
        else {
            redCirculeImageview.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width-150
        
        let cellWidth = screenWidth/numberOfCell
        return CGSize(width: cellWidth, height: 87)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let celll = collectionView.cellForItem(at: indexPath)
        let redCirculeImageview = celll?.viewWithTag(3) as! UIImageView
        let lNetwork = networksArray[indexPath.item]
        let vc = self.parent?.parent as! UserProfileViewController
        vc.showDialog(lNetwork: lNetwork, isAnimation: !redCirculeImageview.isHidden)
        
//        let fbAppUrl = "fb://profile?id=ijazahmad166"
//        let fbWebUrl = "https://www.facebook.com/831831923611308"
//        
//        let instAppUrl = "instagram://user?username=ijaz0066"
//        let twitterUrl = "twitter://user?screen_name=ijazahmad166"
//        
//        UIApplication.tryURL([twitterUrl, fbWebUrl])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}

