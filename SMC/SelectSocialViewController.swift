//
//  SelectSocialViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/15/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class SelectSocialViewController: UIViewController, GetAllSocialNetworksDelegate {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var networksArray = [SocialNetworks]()
    var selectedNetworks = [SocialNetworks]()

    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.roundViewAndSetShadow()
        collectionView.allowsMultipleSelection = true
        NetworksDBHandler.Instance.getAllSocialNetworksDelegate = self
        NetworksDBHandler.Instance.getSocialNetworks()
        UserDefaults.standard.setValue("SelectSocialScreen", forKey: INITIAL_CONTROLLER)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllNetworks(networkDic:NSDictionary) {
        
        for item in networkDic as NSDictionary {
            let network = item.value as! NSDictionary
            let lNetwork = SocialNetworks(networkDict: network)
            networksArray.append(lNetwork)
        }
        collectionView.reloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func LoadAllAction(_ sender: UIButton) {
        if networksArray.count < 30 {
            return
        }
        self.performSegue(withIdentifier: "goToAllSocial", sender: self)
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        print("back pressed")
    }
    
    @IBAction func GoForword(_ sender: UIButton) {
        print("forword pressed")
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID)
        for item in networksArray {
            if item.isSelected {
                selectedNetworks.append(item)
            }
        }
        
        UserDBHandler.Instance.setUserNetworks(sNetwork: selectedNetworks, userId: accountId! as! String)
        self.performSegue(withIdentifier: "goToHomeScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAllSocial" {
            let nextScene = segue.destination as! AllSocialNetworkViewController
            nextScene.allSocialNetworks = networksArray
        }
    }
    

}

extension SelectSocialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

        let imgUrl = URL(string: imgString)
        imgView.kf.setImage(with: imgUrl)

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


