//
//  ShareCardViewController.swift
//  SMC
//
//  Created by JuicePhactree on 12/20/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class ShareCardViewController: UIViewController, GetSelectedSocialNetworksDelegate, GetSingleUserDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profession: UILabel!
    
    @IBOutlet weak var closeDialogBtn: UIButton!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var sUsername: UITextField!
    @IBOutlet weak var sInfo: UITextField!
    @IBOutlet weak var publicBtn: UIButton!
    @IBOutlet weak var socialImageView: UIImageView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var dialogBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var dialogTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardBackgroundImageView: UIImageView!
    @IBOutlet weak var actionViewbottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var blackView: UIView!
    var networksArray = [SocialNetworks]()
     var selectedNetwork: SocialNetworks?
    var singleUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionViewbottomSpace.constant = -100
        blackView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let dict = UserDefaults.standard.value(forKey: USER_DICT) {
            setUserValues()
        }
        
        if let networkDict = UserDefaults.standard.value(forKey: USER_SELECTED_NETWORKS) {
            networksArray.removeAll()
            for item in networkDict as! NSDictionary {
                let network = item.value as! NSDictionary
                let lNetwork = SocialNetworks(networkDict: network)
                networksArray.append(lNetwork)
            }
            collectionView.reloadData()
        }
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        UserDBHandler.Instance.getSelectedSocialNetworkDelegate = self
        UserDBHandler.Instance.getSelectedSocialNetworks(accountId: accountId!)
        UserDefaults.standard.setValue("0", forKey: "constraintValue")
        
        loadingImageView.image = UIImage.gif(name: "loadinganimation")
        UserDBHandler.Instance.getSingleUserDelegate = self
       // let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        UserDBHandler.Instance.getSingleUser(userId: accountId!)
        UserDefaults.standard.setValue("HomeScreen", forKey: INITIAL_CONTROLLER)
       // setUserValues()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recieveNotificationForground(_notification:)), name: NSNotification.Name(rawValue: "NotificationDot"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(_ notification: NSNotification){
        dialogBottomSpace.constant = 300
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        dialogBottomSpace.constant = 20
    }
    
    func recieveNotificationForground(_notification: NSNotification) {
        let userdict = UserDefaults.standard.value(forKey: USER_DICT)
        let lUser = User(userdict: userdict as! NSDictionary)
        
        if lUser.activities == "1" || lUser.replies == "1" {
            self.tabBarController?.tabBar.items![4].image = UIImage(named: "home_with_notification.png")
            self.tabBarController?.tabBar.items?[4].image = self.tabBarController?.tabBar.items?[4].image?.withRenderingMode(.alwaysOriginal)
            
            self.tabBarController?.tabBar.items![4].selectedImage = UIImage(named: "coloured_home_with_notification.png")
            self.tabBarController?.tabBar.items?[4].selectedImage = self.tabBarController?.tabBar.items?[4].selectedImage?.withRenderingMode(.alwaysOriginal)
        }
        
        if lUser.notification == "1" {
            self.tabBarController?.tabBar.items![3].selectedImage = UIImage(named: "coloured_messeages_with_notification.png")
            self.tabBarController?.tabBar.items?[3].selectedImage = self.tabBarController?.tabBar.items?[3].selectedImage?.withRenderingMode(.alwaysOriginal)
            
            self.tabBarController?.tabBar.items![3].image = UIImage(named: "messeages_with_notification.png")
            self.tabBarController?.tabBar.items?[3].image = self.tabBarController?.tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
        }
        
        //        self.tabBarController?.tabBar.items![3].image = UIImage(named: "messeges_icon__gr 2.png")
        //        self.tabBarController?.tabBar.items?[3].image = self.tabBarController?.tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewDidLayoutSubviews() {
        userImageView.roundImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let imageName = UserDefaults.standard.value(forKey: WALLPAPER_NAME) {
            cardBackgroundImageView.image = UIImage(named: imageName as! String)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5,
                       delay: TimeInterval(0),
                       options: UIViewAnimationOptions.transitionCurlDown,
                       animations: {
                        self.actionViewbottomSpace.constant = -100
                        
                        self.view.layoutIfNeeded()
        },
                       completion: { (true) in
                        self.blackView.isHidden = true
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getSingleUser(userDict:NSDictionary) {
        UserDefaults.standard.setValue(userDict, forKey: USER_DICT)
        setUserValues()
    }
    
    func getSelectedNetworks(networkDict:NSDictionary) {
        networksArray.removeAll()
        for item in networkDict as NSDictionary {
            let network = item.value as! NSDictionary
            let lNetwork = SocialNetworks(networkDict: network)
            networksArray.append(lNetwork)
        }
        UserDefaults.standard.setValue(networkDict, forKey: USER_SELECTED_NETWORKS)
        collectionView.reloadData()
    }
    
    func setUserValues() {
        let dict = UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary
        let lUser = User(userdict: dict)
        fullName.text = lUser.username
        userBio.text = lUser.bio
        profession.text = lUser.profession
        let profileUrl = URL(string: lUser.profile)
        userImageView.kf.setImage(with: profileUrl)
       // userImageView.roundImageView()
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.layer.borderWidth = 3.0
       // userImageView.clipsToBounds = true
//        fullName.text = "Michal Jackson"
//        profession.text = "Dancer"
        
    }
    
    func showDialog(lNetwork: SocialNetworks) {
        dialogView.isHidden = false
        
        if lNetwork.networkStatus == "0" {
            publicBtn.titleLabel?.text = "PRIVATE"
            publicBtn.setTitle("PRIVATE", for: UIControlState.normal)
        }
        else {
            publicBtn.titleLabel?.text = "PUBLIC"
            publicBtn.setTitle("PUBLIC", for: UIControlState.normal)
        }
        
        
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
       // dialogTopSpaceConstraint.constant = screenHeight-400-65
        selectedNetwork = lNetwork
        //sUsername.becomeFirstResponder()
        sUsername.text = lNetwork.networkProfileLink
        sInfo.text = lNetwork.additionalInfo1
        sUsername.placeholder = lNetwork.networkTitle+" username/ID"
        
//        sUsername.attributedPlaceholder = NSAttributedString(string:sUsername.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.init(red: 237/255.0, green: 203/255.0, blue: 89/255.0, alpha: 0.5)])
//        sInfo.attributedPlaceholder = NSAttributedString(string:"Your Info", attributes: [NSForegroundColorAttributeName: UIColor.init(red: 237/255.0, green: 203/255.0, blue: 89/255.0, alpha: 0.5)])
        
        
        self.dialogView.isHidden = false
        sLabel.text = lNetwork.networkTitle
        let urlString = lNetwork.networkTitle.lowercased()+".png"
        socialImageView.image = UIImage(named: urlString)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle(rawValue: 1)!)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // self.view.addSubview(blurEffectView)
        self.view.bringSubview(toFront: dialogView)
    }
    
    @IBAction func GoToNext(_ sender: UIButton) {
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = "flip"
//        transition.subtype = kCATransitionFromLeft
//        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
    
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    
    @IBAction func EditingChanged(_ sender: UITextField) {
        closeDialogBtn.tag = 2
        closeDialogBtn.setBackgroundImage(UIImage(named: "checkmarkdone.png"), for: UIControlState.normal)
    }
    
    
    
    @IBAction func ShareNetwork(_ sender: UIButton) {
     //   self.sharescreenshot()
    }
    
    @IBAction func ShareCard(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5,
                       delay: TimeInterval(0),
                       options: UIViewAnimationOptions.transitionCurlDown,
                       animations: {
                        self.actionViewbottomSpace.constant = -100
                        
                        self.view.layoutIfNeeded()
        },
                       completion: { (true) in
                        self.blackView.isHidden = true
                        self.sharescreenshotandtext()
        })
        
    }
    
    @IBAction func ChangeBackground(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToThemes", sender: self)
        
        
    }
    
    
    
    @IBAction func CloseDialogAction(_ sender: UIButton) {
        
        self.dialogView.isHidden = true
        self.dismissKeyboard()
        closeDialogBtn.setBackgroundImage(UIImage(named: "exit_icon.png"), for: UIControlState.normal)
        
        if closeDialogBtn.tag == 1 {
            return
        }
        closeDialogBtn.tag = 1
        selectedNetwork?.additionalInfo1 = sInfo.text
        selectedNetwork?.networkProfileLink = sUsername.text!
        
        UserDBHandler.Instance.updateSocialInfo(network: selectedNetwork!)
        self.dialogView.isHidden = true
        self.dismissKeyboard()
        
    }
    
    @IBAction func PublicPrivateAction(_ sender: UIButton) {
        
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        if publicBtn.titleLabel?.text == "PRIVATE" {
            publicBtn.setTitle("PUBLIC", for: UIControlState.normal)
            DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").child((selectedNetwork?.networkTempData)!).updateChildValues(["mNetworkStatus" : 1])
            
        } else {
            publicBtn.setTitle("PRIVATE", for: UIControlState.normal)
            selectedNetwork?.networkStatus = "0"
            DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").child((selectedNetwork?.networkTempData)!).updateChildValues(["mNetworkStatus" : 0])
            
        }
        return
        
        
        
        UserDBHandler.Instance.updateSocialInfo(network: selectedNetwork!)
        self.dialogView.isHidden = true
        self.dismissKeyboard()
        
    }
    
    @IBAction func OpenActionView(_ sender: UIButton) {
        blackView.isHidden = false
        actionViewbottomSpace.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: TimeInterval(0),
                       options: UIViewAnimationOptions.transitionCurlDown,
                       animations: {
                        self.actionViewbottomSpace.constant = 0
                        
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    @IBAction func CloseActionView(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5,
                       delay: TimeInterval(0),
                       options: UIViewAnimationOptions.transitionCurlDown,
                       animations: {
                        self.actionViewbottomSpace.constant = -100
                        
                        self.view.layoutIfNeeded()
        },
                       completion: { (true) in
                        self.blackView.isHidden = true
        })
        
    }
    
    
    func dismissKeyboard() {
        sUsername.resignFirstResponder()
        sInfo.resignFirstResponder()
    }
    
    func showHideLoadingAnimation(totalItems: Int) {
        if totalItems > 0 {
            loadingImageView.isHidden = true
            collectionView.isHidden = false
        }
        else {
            loadingImageView.isHidden = false
            collectionView.isHidden = true
        }
    }
    
    func sharescreenshotandtext() {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let someText = "smc://"+accountId!
        self.shareaa(shareText: someText, shareImage: img)
        return
        
        let sharedObjects:[AnyObject] = [someText as AnyObject, img!]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: [])
       // activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    func sharescreenshot() {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func shareaa(shareText:String?,shareImage:UIImage?){
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj as AnyObject)
        }
        
        if shareText != nil || shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }

}

extension ShareCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sUsername.resignFirstResponder()
        sInfo.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension ShareCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.showHideLoadingAnimation(totalItems: networksArray.count)
        return networksArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        let lNetwork = networksArray[indexPath.item]
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "socialItem", for: indexPath as IndexPath)
        
        let imgView = cell.viewWithTag(1) as! UIImageView

        let imgs = lNetwork.networkTitle.lowercased()+".png"
        imgView.image = UIImage(named: imgs)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width-140
        
        let cellWidth = screenWidth/numberOfCell
        return CGSize(width: cellWidth, height: 87)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(UIDevice.current.model)
        if UIScreen.main.bounds.size.height > 568 {
            return 10
        }
        return 1.0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lNetwork = networksArray[indexPath.item]
        showDialog(lNetwork: lNetwork)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}
