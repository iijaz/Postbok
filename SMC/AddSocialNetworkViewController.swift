//
//  AddSocialNetworkViewController.swift
//  SMC
////
//  Created by JuicePhactree on 11/22/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class AddSocialNetworkViewController: UIViewController, GetAllSocialNetworksDelegate, GetSelectedSocialNetworksDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var networksArray = [SocialNetworks]()
    var selectedNetworks = [SocialNetworks]()
    var addedNetworks = [SocialNetworks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.roundViewAndSetShadow()
        collectionView.allowsMultipleSelection = true
        NetworksDBHandler.Instance.getAllSocialNetworksDelegate = self
        NetworksDBHandler.Instance.getSocialNetworks()
        
        UserDBHandler.Instance.getSelectedSocialNetworkDelegate = self
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        UserDBHandler.Instance.getSelectedSocialNetworks(accountId: accountId!)
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getAllNetworks(networkDic:NSDictionary) {
        
        for item in networkDic as NSDictionary {
            let network = item.value as! NSDictionary
            let lNetwork = SocialNetworks(networkDict: network)
            lNetwork.networkTempData = item.key as! String
            networksArray.append(lNetwork)
        }
        collectionView.reloadData()
    }
    
    func getSelectedNetworks(networkDict:NSDictionary) {
        for item in networkDict as NSDictionary {
            let network = item.value as! NSDictionary
            let lNetwork = SocialNetworks(networkDict: network)
            addedNetworks.append(lNetwork)
        }
        collectionView.reloadData()
    }

    
    @IBAction func LoadAll(_ sender: UIButton) {
        
        if networksArray.count < 30 {
            return
        }
        self.performSegue(withIdentifier: "goToAllNetworks", sender: self)
    }

    @IBAction func UpdateNetworks(_ sender: UIButton) {
        
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID)
        for item in networksArray {
            if item.isSelected {
                selectedNetworks.append(item)
            }
        }
        if selectedNetworks.count > 0 {
            let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
           // let str1 = "You Added your network"
           // let str2 = uniqueName+" added his network"
           // UserDBHandler.Instance.setUserActivities(activityString: str1, questionId: "", answerId: "", otherString: str2, userId: accountId! as! String)
            UserDBHandler.Instance.setUserNetworks(sNetwork: selectedNetworks, userId: accountId! as! String)
        }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func GoBack(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func DeleteNetwork(_ sender: UIButton) {
        
        //let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let collectionViewCell = sender.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: collectionViewCell)
        let lNetwork = networksArray[(indexPath?.item)!]
        let sArray = addedNetworks.filter() {$0.networkTitle.lowercased().contains((lNetwork.networkTitle.lowercased()))}
        let sNetwork = sArray[0]
        UserDBHandler.Instance.deleteUserNetwork(lNetworkId: sNetwork.networkTempData)
        networksArray.remove(at: (indexPath?.item)!)
        //let str1 = "You deleted your network"
        //let str2 = uniqueName+" deleted his network"
       // UserDBHandler.Instance.setUserActivities(activityString: str1, questionId: "", answerId: "", otherString: str2, userId: accountId)
        
        collectionView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAllNetworks" {
            let nextScene = segue.destination as! AddAllSocialNetworkViewController
            nextScene.allSocialNetworks = networksArray
            nextScene.addedNetworks = addedNetworks
        }
    }
    

}

extension AddSocialNetworkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if networksArray.count > 30 {
            return 30
            
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
        let networkAdded  = cell.viewWithTag(5) as! UIButton
        
        let imgUrl = URL(string: imgString)
        let imgs = lNetwork.networkTitle.lowercased()+".png"
        imgView.image = UIImage(named: imgs)
        //imgView.kf.setImage(with: imgUrl)
        
         let searchedArray = addedNetworks.filter() {$0.networkTitle.lowercased().contains((lNetwork.networkTitle.lowercased()))}
        if searchedArray.count > 0 {
            networkAdded.isHidden = false
        }
        else {
            networkAdded.isHidden = true
        }
        
        networkName.text = lNetwork.networkTitle
        
        let imageView = cell.viewWithTag(3) as! UIImageView
        if cell.isSelected {
            imageView.isHidden = false
        }
        else {
            imageView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width-104
        
        let cellWidth = screenWidth/numberOfCell
        return CGSize(width: cellWidth, height: cellWidth+20)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        let btn = cell.viewWithTag(5) as! UIButton
        if !btn.isHidden {
            return
        }
        cell.isSelected = true
        let imageView = cell.viewWithTag(3) as! UIImageView
        imageView.isHidden = false
        let lNetwork = networksArray[indexPath.item]
        if cell.isSelected {
            imageView.isHidden = false
            lNetwork.isSelected = true
        }
        else {
            imageView.isHidden = true
            lNetwork.isSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.isSelected = false
        let imageView = cell.viewWithTag(3) as! UIImageView
        imageView.isHidden = true
        let lNetwork = networksArray[indexPath.item]
        if cell.isSelected {
            imageView.isHidden = false
            lNetwork.isSelected = true
        }
        else {
            imageView.isHidden = true
            lNetwork.isSelected = false
        }
    }
    
}
