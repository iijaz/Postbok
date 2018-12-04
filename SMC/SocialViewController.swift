//
//  SocialViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/18/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

protocol ShowDialogDelegate:class {
    func showDialog()
}



class SocialViewController: UIViewController, GetSelectedSocialNetworksDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noNetworkImageView: UIImageView!
    weak var showDialogDelegate: ShowDialogDelegate?
    
    var networksArray = [SocialNetworks]()
    var isViewdidloadCalled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isViewdidloadCalled = true
        
        
        
        if let networkDict = UserDefaults.standard.value(forKey: USER_SELECTED_NETWORKS) {
            networksArray.removeAll()
            for item in networkDict as! NSDictionary {
                let network = item.value as! NSDictionary
                let lNetwork = SocialNetworks(networkDict: network)
                networksArray.append(lNetwork)
            }
            collectionView.reloadData()
        }
        
        
        
//        UserDBHandler.Instance.getSelectedSocialNetworkDelegate = self
//        UserDBHandler.Instance.getSelectedSocialNetworks()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
       // self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
      //  view.addGestureRecognizer(swipeLeft)
        
        if isViewdidloadCalled {
            isViewdidloadCalled = false
            bottomSpaceConstraint.constant = 110.0
        }
        else {
            bottomSpaceConstraint.constant = 60.0
        }
        let str = UserDefaults.standard.value(forKey: "constraintValue") as! String
        let screenHight: CGFloat = UIScreen.main.bounds.size.height
        if str == "1" {
            if screenHight > 667 {
                bottomSpaceConstraint.constant = 95.0
                topSpaceConstraint.constant = 65.0
            }
            else {
                topSpaceConstraint.constant = 60.0
               bottomSpaceConstraint.constant = 75.0
            }
            
        }
        else {
            if screenHight > 667 {
                bottomSpaceConstraint.constant = 160.0
                topSpaceConstraint.constant = 47.0
            }
            else {
                topSpaceConstraint.constant = 50.0
               bottomSpaceConstraint.constant = 130.0
            }
            
        }
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        UserDBHandler.Instance.getSelectedSocialNetworkDelegate = self
        UserDBHandler.Instance.getSelectedSocialNetworks(accountId: accountId!)
    }
    
    override func viewDidLayoutSubviews() {
        let str = UserDefaults.standard.value(forKey: "constraintValue") as! String
        let screenHight: CGFloat = UIScreen.main.bounds.size.height
        if str == "1" {
            if screenHight > 667 {
                if screenHight == 736 {
                    bottomSpaceConstraint.constant = 95.0
                    topSpaceConstraint.constant = 45.0
                }
                else {
                    bottomSpaceConstraint.constant = 95.0
                    topSpaceConstraint.constant = 65.0
                }
                
            }
            else {
                topSpaceConstraint.constant = 56.0
                bottomSpaceConstraint.constant = 84.0
            }
            
        }
        else {
            if screenHight > 667 {
                if screenHight == 736 {//iphone 6 plus
                    bottomSpaceConstraint.constant = 140.0
                    topSpaceConstraint.constant = 30.0
                }
                else {//iphone x
                    bottomSpaceConstraint.constant = 160.0
                    topSpaceConstraint.constant = 47.0
                }
                
            }
            else {//iphone 6
                topSpaceConstraint.constant = 50.0
                bottomSpaceConstraint.constant = 130.0
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func getSelectedNetworks(networkDict:NSDictionary) {
        networksArray.removeAll()
        if networkDict.allKeys[0] as! String == "value" {
            UserDefaults.standard.setValue(nil, forKey: USER_SELECTED_NETWORKS)
            collectionView.reloadData()
            return
        }
        for item in networkDict as NSDictionary {
            let network = item.value as! NSDictionary
            let lNetwork = SocialNetworks(networkDict: network)
            networksArray.append(lNetwork)
        }
        UserDefaults.standard.setValue(networkDict, forKey: USER_SELECTED_NETWORKS)
       // networksArray.reverse()
        collectionView.reloadData()
    }

}

extension SocialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if networksArray.count == 0 {
            noNetworkImageView.isHidden = false
        }
        else {
            noNetworkImageView.isHidden = true
        }
        
        return networksArray.count+1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath as IndexPath)
            return cell
        }
        let lNetwork = networksArray[indexPath.item-1]
        let imgString = lNetwork.networkPath
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "socialItem", for: indexPath as IndexPath)
        
        let imgView = cell.viewWithTag(1) as! UIImageView
        let networkName = cell.viewWithTag(2) as! UILabel
        
       // let imgUrl = URL(string: imgString)
        //imgView.kf.setImage(with: imgUrl)
        let imgs = lNetwork.networkTitle.lowercased()
        imgView.image = UIImage(named: imgs)
        
        networkName.text = lNetwork.networkTitle
        
        let imageView = cell.viewWithTag(3) as! SwiftySwitch
        imageView.delegate = self
        if lNetwork.networkStatus == "0" {
            imageView.isOn = false
            imageView.myColor = UIColor.black
        }
        else {
            imageView.isOn = true
            imageView.myColor = UIColor.green
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width-80
        
        let cellWidth = screenWidth/numberOfCell
        return CGSize(width: cellWidth, height: 87)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            self.performSegue(withIdentifier: "goToSocial", sender: self)
            return
        }
        let lNetwork = networksArray[indexPath.item-1]
        let vc = self.parent?.parent as! MyProfileViewController
        vc.showDialog(lNetwork: lNetwork)
        
        
        //vc.showDialog()

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
    
}

extension SocialViewController: SwiftySwitchDelegate {
    
    func valueChanged(sender: SwiftySwitch) {
         let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        let collectionViewCell = sender.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: collectionViewCell)
        let lnetwork = networksArray[(indexPath?.item)!]
        
        if sender.isOn {
            lnetwork.networkStatus = "1"
            sender.myColor = UIColor.green
            DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").child(lnetwork.networkTempData).updateChildValues(["mNetworkStatus" : 1])
            
        } else {
            sender.myColor = UIColor.black
            lnetwork.networkStatus = "0"
            DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").child(lnetwork.networkTempData).updateChildValues(["mNetworkStatus" : 0])
            
        }
    }
}
