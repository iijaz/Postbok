//
//  AllSocialNetworkViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/15/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class AllSocialNetworkViewController: UIViewController, GetAllSocialNetworksDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipBtn: UIButton!
    
    
    var allSocialNetworks = [SocialNetworks]()
    var searchedArray = [SocialNetworks]()
    var selectedNetworks = [SocialNetworks]()
    var isSearching: Bool = false
     var numSelected: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        skipBtn.layer.cornerRadius = 30.0
        cardView.roundViewAndSetShadow()
        collectionView.allowsMultipleSelection = true
        searchTextView.delegate = self
        NetworksDBHandler.Instance.getAllSocialNetworksDelegate = self
        NetworksDBHandler.Instance.getSocialNetworks()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

//        let collectionViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(collectionViewTapped(tapGestureRecognizer:)))
//        collectionView.isUserInteractionEnabled = true
//        collectionView.addGestureRecognizer(collectionViewTapGestureRecognizer)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_ notification: NSNotification){
        var screenHeight: CGFloat = UIScreen.main.bounds.size.height
        screenHeight = screenHeight-checkBtn.frame.size.height-20
        bottomConstraint.constant = screenHeight
        
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        bottomConstraint.constant = 30
    }
    
    func getAllNetworks(networkDic:NSDictionary) {
        
//        for item in networkDic as NSDictionary {
//            let network = item.value as! NSDictionary
//            let lNetwork = SocialNetworks(networkDict: network)
//            allSocialNetworks.append(lNetwork)
//        }
        
        let lNetwork = SocialNetworks(networkDict: networkDic)
        allSocialNetworks.append(lNetwork)
        collectionView.reloadData()
    }
    
    @IBAction func UpdateNetworks(_ sender: UIButton) {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID)
        for item in allSocialNetworks {
            if item.isSelected {
                selectedNetworks.append(item)
            }
        }
        
        UserDBHandler.Instance.setUserNetworks(sNetwork: selectedNetworks, userId: accountId! as! String)
        self.performSegue(withIdentifier: "goToHomeScreen", sender: nil)
    }
    
    
    func collectionViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        searchTextView.resignFirstResponder()
    }
    
    @IBAction func EditingChanged(_ sender: UITextField) {
        
        if searchTextView.text?.characters.count == 0 {
            isSearching = false
        }
        else {
            isSearching = true
        }
        
        searchedArray = allSocialNetworks.filter() {$0.networkTitle.lowercased().contains((searchTextView.text?.lowercased())!)}
        collectionView.reloadData()
        //print(filterarray)
            
    }
    
    
    @IBAction func GoBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func GoForward(_ sender: UIButton) {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID)
        if allSocialNetworks.count < 3 {
            self.view.makeToast("You must select 3 or more Networks", duration: 0.5, position: .top)
            return
        }
        for item in allSocialNetworks {
            if item.isSelected {
                selectedNetworks.append(item)
            }
        }
        
        UserDBHandler.Instance.setUserNetworks(sNetwork: selectedNetworks, userId: accountId! as! String)
        self.performSegue(withIdentifier: "goToHomeScreen", sender: nil)
        
    }
    
    @IBAction func SkipAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToHomeScreen", sender: nil)
    }
    

}

extension AllSocialNetworkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextView.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension AllSocialNetworkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isSearching {
            return searchedArray.count
        }
        return allSocialNetworks.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        let lNetwork: SocialNetworks!
        if isSearching {
            lNetwork = searchedArray[indexPath.item]
        }
        else {
            lNetwork = allSocialNetworks[indexPath.item]
        }
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "socialItem", for: indexPath as IndexPath)
        
        let imgView = cell.viewWithTag(1) as! UIImageView
        let networkName = cell.viewWithTag(2) as! UILabel
        let networkAdded  = cell.viewWithTag(5) as! UIButton
        
//        let imgUrl = URL(string: imgString)
//        imgView.kf.setImage(with: imgUrl)
        networkAdded.isHidden = true
        
        let imgs = lNetwork.networkTitle.lowercased()+".png"

       // let newString = imgs.replacingOccurrences(of: " ", with: "_")
        imgView.image = UIImage(named: imgs)
        
        networkName.text = lNetwork.networkTitle
        let imageView = cell.viewWithTag(3) as! UIImageView
        if lNetwork.isSelected {
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
        let lNetwork: SocialNetworks!
        if isSearching {
            lNetwork = searchedArray[indexPath.item]
        }
        else {
            lNetwork = allSocialNetworks[indexPath.item]
        }
        
        if lNetwork.isSelected {
            lNetwork.isSelected = false
            numSelected = numSelected-1
        }
        else {
            lNetwork.isSelected = true
            numSelected = numSelected+1
        }

        if numSelected > 0 {
            checkBtn.isHidden = false
        }
        else {
            checkBtn.isHidden = true
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.isSelected = false
        let lNetwork = allSocialNetworks[indexPath.item]
        lNetwork.isSelected = false
        //collectionView.reloadItems(at: [indexPath])
        
        if numSelected < 1 {
            checkBtn.isHidden = true
        }
    }
    
}

