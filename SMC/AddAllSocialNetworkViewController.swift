//
//  AddAllSocialNetworkViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/22/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class AddAllSocialNetworkViewController: UIViewController, GetAllSocialNetworksDelegate, GetSelectedSocialNetworksDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var allSocialNetworks = [SocialNetworks]()
    var searchedArray = [SocialNetworks]()
    var selectedNetworks = [SocialNetworks]()
    var addedNetworks = [SocialNetworks]()
    var isSearching: Bool = false
    var numSelected: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkBtn.layer.shadowColor = UIColor.black.cgColor
        self.checkBtn.layer.shadowOpacity = 3
        self.checkBtn.layer.shadowOffset = CGSize.zero
        
        UserDBHandler.Instance.getSelectedSocialNetworkDelegate = self
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        UserDBHandler.Instance.getSelectedSocialNetworks(accountId: accountId!)
        
        NetworksDBHandler.Instance.getAllSocialNetworksDelegate = self
        NetworksDBHandler.Instance.getSocialNetworks()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func keyboardWillShow(_ notification: NSNotification){
        var screenHeight: CGFloat = UIScreen.main.bounds.size.height
        screenHeight = screenHeight-checkBtn.frame.size.height-20
        bottomConstraint.constant = screenHeight
        
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        bottomConstraint.constant = 30
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
        
//        for item in networkDic as NSDictionary {
//            let network = item.value as! NSDictionary
//            let lNetwork = SocialNetworks(networkDict: network)
//            lNetwork.networkTempData = item.key as! String
//
//            let sArray = addedNetworks.filter() {$0.networkTitle.lowercased().contains((lNetwork.networkTitle.lowercased()))}
//            if sArray.count > 0 {
//                allSocialNetworks.insert(lNetwork, at: 0)
//                collectionView.reloadData()
//            }
//            else {
//                allSocialNetworks.append(lNetwork)
//                collectionView.reloadData()
//            }
//
//        }
        
        let lNetwork = SocialNetworks(networkDict: networkDic)
        
        if lNetwork.networkTitle == "Tinder" {
            return
        }
        
        let dArray = allSocialNetworks.filter()
            {$0.networkTitle.lowercased().elementsEqual((lNetwork.networkTitle.lowercased()))}
        if dArray.count > 0 {
            return
        }
        
        let sArray = addedNetworks.filter() {$0.networkTitle.lowercased().elementsEqual((lNetwork.networkTitle.lowercased()))}
        if sArray.count > 0 {
            allSocialNetworks.insert(lNetwork, at: 0)
            collectionView.reloadData()
        }
        else {
            allSocialNetworks.append(lNetwork)
            collectionView.reloadData()
        }
        
        collectionView.reloadData()
    }
    
    func getSelectedNetworks(networkDict:NSDictionary) {
        if networkDict.allKeys[0] as! String == "value" {
            collectionView.reloadData()
            return
        }
        for item in networkDict as NSDictionary {
            let network = item.value as! NSDictionary
            let lNetwork = SocialNetworks(networkDict: network)
            addedNetworks.append(lNetwork)
        }
        collectionView.reloadData()
    }
    
    @IBAction func EditingChanged(_ sender: UITextField) {
        
        if searchTextField.text?.characters.count == 0 {
            isSearching = false
        }
        else {
            isSearching = true
        }
        
        searchedArray = allSocialNetworks.filter() {$0.networkTitle.lowercased().contains((searchTextField.text?.lowercased())!)}
        collectionView.reloadData()
        //print(filterarray)
        
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func UpdateNetworks(_ sender: UIButton) {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID)
        for item in allSocialNetworks {
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
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func DeleteNetworkAction(_ sender: UIButton) {
        checkBtn.isHidden = false
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let collectionViewCell = sender.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: collectionViewCell)
        var lNetwork = SocialNetworks()
        if isSearching {
            lNetwork = searchedArray[(indexPath?.item)!]
            searchedArray.remove(at: (indexPath?.item)!)
        }
        else {
            lNetwork = allSocialNetworks[(indexPath?.item)!]
            allSocialNetworks.remove(at: (indexPath?.item)!)
        }
        let sArray = addedNetworks.filter() {$0.networkTitle.lowercased().elementsEqual((lNetwork.networkTitle.lowercased()))}
        let sNetwork = sArray[0]
        UserDBHandler.Instance.deleteUserNetwork(lNetworkId: sNetwork.networkTempData)
        //allSocialNetworks.remove(at: (indexPath?.item)!)
       // let str1 = "You deleted your network"
       // let str2 = uniqueName+" deleted his network"
       // UserDBHandler.Instance.setUserActivities(activityString: str1, questionId: "", answerId: "", otherString: str2, userId: accountId)
        
        collectionView.reloadData()
    }

}

extension AddAllSocialNetworkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension AddAllSocialNetworkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
     //   let imgString = lNetwork.networkPath
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "socialItem", for: indexPath as IndexPath)
        
        let imgView = cell.viewWithTag(1) as! UIImageView
        let networkName = cell.viewWithTag(2) as! UILabel
        let networkAdded  = cell.viewWithTag(5) as! UIButton
        
     //   let imgUrl = URL(string: imgString)
        let imgs = lNetwork.networkTitle.lowercased()+".png"
        imgView.image = UIImage(named: imgs)
       // imgView.kf.setImage(with: imgUrl)
        
        let sArray = addedNetworks.filter() {$0.networkTitle.lowercased().elementsEqual((lNetwork.networkTitle.lowercased()))}
        if sArray.count > 0 {
            networkAdded.isHidden = false
        }
        else {
            networkAdded.isHidden = true
        }

        
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
       // numSelected = numSelected+1
        let cell = collectionView.cellForItem(at: indexPath)!
        let btn = cell.viewWithTag(5) as! UIButton
        if !btn.isHidden {
            return
        }
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
        numSelected = numSelected-1
        let cell = collectionView.cellForItem(at: indexPath)!
        let btn = cell.viewWithTag(5) as! UIButton
        if !btn.isHidden {
            return
        }
        if searchedArray.count > 0 {
            checkBtn.isHidden = false
        }
        else {
            checkBtn.isHidden = true
        }
        cell.isSelected = false
        let lNetwork = allSocialNetworks[indexPath.item]
        lNetwork.isSelected = false
        if numSelected < 1 {
            checkBtn.isHidden = true
        }
    }
    
}
