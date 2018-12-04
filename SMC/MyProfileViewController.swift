//
//  MyProfileViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/18/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit
import PageMenu
class MyProfileViewController: UIViewController, GetSingleUserDelegate, CAPSPageMenuDelegate, GetUpdatedUserDelegate {
    
    @IBOutlet weak var shareSmcIdBtn: UIButton!
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var noOfFollowings: UILabel!
    @IBOutlet weak var noOfFollowers: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var largePictureView: UIView!
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var activeLabel: UILabel!
    
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var dialogTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var sSwitch: SwiftySwitch!
    @IBOutlet weak var socialImageView: UIImageView!
    @IBOutlet weak var noProfileImageView: UIImageView!
    @IBOutlet weak var pageViewImg1: UIImageView!
    @IBOutlet weak var pageViewImg2: UIImageView!
    
    @IBOutlet weak var happeningBtn: UIButton!
    @IBOutlet weak var publicBtn2: UIButton!
    @IBOutlet weak var displayProfileImgVierw: UIImageView!
    
    @IBOutlet weak var privateLabel2: UILabel!
    @IBOutlet weak var profilePicBackgroundPolygon: UIImageView!
    @IBOutlet weak var recSwipeView: UIImageView!
    @IBOutlet weak var profileVisibilityLabel: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var followerBtn: UIButton!
    @IBOutlet weak var descriptionProfessionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var statusBoxTopSpaceConstraint: NSLayoutConstraint!//4
    
    @IBOutlet weak var statusBoxRightSpace: NSLayoutConstraint!//1
    
    @IBOutlet weak var pendingRequestNotification: UIImageView!
    
    @IBOutlet weak var statusBoxHeight: NSLayoutConstraint!//115
    
    @IBOutlet weak var userInfoTopSpaceConstraint: NSLayoutConstraint!//25
    @IBOutlet weak var userInfoRightSpace: NSLayoutConstraint!//24
    @IBOutlet weak var userInfoHeight: NSLayoutConstraint!//53
    
    @IBOutlet weak var palceholderLeftSpace: NSLayoutConstraint!//28
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    
    
    
    @IBOutlet weak var networkBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    
    @IBOutlet weak var idBox: UIImageView!
    @IBOutlet weak var statusBox: UIImageView!
    
    @IBOutlet weak var otherBtnView: UIView!
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var closeDialogBtn: UIButton!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var sUsername: UITextField!
   // @IBOutlet weak var sInfo: UITextField!
    @IBOutlet weak var sInfo: UITextView!
    
    @IBOutlet weak var sInfoPlaceHolderLabel: UILabel!
    
    
    @IBOutlet weak var sFullName: UITextField!
    
    @IBOutlet weak var smcImageView: UIImageView!
    @IBOutlet weak var postFeedImageView: UIImageView!
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var profileActivityImageView: UIImageView!
    
    @IBOutlet weak var otherButtonViewCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareSmcConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareSmcView: UIView!
    @IBOutlet weak var shareSmcLeftViewSpace: NSLayoutConstraint!
    @IBOutlet weak var publicBtn: UIButton!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondProfileLink: UITextField!
    @IBOutlet weak var thirdProfileLink: UITextField!
    
    @IBOutlet weak var dialogViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonViewTopSpaceConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var tabImageView: UIView!
    
    @IBOutlet weak var imgLine1: UIImageView!
    @IBOutlet weak var imgLine2: UIImageView!
    @IBOutlet weak var imgLine3: UIImageView!
    @IBOutlet weak var imgLine4: UIImageView!
    
    @IBOutlet weak var activityNotificationCircule: UIImageView!
    
    @IBOutlet weak var followActivityNotificationCircule: UIImageView!
    
    @IBOutlet weak var gradiantImageView: UIImageView!
    
    
    var blurEffectView = UIVisualEffectView()

    
    var pageMenu : CAPSPageMenu?
    var type: String?
    var bView: UIView?
    var selectedNetwork: SocialNetworks?
    var selectedUser: User?
    var addBtnCount: Int = 0
    var dialogTopSpaceConstant: CGFloat = 0.0
    var isLeft: Bool = true
    var happeningBtnPressed: Bool = false
    var happeningArray = [NSDictionary]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        UserDefaults.standard.setValue("NO", forKey: "ActivityImageTapped")
//        self.tabBarController?.tabBar.isHidden = false
//        let str = UserDefaults.standard.value(forKey: "controller") as? String
//        if str == "camera" {
//            pageMenu?.moveToPage(1)
//            changeButtonColor(index: 1)
//
//            changeButtonColor(index: 1)
//            //UserDefaults.standard.setValue("a", forKey: "controller")
//        }
        
        
        shareSmcIdBtn.layer.cornerRadius = 5.0
        //sInfo.layer.borderWidth = 0.5
        //sInfo.layer.cornerRadius = 25.0
        sInfo.layer.borderColor = UIColor.darkGray.cgColor
        
        sInfo.layer.shadowColor = UIColor.black.cgColor
        //sInfo.layer.shadowOpacity = 1
        sInfo.layer.shadowOffset = CGSize.zero
       // sInfo.layer.shadowOffset = CGSize.init(width: 12.0, height: 2.0)
//        sInfo.layer.shadowRadius = 1.0
//        sInfo.layer.masksToBounds = false
        
        
        
        happeningBtn.layer.shadowColor = UIColor.gray.cgColor
        happeningBtn.layer.shadowOpacity = 3
        happeningBtn.layer.shadowOffset = CGSize.zero
        happeningBtn.layer.shadowRadius = 1
        
        //UIView(frame: CGRect(0, 0, 15, self.sInfo.frame.height))
        
//        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15, height: self.sInfo.frame.height))
//        sInfo.leftView = paddingView
//        sInfo.leftViewMode = UITextFieldViewMode.always
        
        //dialogView.layer.borderWidth = 1.0
        dialogView.layer.borderColor = UIColor.init(red: 206/255.0, green: 156.0/255.0, blue: 150/255.0, alpha: 1.0).cgColor
        dialogView.layer.cornerRadius = 10.0
        networkBtn.isSelected = true
        pageViewImg1.roundImageView()
        pageViewImg2.roundImageView()
        pageViewImg1.layer.borderColor = UIColor.black.cgColor
        pageViewImg1.backgroundColor = UIColor.white
        pageViewImg2.backgroundColor = UIColor.lightGray
        pageViewImg1.layer.borderWidth = 1.0
       // shareSmcIdBtn.layer.borderWidth = 1.0
       // shareSmcIdBtn.layer.borderColor = UIColor.white.cgColor
        gradiantImageView.layer.shadowColor = UIColor.gray.cgColor
        gradiantImageView.layer.shadowOpacity = 3
        gradiantImageView.layer.shadowOffset = CGSize.zero
        gradiantImageView.layer.shadowRadius = 3
        
        
        if let dict = UserDefaults.standard.value(forKey: USER_DICT) {
            self.setUserValues()
        }
        
        let screenHight: CGFloat = UIScreen.main.bounds.size.height
        if screenHight > 667 {
            //buttonViewTopSpaceConstraint.constant = 90
            topViewHeightConstraint.constant = 275
        }
        else {
            topViewHeightConstraint.constant = 275
            //buttonViewTopSpaceConstraint.constant = 0
        }
        
      //  followerBtn.layer.borderWidth = 1.0
       // followerBtn.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        followerBtn.layer.borderColor = UIColor.black.cgColor
       // followingBtn.layer.borderWidth = 1.0
        //followingBtn.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        followingBtn.layer.borderColor = UIColor.black.cgColor
        followingBtn.layer.cornerRadius = 3.0
        followerBtn.layer.cornerRadius = 3.0
        activityNotificationCircule.roundImageView()
        followActivityNotificationCircule.roundImageView()
        pendingRequestNotification.roundImageView()
        UserDefaults.standard.setValue("HomeScreen", forKey: INITIAL_CONTROLLER)
        //smcImageView.image = UIImage(named: "SMC1.png")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
       // profileImage.roundImageView()
        makePolyGon()
       // profileImage.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        self.addViewControlers()
        self.pageMenu?.delegate = self
        
//        let str = UserDefaults.standard.value(forKey: "controller") as? String
//        if str == "camera" {
//            pageMenu?.moveToPage(1)
//            changeButtonColor(index: 1)
//
//            changeButtonColor(index: 1)
//            //UserDefaults.standard.setValue("a", forKey: "controller")
//        }
        
        fullName.text = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as? String
        fullName.text = "@"+fullName.text!
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recieveNotificationForground(_notification:)), name: NSNotification.Name(rawValue: "NotificationDot"), object: nil)
        
        //self.dialogView.layer.borderWidth = 3.0
     //   dialogView.layer.cornerRadius = 15.0
     //   dialogView.layer.borderColor = UIColor.black.cgColor
        
        
        // Do any additional setup after loading the view.
    }
    
    func firstImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("first tapped")
        
        changeButtonColor(index: 0)
        pageMenu?.moveToPage(0)
        
    }
    
    func secondImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        changeButtonColor(index: 1)
        pageMenu?.moveToPage(1)
    }
    
    func thirdImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        changeButtonColor(index: 2)
        pageMenu?.moveToPage(2)
    }
    
    func forthImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        changeButtonColor(index: 3)
        pageMenu?.moveToPage(3)
    }
    
    @IBAction func SmcImageTapped(_ sender: UIButton) {
        changeButtonColor(index: 0)
        pageMenu?.moveToPage(0)
    }
    
    
    @IBAction func GoToPendingRequests(_ sender: UIButton) {
    }
    
    @IBAction func PostFeedImageTapped(_ sender: UIButton) {
        changeButtonColor(index: 1)
        pageMenu?.moveToPage(1)
    }
    
    @IBAction func ActivityImageTapped(_ sender: UIButton) {
        UserDefaults.standard.setValue("YES", forKey: "ActivityImageTapped")
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child("activities").setValue("0")
        changeButtonColor(index: 2)
        pageMenu?.moveToPage(2)
    }
    
    @IBAction func FollowActivityImageTapped(_ sender: UIButton) {
        changeButtonColor(index: 3)
        pageMenu?.moveToPage(3)
    }
    
    func recieveNotificationForground(_notification: NSNotification) {
        let userdict = UserDefaults.standard.value(forKey: USER_DICT)
        let lUser = User(userdict: userdict as! NSDictionary)
        if lUser.activities == "1" || lUser.replies == "1" || lUser.followRequestStatus == 1 {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationsEnabled(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // UIView.setAnimationsEnabled(false)
        super.viewWillAppear(true)
        UserDefaults.standard.setValue("NO", forKey: "ActivityImageTapped")
        
        
        //UserDBHandler.Instance.getUsers()
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        print(accountId!)
        DBProvider.Instance.userRef.child(accountId!).child("GotBlocked").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
               UserDefaults.standard.setValue(dict, forKey: GOT_BLOCKED)
            }
        })
        
        if userBio.numberOfLines == 1 {
            print("aa")
        }
        
        UserDBHandler.Instance.getSingleUserDelegate = self
        UserDBHandler.Instance.getUpdatedUserdelegate = self
        UserDBHandler.Instance.getUpdatedUserValues()
        UserDBHandler.Instance.getSingleUser(userId: accountId!)
        UserDBHandler.Instance.getUpdatedUserValues()
        self.tabBarController?.tabBar.isHidden = false
        let str = UserDefaults.standard.value(forKey: "controller") as? String
        if str == "camera" {
            pageMenu?.moveToPage(1)
            changeButtonColor(index: 1)

            changeButtonColor(index: 1)
            //UserDefaults.standard.setValue("a", forKey: "controller")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    
    func keyboardWillShow(_ notification: NSNotification){
        dialogTopSpaceConstant = dialogTopSpaceConstraint.constant
        dialogTopSpaceConstraint.constant = 20
        
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        //bottomSpaceConstraints.constant = 1
        dialogTopSpaceConstraint.constant = dialogTopSpaceConstant
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if !isLeft {
                    //otherBtnView.isHidden = true
                  //  shareSmcIdBtn.isHidden = false
                    followerBtn.isHidden = false
                    followingBtn.isHidden = false
                    noOfFollowers.isHidden = false
                    noOfFollowings.isHidden = false
                    isLeft = true
                    pageViewImg1.layer.borderColor = UIColor.black.cgColor
                    pageViewImg1.backgroundColor = UIColor.white
                    pageViewImg2.backgroundColor = UIColor.lightGray
                    pageViewImg2.layer.borderWidth = 0.0
                    pageViewImg1.layer.borderWidth = 1.0
                    
                    UIView.setAnimationsEnabled(true)
                    UIView.animate(withDuration: 0.5,
                                   delay: TimeInterval(0),
                                   options: UIViewAnimationOptions.transitionCurlDown,
                                   animations: {
                                    self.otherButtonViewCenterConstraint.constant = 400
                                    
                                    self.view.layoutIfNeeded()
                    },
                                   completion: { (true) in
                    })
                    
                    UIView.setAnimationsEnabled(true)
                    UIView.animate(withDuration: 0.5,
                                   delay: TimeInterval(0),
                                   options: UIViewAnimationOptions.transitionCurlDown,
                                   animations: {
                                    self.shareSmcConstraint.constant = 0
                                    
                                    self.view.layoutIfNeeded()
                    },
                                   completion: { (true) in
                    })
                    
                    UIView.setAnimationsEnabled(false)
                    
                    
                }
                print("swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                if isLeft {
                    //otherBtnView.isHidden = false
                   // shareSmcIdBtn.isHidden = true
                    followerBtn.isHidden = true
                    followingBtn.isHidden = true
                    noOfFollowers.isHidden = true
                    noOfFollowings.isHidden = true
                    isLeft = false
                    pageViewImg2.layer.borderColor = UIColor.black.cgColor
                    pageViewImg1.backgroundColor = UIColor.lightGray
                    pageViewImg2.backgroundColor = UIColor.white
                    pageViewImg2.layer.borderWidth = 1.0
                    pageViewImg1.layer.borderWidth = 0.0
                    
                    UIView.setAnimationsEnabled(true)
                    UIView.animate(withDuration: 0.5,
                                   delay: TimeInterval(0),
                                   options: UIViewAnimationOptions.transitionCurlDown,
                                   animations: {
                                    self.otherButtonViewCenterConstraint.constant = 0
                                    
                                    self.view.layoutIfNeeded()
                    },
                                   completion: { (true) in
                    })
                    
                    UIView.animate(withDuration: 0.5,
                                   delay: TimeInterval(0),
                                   options: UIViewAnimationOptions.transitionCurlDown,
                                   animations: {
                                    self.shareSmcConstraint.constant = -400
                                    
                                    self.view.layoutIfNeeded()
                    },
                                   completion: { (true) in
                    })
                    
                    UIView.setAnimationsEnabled(false)
                }
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func getSingleUser(userDict:NSDictionary) {
        
        let lUser = User(userdict: userDict)
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        if lUser.id != accountId {
            let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
            if lUser.device == "iphone" {
                let msg = uniqueName+" "+"just updated his "+(selectedNetwork?.networkTitle)!+" activity"
                Common.sendPusNotification(userNumber: uniqueName, title: "", body: msg, fcmID: (lUser.mFcmId))
            }
            else {
              //  Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "temp", body: "Added new happening", fcmID: (lUser.mFcmId))
                let msg = uniqueName+" "+"just updated his "+(selectedNetwork?.networkTitle)!+" activity"
                Common.sendPusNotificationPingToAndroid(userNumber: lUser.id, title: "", body: msg, fcmID: lUser.mFcmId)
            }
            
            DBProvider.Instance.userRef.child(lUser.id).child("activities").setValue("1")
            
            return
        }
        UserDefaults.standard.set(userDict, forKey: USER_DICT)
        
        if lUser.activities == "1" {
            activityNotificationCircule.isHidden = false
        }
        else {
            activityNotificationCircule.isHidden = true
        }
        
        if lUser.replies == "1" {
            followActivityNotificationCircule.isHidden = false
        }
        else {
            followActivityNotificationCircule.isHidden = true
        }
        
        if lUser.followRequestStatus == 1 {
            pendingRequestNotification.isHidden = false
        }
        else {
            pendingRequestNotification.isHidden = true
        }
        
        noOfFollowers.text = lUser.followers
        noOfFollowings.text = lUser.following
        userBio.text = lUser.bio
        profession.text = lUser.profession
        let profileUrl = URL(string: lUser.profile)
        print(lUser.profile)
        profileImage.kf.setImage(with: profileUrl)
        backgroundImageView.kf.setImage(with: profileUrl)
       // profileImage.roundImageView()
        makePolyGon()
        if lUser.profile.characters.count > 0 {
            profileImage.isHidden = false
        }
        if userBio.text!.count > 57 {
            descriptionProfessionViewHeightConstraint.constant = 80
        }
        else {
            
           // topViewHeightConstraint.constant = 329
            descriptionProfessionViewHeightConstraint.constant = 75
        }
    }
    
    func getUpdatedUser(userDict: NSDictionary) {
        UserDefaults.standard.setValue(userDict, forKey: USER_DICT)
        self.ChangeTabIcons()
    }
    
    func getUpdatedUserVal(userDict: NSDictionary) {
        UserDefaults.standard.setValue(userDict, forKey: USER_DICT)
        self.ChangeTabIcons()
    }
    
    func setUserValues() {
        let dict = UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary
        let lUser = User(userdict: dict)
        
        if lUser.activities == "1" {
            activityNotificationCircule.isHidden = false
        }
        else {
            activityNotificationCircule.isHidden = true
        }
        
        if lUser.replies == "1" {
            followActivityNotificationCircule.isHidden = false
        }
        else {
            followActivityNotificationCircule.isHidden = true
        }
        
        if lUser.followRequestStatus == 1 {
            pendingRequestNotification.isHidden = false
        }
        else {
            pendingRequestNotification.isHidden = true
        }
        
        noOfFollowers.text = lUser.followers
        noOfFollowings.text = lUser.following
        userBio.text = lUser.bio
        profession.text = lUser.profession
        let profileUrl = URL(string: lUser.profile)
        print(lUser.profile)
        profileImage.kf.setImage(with: profileUrl)
        backgroundImageView.kf.setImage(with: profileUrl)
        //profileImage.roundImageView()
        makePolyGon()
        if lUser.profile.characters.count > 0 {
            profileImage.isHidden = false
        }
    }
    
    func ChangeTabIcons() {
        
        let userdict = UserDefaults.standard.value(forKey: USER_DICT)
        let lUser = User(userdict: userdict as! NSDictionary)
        
        if lUser.activities == "1" || lUser.replies == "1" || lUser.followRequestStatus == 1{
            self.tabBarController?.tabBar.items![4].image = UIImage(named: "home_with_notification.png")
            self.tabBarController?.tabBar.items?[4].image = self.tabBarController?.tabBar.items?[4].image?.withRenderingMode(.alwaysOriginal)
            
            self.tabBarController?.tabBar.items![4].selectedImage = UIImage(named: "coloured_home_with_notification.png")
            self.tabBarController?.tabBar.items?[4].selectedImage = self.tabBarController?.tabBar.items?[4].selectedImage?.withRenderingMode(.alwaysOriginal)
        }
            
        else {
            
            self.tabBarController?.tabBar.items![4].image = UIImage(named: "profile_icon__gr.png")
            self.tabBarController?.tabBar.items?[4].image = self.tabBarController?.tabBar.items?[4].image?.withRenderingMode(.alwaysOriginal)
            
            self.tabBarController?.tabBar.items![4].selectedImage = UIImage(named: "selected4.png")
            self.tabBarController?.tabBar.items?[4].selectedImage = self.tabBarController?.tabBar.items?[4].selectedImage?.withRenderingMode(.alwaysOriginal)
            
        }
        
        if lUser.notification == "1" {
            self.tabBarController?.tabBar.items![3].selectedImage = UIImage(named: "coloured_messeages_with_notification.png")
            self.tabBarController?.tabBar.items?[3].selectedImage = self.tabBarController?.tabBar.items?[3].selectedImage?.withRenderingMode(.alwaysOriginal)
            
            self.tabBarController?.tabBar.items![3].image = UIImage(named: "messeages_with_notification.png")
            self.tabBarController?.tabBar.items?[3].image = self.tabBarController?.tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
        }
        
        else {
            self.tabBarController?.tabBar.items![3].image = UIImage(named: "messeges_icon__gr.png")
            self.tabBarController?.tabBar.items?[3].image = self.tabBarController?.tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
            
            self.tabBarController?.tabBar.items![3].selectedImage = UIImage(named: "selected3.png")
            self.tabBarController?.tabBar.items?[3].selectedImage = self.tabBarController?.tabBar.items?[3].selectedImage?.withRenderingMode(.alwaysOriginal)
        }
        
        if lUser.activities == "1" {
            activityNotificationCircule.isHidden = false
        }
        else {
            activityNotificationCircule.isHidden = true
        }
        
        if lUser.replies == "1" {
            followActivityNotificationCircule.isHidden = false
        }
        else {
            followActivityNotificationCircule.isHidden = true
        }
        
        if lUser.followRequestStatus == 1 {
            pendingRequestNotification.isHidden = false
        }
        else {
            pendingRequestNotification.isHidden = true
        }
    }
    
    func addViewControlers() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
        vc.title = ""
        let vc1 = storyboard.instantiateViewController(withIdentifier: "MyVideosViewController") as! MyVideosViewController
        vc1.title = ""
        let vc2 = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        vc2.title = ""
        let vc3 = storyboard.instantiateViewController(withIdentifier: "FollowActivityViewController") as! FollowActivityViewController
        vc3.title = ""
        var controllerArray : [UIViewController] = []
        controllerArray.append(vc)
        controllerArray.append(vc1)
        controllerArray.append(vc2)
        controllerArray.append(vc3)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .scrollMenuBackgroundColor(UIColor.clear),
            .viewBackgroundColor(UIColor.clear),
            .menuHeight(40.0),
            .menuItemSeparatorWidth(0.0),
            .selectionIndicatorColor(UIColor.clear),
            .addBottomMenuHairline(false),
            .useMenuLikeSegmentedControl(false),
            .centerMenuItems(true),
            .menuItemWidth(50.0),
            .menuItemSeparatorWidth(70.0),
            .menuMargin(33.0),
        ]
        
        vc.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        pageMenu?.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        var constantValue: CGFloat = 0.0
        let screenHight: CGFloat = UIScreen.main.bounds.size.height
        if screenHight > 667 {
            //buttonViewTopSpaceConstraint.constant = 90
            constantValue = 0.0
        }
        else {
            constantValue = 0.0
        }
        
        let rect = CGRect(origin: CGPoint(x: 0,y :topView.frame.height+constantValue), size: CGSize(width: self.cardView.frame.width, height: self.cardView.frame.height-topView.frame.height-4))
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        self.addChildViewController(pageMenu!)
        self.cardView.addSubview(pageMenu!.view)
        self.cardView.bringSubview(toFront: tabImageView)
        for view in self.pageMenu!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        topView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        topView.addGestureRecognizer(swipeLeft)
        
        pageMenu!.didMove(toParentViewController: self)

    }
    
    
    public func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * M_PI) / CGFloat(sides) // How much to turn at every corner
        let offset: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y : center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y : corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0..<sides {
            angle += theta
            
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y : center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y : center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta),y : corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y : corner.y + cornerRadius * sin(angle + theta))
            
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }
        
        path.close()
        
        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }
    
    func makePolyGon() {
        
        let lineWidth = CGFloat(4.0)
       // let rect = CGRect(x: profileImage.bounds.origin.x, y: profileImage.bounds.origin.y, width: profileImage.bounds.size.width, height: profileImage.bounds.size.height)
        let rect = profilePicBackgroundPolygon.bounds
        let sides = 6
        
        let path = roundedPolygonPath(rect: rect, lineWidth: lineWidth, sides: sides, cornerRadius: 15.0, rotationOffset: CGFloat(-M_PI / 2.0))
        
        let borderLayer = CAShapeLayer()
        borderLayer.frame = CGRect(x : 0.0, y : 0.0, width : path.bounds.width + lineWidth, height : path.bounds.height + lineWidth)
        
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.lineJoin = kCALineJoinRound
        borderLayer.lineCap = kCALineCapRound
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        let hexagon = createImage(layer: borderLayer)
       // profileImage.image = hexagon
        profilePicBackgroundPolygon.image = hexagon
        
        profileImage.roundImageView()
    }
    
    public func createImage(layer: CALayer) -> UIImage {
        let size = CGSize(width:  layer.frame.size.width, height: layer.frame.size.height)
        UIGraphicsBeginImageContextWithOptions(size, layer.isOpaque, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        
        layer.render(in: ctx!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
       // changeButtonColor(index: index)
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        changeButtonColor(index: index)
    }
    
    func changeButtonColor(index: Int) {
        if index == 0 {
//            imgLine1.isHidden = false
//            imgLine2.isHidden = true
//            imgLine3.isHidden = true
//            imgLine4.isHidden = true
            
            smcImageView.image = UIImage(named: "SMC1.png")
            postFeedImageView.image = UIImage(named: "post_feed_icon.png")
            activityImageView.image = UIImage(named: "activity_icon.png")
            profileActivityImageView.image = UIImage(named: "profile_acitvity.png")
            
            networkBtn.isSelected = true
            postBtn.isSelected = false
            notificationBtn.isSelected = false
            
        }
        else if index == 1 {
//            imgLine1.isHidden = true
//            imgLine2.isHidden = false
//            imgLine3.isHidden = true
//            imgLine4.isHidden = true
            smcImageView.image = UIImage(named: "SMC.png")
            postFeedImageView.image = UIImage(named: "post_feed_icon1.png")
            activityImageView.image = UIImage(named: "activity_icon.png")
            profileActivityImageView.image = UIImage(named: "profile_acitvity.png")
            
            networkBtn.isSelected = false
            postBtn.isSelected = true
            notificationBtn.isSelected = false
        }
        else if index == 2 {
//            imgLine1.isHidden = true
//            imgLine2.isHidden = true
//            imgLine3.isHidden = false
//            imgLine4.isHidden = true
            smcImageView.image = UIImage(named: "SMC.png")
            postFeedImageView.image = UIImage(named: "post_feed_icon.png")
            activityImageView.image = UIImage(named: "activity_icon1.png")
            profileActivityImageView.image = UIImage(named: "profile_acitvity.png")
            activityNotificationCircule.isHidden = true
            
            networkBtn.isSelected = false
            postBtn.isSelected = false
            notificationBtn.isSelected = true
            
        }
        else if index == 3 {
//            imgLine1.isHidden = true
//            imgLine2.isHidden = true
//            imgLine3.isHidden = true
//            imgLine4.isHidden = false
            smcImageView.image = UIImage(named: "SMC.png")
            postFeedImageView.image = UIImage(named: "post_feed_icon.png")
            activityImageView.image = UIImage(named: "activity_icon.png")
            profileActivityImageView.image = UIImage(named: "profile_acitvity1.png")
            followActivityNotificationCircule.isHidden = true
            
            networkBtn.isSelected = false
            postBtn.isSelected = false
            notificationBtn.isSelected = false
        }
    }

    @IBAction func GoToFollowers(_ sender: UIButton) {
        type = USER_FOLLOWERS
        self.performSegue(withIdentifier: "goToFollowings", sender: self)
    }
    
    
    @IBAction func GoToFollowing(_ sender: UIButton) {
        type = USER_FOLLOWING
        self.performSegue(withIdentifier: "goToFollowings", sender: self)
    }
    
    @IBAction func ShareProfileLink(_ sender: UIButton) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        
        if let shareNum = UserDefaults.standard.value(forKey: "shareNum") as? Int {
            DBProvider.Instance.userRef.child(accountId!).child("mSMCIdShareCount").setValue(shareNum+1)
            UserDefaults.standard.setValue(shareNum+1, forKey: "shareNum")
        }
        else {
            DBProvider.Instance.userRef.child(accountId!).child("mSMCIdShareCount").setValue(1)
            UserDefaults.standard.setValue(1, forKey: "shareNum")
        }
        
        sharescreenshotandtext()
    }
    
    @IBAction func CopyProfileLink(_ sender: UIButton) {
        let accountName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
        let someText = "https://thesmc.xyz/"+accountName!
        UIPasteboard.general.string = someText
        self.view.makeToast("Your profile link copied")
        
       
        
    }
    
    func sharescreenshotandtext() {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let accountName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
        let someText = "https://www.thesmc.xyz/"+accountName!
        self.shareaa(shareText: someText, shareImage: img, happening: "For quick access to all my Active social media and communication platforms, check out my Social Media card @.")
        return
    }
    
    func shareaa(shareText:String?,shareImage:UIImage?, happening: String?){
        
        var objectsToShare = [AnyObject]()
        
        
        let str:String?
        str = "For quick access to all my Active social media and communication platforms, check out my Social Media card @."
        if let shareTextObj2 = happening{
            objectsToShare.append(shareTextObj2 as AnyObject)
        }
        
        if let shareTextObj = shareText{
            //objectsToShare.append(shareTextObj as AnyObject)
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        //objectsToShare.append(shareImage as AnyObject)
        
        if shareText != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }
    
    
    @IBAction func ShareAction(_ sender: UIButton) {
        self.shareLink()
    }
    
    @IBAction func GoToCard(_ sender: UIButton) {
        
        if shareSmcLeftViewSpace.constant < 0 {
            UIView.setAnimationsEnabled(true)
            UIView.animate(withDuration: 0.5,
                           delay: TimeInterval(0),
                           options: UIViewAnimationOptions.transitionCurlDown,
                           animations: {
                            self.shareSmcLeftViewSpace.constant = 0
                            
                            self.view.layoutIfNeeded()
            },
                           completion: { (true) in
            })
        }
        else {
            UIView.animate(withDuration: 0.5,
                           delay: TimeInterval(0),
                           options: UIViewAnimationOptions.transitionCurlDown,
                           animations: {
                            self.shareSmcLeftViewSpace.constant = -200
                            
                            self.view.layoutIfNeeded()
            },
                           completion: { (true) in
                            UIView.setAnimationsEnabled(false)
            })
        }
        
    }
    
    
    @IBAction func AddTextField(_ sender: UIButton) {
        if addBtnCount < 2 {
            addBtnCount += 1
            
            if addBtnCount == 1 {
                secondView.isHidden = false
                secondViewHeight.constant = 50
                dialogViewHeight.constant = 410
            }
            else if addBtnCount == 2 {
                thirdView.isHidden = false
                thirdViewHeight.constant = 50
                dialogViewHeight.constant = 460
            }
            
        }
    }
    
    
    @IBAction func EdittingChanged(_ sender: UITextField) {
        closeDialogBtn.tag = 2
        closeDialogBtn.setBackgroundImage(UIImage(named: "checkmarkdone.png"), for: UIControlState.normal)
        print("starting")
        
        if sUsername.text == "" {
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            activeLabel.text = "Ping"
            sInfo.layer.borderColor = UIColor.darkGray.cgColor
            happeningBtn.isSelected = false
            selectedNetwork?.networkMessage = "0"
            DBProvider.Instance.userRef.child(accountId!).child("Happening").child((selectedNetwork?.networkTempData)!).removeValue()
        }
        
        
    }
    
    
    func shareLink() {
        if sUsername.text == "" || sInfo.text == "" {
            self.view.makeToast("Username and what's new should not be empty", duration: 3.0, position: .center)
            return
        }
        
        let accountName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
        let someText = "Follow ijaz on SMC @ "+"https://www.thesmc.xyz/"+accountName!
        let myName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let aString = myName+" "+"just updated their "+(selectedNetwork?.networkTitle)!+" on their SMC profile."
        self.shareaa(shareText: someText, shareImage: nil, happening: aString)
        
       // self.sharescreenshotandtext()
//        var appUrl: String = "this is my profile"
//        if sUsername.text == "" {
//            self.view.makeToast("No profile link found", duration: 2.0, position: .top)
//            return
//        }
//        if (sUsername.text?.contains(" "))! {
//            self.view.makeToast("Id is not correct", duration: 2.0, position: .top)
//            return
//        }
//
//
//        if selectedNetwork?.networkTitle.lowercased() == "facebook" {
//            appUrl = "fb://profile?id="+(selectedNetwork?.networkProfileLink)!
//            let fbWebUrl = "https://www.facebook.com/"+(selectedNetwork?.networkProfileLink)!
//            UIApplication.tryURL([appUrl, fbWebUrl])
//        }
//
//        if selectedNetwork?.networkTitle.lowercased() == "instagram" {
//            //let instAppUrl = "instagram://user?username="+userFullName.text!
//            var instaWebUrl = "https://www.instagram.com/"+sUsername.text!
//            if (sUsername.text?.contains(".com"))! {
//                instaWebUrl = sUsername.text!
//            }
//            UIApplication.tryURL([instaWebUrl, instaWebUrl])
//        }
//
//        if selectedNetwork?.networkTitle.lowercased() == "twitter" {
//            let twitterUrl = "twitter://user?screen_name="+sUsername.text!
//            var twitterWebUrl = "https://www.twitter.com/"+sUsername.text!
//            if (sUsername.text?.contains(".com"))! {
//                twitterWebUrl = sUsername.text!
//            }
//            UIApplication.tryURL([twitterUrl, twitterWebUrl])
//        }
//
//        if selectedNetwork?.networkTitle.lowercased() == "pinterest" {
//            var pinWebUrl = "https://www.pinterest.com/"+sUsername.text!
//            if (sUsername.text?.contains(".com"))! {
//                pinWebUrl = sUsername.text!
//            }
//            UIApplication.tryURL([pinWebUrl, pinWebUrl])
//        }
//
//        if selectedNetwork?.networkTitle.lowercased() == "snapchat" {
//            var pinWebUrl = "https://www.snapchat.com/add/"+sUsername.text!
//            if (sUsername.text?.contains(".com"))! {
//                pinWebUrl = sUsername.text!
//            }
//            UIApplication.tryURL([pinWebUrl, pinWebUrl])
//        }
//
//        if selectedNetwork?.networkTitle.lowercased() == "viber" {
//            var vibUrl = "viber://chat:"+sUsername.text!
//            if (sUsername.text?.contains(".com"))! {
//                vibUrl = sUsername.text!
//            }
//            UIApplication.tryURL([vibUrl, vibUrl])
//        }
//
//        if selectedNetwork?.networkTitle.lowercased() == "whatsapp" {
//            var appUrl = "https://api.whatsapp.com/send?phone="+sUsername.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = sUsername.text!
//            }
//            UIApplication.tryURL([appUrl, appUrl])
//        }
//
//        if selectedNetwork?.networkTitle.lowercased() == "google+" {
//            var appUrl = "https://plus.google.com/"+sUsername.text!
//            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = sUsername.text!
//            }
//            UIApplication.tryURL([appUrl, appUrl])
//        }
//        if selectedNetwork?.networkTitle.lowercased() == "linkedin" {
//            var appUrl = "https://www.linkedin.com/in/"+sUsername.text!
//            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = sUsername.text!
//            }
//            UIApplication.tryURL([appUrl, appUrl])
//        }
//        if selectedNetwork?.networkTitle.lowercased() == "youtube" {
//            let appUrl = sUsername.text
//            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            UIApplication.tryURL([appUrl!, appUrl!])
//        }
//
//        if selectedNetwork?.networkTitle.lowercased() == "vk" {
//            var appUrl = "https://www.vk.com/"+sUsername.text!
//            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = sUsername.text!
//            }
//            UIApplication.tryURL([appUrl, appUrl])
//        }
//        if selectedNetwork?.networkTitle.lowercased() == "flicker" {
//            var appUrl = "https://www.flicker.com/photos/"+sUsername.text!
//            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = sUsername.text!
//            }
//            UIApplication.tryURL([appUrl, appUrl])
//        }
//        if selectedNetwork?.networkTitle.lowercased() == "soundcloud" {
//            var appUrl = "https://soundcloud.com/"+sUsername.text!
//            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = sUsername.text!
//            }
//            UIApplication.tryURL([appUrl, appUrl])
//        }
//        if selectedNetwork?.networkTitle.lowercased() == "skype" {
//            var appUrl = "https://join.skype.com/invite"+sUsername.text!
//            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = sUsername.text!
//            }
//            UIApplication.tryURL([appUrl, appUrl])
//        }
//        if selectedNetwork?.networkTitle.lowercased() == "telegram" {
//            var appUrl = "http://www.telegram.me/"+sUsername.text!
//            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = sUsername.text!
//            }
//            UIApplication.tryURL([appUrl, appUrl])
//        }
//        else {
//            let appUrl = sUsername.text!
//            UIApplication.tryURL([appUrl, appUrl])
//        }

        
        
        
        
        
//        let bounds = UIScreen.main.bounds
//        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
//        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        let accountName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
//        let someText = "https://www.thesmc.xyz/"+accountName!
//        self.shareaa(shareText: someText, shareImage: img,happening: (selectedNetwork?.additionalInfo1)!)
        
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        if publicBtn.titleLabel?.text == "PRIVATE" {
            profileVisibilityLabel.text = "Public"
            privateLabel2.text = "Public"
            selectedNetwork?.networkStatus = "1"
             publicBtn.setTitle("PUBLIC", for: UIControlState.normal)
            publicBtn.isSelected = false
            publicBtn2.isSelected = false
        DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").child((selectedNetwork?.networkTempData)!).updateChildValues(["mNetworkStatus" : 1])
            
            let toastString = "your "+(selectedNetwork?.networkTitle)!+" info is public now"
            self.view.makeToast(toastString, duration: 3.0, position: .center)
            
        } else {
            publicBtn.isSelected = true
            publicBtn2.isSelected = true
            profileVisibilityLabel.text = "Private"
            privateLabel2.text = "Private"
            publicBtn.setTitle("PRIVATE", for: UIControlState.normal)
            selectedNetwork?.networkStatus = "0"
        DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").child((selectedNetwork?.networkTempData)!).updateChildValues(["mNetworkStatus" : 0])
            let toastString = "No body will be able to see your "+(selectedNetwork?.networkTitle)!+" info on your SMC card"
            self.view.makeToast(toastString, duration: 3.0, position: .center)
            
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            activeLabel.text = "Ping"
            sInfo.layer.borderColor = UIColor.darkGray.cgColor
            happeningBtn.isSelected = false
            selectedNetwork?.networkMessage = "0"
            DBProvider.Instance.userRef.child(accountId!).child("Happening").child((selectedNetwork?.networkTempData)!).removeValue()
            
        }
        
        
        return
            
        
            (selectedNetwork?.additionalInfo1 = sInfo.text!)!
        selectedNetwork?.additionalInfo2 = sFullName.text
        selectedNetwork?.networkProfileLink = sUsername.text!
        
        if (secondProfileLink.text?.characters.count)! > 0 {
            selectedNetwork?.networkProfileLink2 = secondProfileLink.text!
        }
        
        if (thirdProfileLink.text?.characters.count)! > 0 {
            selectedNetwork?.networkProfileLink3 = thirdProfileLink.text!
        }
        
        
        
        UserDBHandler.Instance.updateSocialInfo(network: selectedNetwork!)
        self.dialogView.isHidden = true
        self.dismissKeyboard()
        
    }
    
    
    @IBAction func OpenProfile(_ sender: UIButton) {
        
        var appUrl: String = "this is my profile"
        if sUsername.text == "" {
            self.view.makeToast("Check profile details", duration: 2.0, position: .center)
            return
        }
        if (sUsername.text?.contains(" "))! {
            self.view.makeToast("Check profile details", duration: 2.0, position: .center)
            return
        }
        
        
        if selectedNetwork?.networkTitle.lowercased() == "facebook" {
            appUrl = "fb://profile?id="+(selectedNetwork?.networkProfileLink)!
            let fbWebUrl = "https://www.facebook.com/"+(selectedNetwork?.networkProfileLink)!
            UIApplication.tryURL([appUrl, fbWebUrl])
        }
        
        else if selectedNetwork?.networkTitle.lowercased() == "instagram" {
            //let instAppUrl = "instagram://user?username="+userFullName.text!
            var instaWebUrl = "https://www.instagram.com/"+sUsername.text!
            if (sUsername.text?.contains(".com"))! {
                instaWebUrl = sUsername.text!
            }
            UIApplication.tryURL([instaWebUrl, instaWebUrl])
        }
        
       else if selectedNetwork?.networkTitle.lowercased() == "twitter" {
            let twitterUrl = "twitter://user?screen_name="+sUsername.text!
            var twitterWebUrl = "https://www.twitter.com/"+sUsername.text!
            if (sUsername.text?.contains(".com"))! {
                twitterWebUrl = sUsername.text!
            }
            UIApplication.tryURL([twitterUrl, twitterWebUrl])
        }
        
       else if selectedNetwork?.networkTitle.lowercased() == "pinterest" {
            var pinWebUrl = "https://www.pinterest.com/"+sUsername.text!
            if (sUsername.text?.contains(".com"))! {
                pinWebUrl = sUsername.text!
            }
            UIApplication.tryURL([pinWebUrl, pinWebUrl])
        }
        
       else if selectedNetwork?.networkTitle.lowercased() == "snapchat" {
            var pinWebUrl = "https://www.snapchat.com/add/"+sUsername.text!
            if (sUsername.text?.contains(".com"))! {
                pinWebUrl = sUsername.text!
            }
            UIApplication.tryURL([pinWebUrl, pinWebUrl])
        }
        
       else if selectedNetwork?.networkTitle.lowercased() == "viber" {
            var vibUrl = "viber://chat:"+sUsername.text!
            if (sUsername.text?.contains(".com"))! {
                vibUrl = sUsername.text!
            }
            UIApplication.tryURL([vibUrl, vibUrl])
        }
        
        else if selectedNetwork?.networkTitle.lowercased() == "whatsapp" {
            var appUrl = "https://api.whatsapp.com/send?phone="+sUsername.text!
            if (sUsername.text?.contains(".com"))! {
                appUrl = sUsername.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        
       else if selectedNetwork?.networkTitle.lowercased() == "google+" {
            var appUrl = "https://plus.google.com/"+sUsername.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (sUsername.text?.contains(".com"))! {
                appUrl = sUsername.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
       else if selectedNetwork?.networkTitle.lowercased() == "linkedin" {
            var appUrl = "https://www.linkedin.com/in/"+sUsername.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (sUsername.text?.contains(".com"))! {
                appUrl = sUsername.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
       else if selectedNetwork?.networkTitle.lowercased() == "youtube" {
            let appUrl = sUsername.text
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            UIApplication.tryURL([appUrl!, appUrl!])
        }
        
       else if selectedNetwork?.networkTitle.lowercased() == "vk" {
            var appUrl = "https://www.vk.com/"+sUsername.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (sUsername.text?.contains(".com"))! {
                appUrl = sUsername.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
       else if selectedNetwork?.networkTitle.lowercased() == "flicker" {
            var appUrl = "https://www.flicker.com/photos/"+sUsername.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (sUsername.text?.contains(".com"))! {
                appUrl = sUsername.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
       else if selectedNetwork?.networkTitle.lowercased() == "soundcloud" {
            var appUrl = "https://soundcloud.com/"+sUsername.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (sUsername.text?.contains(".com"))! {
                appUrl = sUsername.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
       else if selectedNetwork?.networkTitle.lowercased() == "skype" {
            var appUrl = "https://join.skype.com/invite"+sUsername.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (sUsername.text?.contains(".com"))! {
                appUrl = sUsername.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
       else if selectedNetwork?.networkTitle.lowercased() == "telegram" {
            var appUrl = "http://www.telegram.me/"+sUsername.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (sUsername.text?.contains(".com"))! {
                appUrl = sUsername.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
            
        else if selectedNetwork?.networkTitle.lowercased() == "reddit" {
            var appUrl = "https://www.reddit.com/"+sUsername.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
//            if (sUsername.text?.contains(".com"))! {
//                appUrl = "https://www."+sUsername.text!
//            }
            
            if (sUsername.text?.lowercased().contains("https://www."))! {
                appUrl = sUsername.text!
            }
            else if (sUsername.text?.lowercased().contains(".com"))! && !(sUsername.text?.lowercased().contains("www"))! {
                appUrl = "https://www."+sUsername.text!
            }
            else if (sUsername.text?.lowercased().contains("www"))! {
                appUrl = "https://"+sUsername.text!
            }
            
            UIApplication.tryURL([appUrl, appUrl])
        }
            
        else if selectedNetwork?.networkTitle.lowercased() == "direction" {
         //   let lat = 37.7
        //    let lon = -122.4
            
            //let appUrl = "https://maps.google.com/?q=@\(lat),\(lon)"
            if (sUsername.text?.contains(".com"))! {
                let appUrl = sUsername.text!
                UIApplication.tryURL([appUrl, appUrl])
            }
            else {
                self.view.makeToast("Check profile details", duration: 2.0, position: .center)
            }
        }
            
        else if selectedNetwork?.networkTitle.lowercased() == "phone" {
            guard let number = URL(string: "tel://" + sUsername.text!) else { return }
            UIApplication.shared.open(number)
        }
            
        else if selectedNetwork?.networkTitle.lowercased() == "messenger" {
            let userID = sUsername.text
            let urlStr = String(format: "fb-messenger://user-thread/%d", userID!)
            UIApplication.tryURL([urlStr, urlStr])
        }
            
            
        else {
            
            if (sUsername.text?.contains(".com"))! {
                var appUrl = sUsername.text!
                if (sUsername.text?.lowercased().contains("https://"))! {
                    appUrl = sUsername.text!
                }
                else if (sUsername.text?.lowercased().contains(".com"))! && !(sUsername.text?.lowercased().contains("www"))! {
                    appUrl = "https://www."+sUsername.text!
                }
                else if (sUsername.text?.lowercased().contains("www"))! {
                    appUrl = "https://"+sUsername.text!
                }
                
                
                UIApplication.tryURL([appUrl, appUrl])
            }
            else {
                self.view.makeToast("Check profile details", duration: 2.0, position: .center)
            }
            
        }
    }
    
    @IBAction func CloseDialog(_ sender: UIButton) {
        largePictureView.isHidden = true
        //self.tabBarController?.tabBar.isHidden = false
       // bView?.removeFromSuperview()
       // activeLabel.text = "Deactive Now"
        happeningBtn.isSelected = false
        sInfo.layer.borderColor = UIColor.darkGray.cgColor
        self.dialogView.isHidden = true
        self.dismissKeyboard()
        addBtnCount = 0
       // dialogViewHeight.constant = 290
        secondViewHeight.constant = 0
        thirdViewHeight.constant = 0
        secondView.isHidden = true
        thirdView.isHidden = true
        closeDialogBtn.setBackgroundImage(UIImage(named: "exit_icon.png"), for: UIControlState.normal)
        
        if closeDialogBtn.tag == 1 {
            return
        }
        closeDialogBtn.tag = 1
        selectedNetwork?.additionalInfo1 = sInfo.text
        selectedNetwork?.additionalInfo2 = sFullName.text
        selectedNetwork?.networkProfileLink = sUsername.text!
        
        if (secondProfileLink.text?.characters.count)! > 0 {
            selectedNetwork?.networkProfileLink2 = secondProfileLink.text!
        }
        
        if (thirdProfileLink.text?.characters.count)! > 0 {
            selectedNetwork?.networkProfileLink3 = thirdProfileLink.text!
        }
        
        
        
        UserDBHandler.Instance.updateSocialInfo(network: selectedNetwork!)
        self.dialogView.isHidden = true
        self.dismissKeyboard()
        if !happeningBtnPressed {
           // self.happeningAction()
        }
        
        if sUsername.text == "" || sInfo.text == "" {
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            activeLabel.text = "Ping"
            sInfo.layer.borderColor = UIColor.darkGray.cgColor
            happeningBtn.isSelected = false
            selectedNetwork?.networkMessage = "0"
            DBProvider.Instance.userRef.child(accountId!).child("Happening").child((selectedNetwork?.networkTempData)!).removeValue()
        }
        
        happeningBtnPressed = false
    }
    
    
    @IBAction func GoToSettings(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    
    func showDialog(lNetwork: SocialNetworks) {
        
        largePictureView.isHidden = false
        
        
        
        
        closeDialogBtn.tag = 1
        closeDialogBtn.setBackgroundImage(UIImage(named: "exit_icon.png"), for: UIControlState.normal)
        print("starting")
        
    let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        
    DBProvider.Instance.userRef.child(accountId!).child("Happening").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                self.happeningArray.removeAll()
                for item in dict {
                    self.happeningArray.append(item.value as! NSDictionary)
                    print("hello")
                }
                
                let sArray = self.happeningArray.filter() {($0["Id"] as! String).contains((lNetwork.networkTempData))}
                if sArray.count > 0 {
                    let tTime = sArray[0]["time"] as! Int
                    let sTime =  Date().millisecondsSince1970 - 86400000
                    if sTime < tTime {
                       // redCirculeImageview.isHidden = false
                        self.activeLabel.text = "Un-ping"
                        self.happeningBtn.isSelected = true
                        self.sInfo.layer.borderColor = UIColor.red.cgColor
                    }
                    else {
                       // redCirculeImageview.isHidden = true
                        self.activeLabel.text = "Ping"
                        self.happeningBtn.isSelected = false
                        self.sInfo.layer.borderColor = UIColor.darkGray.cgColor
                    }
                    
                }
                else {
                   // redCirculeImageview.isHidden = true
                    self.activeLabel.text = "Ping"
                    self.happeningBtn.isSelected = false
                    self.sInfo.layer.borderColor = UIColor.darkGray.cgColor
                }
                
            }
        })
        
        //self.tabBarController?.tabBar.isHidden = true
        sSwitch.delegate = self
        if lNetwork.networkStatus == "0" {
            sSwitch.isOn = false
            publicBtn.titleLabel?.text = "PRIVATE"
            publicBtn.setTitle("PRIVATE", for: UIControlState.normal)
            profileVisibilityLabel.text = "Private"
            privateLabel2.text = "Private"
            sSwitch.myColor = UIColor.black
            publicBtn.isSelected = true
            publicBtn2.isSelected = true
        }
        else {
            sSwitch.isOn = true
            sSwitch.myColor = UIColor.green
            profileVisibilityLabel.text = "Public"
            privateLabel2.text = "Public"
            publicBtn.titleLabel?.text = "PUBLIC"
            publicBtn.setTitle("PUBLIC", for: UIControlState.normal)
            publicBtn.isSelected = false
            publicBtn2.isSelected = false
        }

        
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        if screenHeight == 812 {
           dialogTopSpaceConstraint.constant = screenHeight-dialogViewHeight.constant-150
        }
        else {
            dialogTopSpaceConstraint.constant = screenHeight-dialogViewHeight.constant-70
        }
        
        selectedNetwork = lNetwork
        //sUsername.becomeFirstResponder()
        sUsername.text = lNetwork.networkProfileLink
        secondProfileLink.text = lNetwork.networkProfileLink2
        thirdProfileLink.text = lNetwork.networkProfileLink3
        sInfo.text = lNetwork.additionalInfo1
        sFullName.text = lNetwork.additionalInfo2
        sUsername.placeholder = lNetwork.networkTitle+" username/ID"
        secondProfileLink.placeholder = lNetwork.networkTitle+" username/ID"
        thirdProfileLink.placeholder = lNetwork.networkTitle+" username/ID"
        
        if sInfo.text == "" {
            sInfoPlaceHolderLabel.isHidden = false
        }
        else {
            sInfoPlaceHolderLabel.isHidden = true
        }
        

        
        self.dialogView.isHidden = false
        sLabel.text = lNetwork.networkTitle
        let urlString = lNetwork.networkTitle.lowercased()+".png"
        socialImageView.image = UIImage(named: urlString)
        
        self.view.bringSubview(toFront: dialogView)
        
        let blurEffectViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(blurredViewTapped(tapGestureRecognizer:)))
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(blurEffectViewTapGesture)
        
        if sLabel.text?.lowercased() == "custom links" {
            sUsername.placeholder = "Enter Custom Link"
        }
        
        else if sLabel.text?.lowercased() == "direction" {
            sUsername.placeholder = "Enter Address"
        }
        
        else if sLabel.text?.lowercased() == "app" {
            sUsername.placeholder = "Enter App Link"
        }
        
        else if sLabel.text?.lowercased() == "youtube" {
            sUsername.placeholder = "Enter Channel's Link"
        }
        
        else if sLabel.text?.lowercased() == "twitter" ||  sLabel.text?.lowercased() == "messenger" ||  sLabel.text?.lowercased() == "snapchat" ||  sLabel.text?.lowercased() == "facebook" ||  sLabel.text?.lowercased() == "instagram" || sLabel.text?.lowercased() == "musically" {
            sUsername.placeholder = "User id"
        }
        
        else if sLabel.text?.lowercased() == "whatsapp" || sLabel.text?.lowercased() == "line" || sLabel.text?.lowercased() == "viber" || sLabel.text?.lowercased() == "phone" || sLabel.text?.lowercased() == "wechat" || sLabel.text?.lowercased() == "telegram" {
           // displayProfileImgVierw.image = UIImage(named: "ic_telephone.png")
            sUsername.placeholder = "Phone with country code #"
            
        }
        else if sLabel.text?.lowercased() == "blog" {
            sUsername.placeholder = "Blog Url"
        }
        else if sLabel.text?.lowercased() == "podcast" {
            sUsername.placeholder = "Enter Podcast Link"
        }
        else if sLabel.text?.lowercased() == "soundcloud" {
            sUsername.placeholder = "Enter User ID"
        }
        else if sLabel.text?.lowercased() == "bbm" {
            sUsername.placeholder = "Pin#"
        }

        else {
            //displayProfileImgVierw.image = UIImage(named: "display_profile_btn.png")
            sUsername.placeholder = "Enter Profile Link"
        }
        
        if sLabel.text?.lowercased() == "phone" {
            displayProfileImgVierw.image = UIImage(named: "ic_telephone.png")
        }
        else {
            displayProfileImgVierw.image = UIImage(named: "display_profile_btn.png")
        }
        
        if sLabel.text?.lowercased() == "email" || sLabel.text?.lowercased() == "hotmail" || sLabel.text?.lowercased() == "outlook" || sLabel.text?.lowercased() == "gmail" || sLabel.text?.lowercased() == "yahoo" || sLabel.text?.lowercased() == "email address" {
            //idBox.image = UIImage(named: "Email Address1.png")
           // statusBox.image = UIImage(named: "status_box_w_label.png")
            idBox.isHidden = false
            sUsername.isHidden = false
            
            statusBoxTopSpaceConstraint.constant = 4
            userInfoHeight.constant = 53
            statusBoxHeight.constant = 115
            userInfoTopSpaceConstraint.constant = 25
            statusBoxRightSpace.constant = 1
            userInfoRightSpace.constant = 24
            activeLabel.isHidden = false
            happeningBtn.isHidden = false
             palceholderLeftSpace.constant = 28
            sUsername.placeholder = "Email Address"
            
            shareBtn.isHidden = false
            shareLabel.isHidden = false
            viewLabel.isHidden = false
            displayProfileImgVierw.isHidden = false
            publicBtn.isHidden = false
            profileVisibilityLabel.isHidden = false
            publicBtn2.isHidden = true
            privateLabel2.isHidden = true
            sInfoPlaceHolderLabel.text = "Whats's new"
            
            
        }
        else if sLabel.text?.lowercased() == "website" {
           // idBox.image = UIImage(named: "Website.png")
            //statusBox.image = UIImage(named: "status_box_w_label.png")
            idBox.isHidden = false
            sUsername.isHidden = false
            
            statusBoxTopSpaceConstraint.constant = 4
            userInfoHeight.constant = 53
            statusBoxHeight.constant = 115
            userInfoTopSpaceConstraint.constant = 25
            statusBoxRightSpace.constant = 1
            userInfoRightSpace.constant = 24
            activeLabel.isHidden = false
            happeningBtn.isHidden = false
             palceholderLeftSpace.constant = 28
            sUsername.placeholder = "Web Url"
            
            shareBtn.isHidden = false
            shareLabel.isHidden = false
            viewLabel.isHidden = false
            displayProfileImgVierw.isHidden = false
            publicBtn.isHidden = false
            profileVisibilityLabel.isHidden = false
            publicBtn2.isHidden = true
            privateLabel2.isHidden = true
            sInfoPlaceHolderLabel.text = "Whats's new"
            
            
            
        }
        else if sLabel.text?.lowercased() == "about me" {
            //statusBox.image = UIImage(named: "AboutMeBlack.png")
            //idBox.image = UIImage(named: "id_box_w_label.png")
            idBox.isHidden = true
            sUsername.isHidden = true
            
            statusBoxTopSpaceConstraint.constant = -60
            userInfoHeight.constant = 90
            statusBoxHeight.constant = 170
            userInfoTopSpaceConstraint.constant = -30
            statusBoxRightSpace.constant = -40
            userInfoRightSpace.constant = -15
            activeLabel.isHidden = true
            happeningBtn.isHidden = true
             palceholderLeftSpace.constant = 130
            
            shareBtn.isHidden = true
            shareLabel.isHidden = true
            viewLabel.isHidden = true
            displayProfileImgVierw.isHidden = true
            publicBtn.isHidden = true
            profileVisibilityLabel.isHidden = true
            
            publicBtn2.isHidden = false
            privateLabel2.isHidden = false
            
            sInfoPlaceHolderLabel.text = "About me"
            
        }
        else {
            //idBox.image = UIImage(named: "id_box_w_label.png")
            //statusBox.image = UIImage(named: "status_box_w_label.png")
            idBox.isHidden = false
            sUsername.isHidden = false
            
            statusBoxTopSpaceConstraint.constant = 4
            userInfoHeight.constant = 53
            statusBoxHeight.constant = 115
            userInfoTopSpaceConstraint.constant = 25
            statusBoxRightSpace.constant = 1
            userInfoRightSpace.constant = 24
            activeLabel.isHidden = false
            happeningBtn.isHidden = false
            palceholderLeftSpace.constant = 28
            
            shareBtn.isHidden = false
            shareLabel.isHidden = false
            viewLabel.isHidden = false
            displayProfileImgVierw.isHidden = false
            publicBtn.isHidden = false
            profileVisibilityLabel.isHidden = false
            publicBtn2.isHidden = true
            privateLabel2.isHidden = true
            sInfoPlaceHolderLabel.text = "Whats's new"
        }
        
       let gifImage = UIImage.gif(name: "bell_ani")
        happeningBtn.setImage(gifImage, for: UIControlState.selected)
        
    }
    
    
    @IBAction func HappeningAction(_ sender: UIButton) {
        
        self.happeningAction()
        happeningBtnPressed = true
        
//        if activeLabel.text == "Deactive Now" {
//            activeLabel.text = "Active Now"
//            sInfo.layer.borderColor = UIColor.red.cgColor
//            happeningBtn.isSelected = true
//
//            selectedNetwork?.additionalInfo1 = sInfo.text
//            selectedNetwork?.networkProfileLink = sUsername.text!
//
//            UserDBHandler.Instance.updateSocialInfo(network: selectedNetwork!)
//            UserDBHandler.Instance.AddHappening(networkId: (selectedNetwork?.networkTempData)!)
//        }
//        else {
//            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
//            activeLabel.text = "Deactive Now"
//            sInfo.layer.borderColor = UIColor.darkGray.cgColor
//            happeningBtn.isSelected = false
//            DBProvider.Instance.userRef.child(accountId!).child("Happening").child((selectedNetwork?.networkTempData)!).removeValue()
//
//
//        }
        
    }
    
    func happeningAction() {
        let gifImage = UIImage.gif(name: "bell_ani")
        happeningBtn.setImage(gifImage, for: UIControlState.selected)
        
        if profileVisibilityLabel.text?.lowercased() == "private" {
            self.view.makeToast("Your network is private", duration: 2.0, position: .center)
            return
        }
        
        if sUsername.text == "" || sInfo.text == "" {
            self.view.makeToast("Profile link and what's new should not be empty ", duration: 2.0, position: .center)
            return
        }
        
        if activeLabel.text == "Ping" {
            activeLabel.text = "Un-ping"
            sInfo.layer.borderColor = UIColor.red.cgColor
            happeningBtn.isSelected = true
            let myName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
            let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
            let aString = myName+" "+"just updated his "+(selectedNetwork?.networkTitle)!+" activity"
            UserDBHandler.Instance.setOtherUserActivities(activityString: aString, userId: accountId)
            self.view.makeToast("Ping has been sent to your SMC followers", duration: 3.0, position: .center)
            
            selectedNetwork?.additionalInfo1 = sInfo.text
            selectedNetwork?.networkProfileLink = sUsername.text!
            selectedNetwork?.networkMessage = "1"
            
            UserDBHandler.Instance.updateSocialInfo(network: selectedNetwork!)
            UserDBHandler.Instance.AddHappening(networkId: (selectedNetwork?.networkTempData)!)
            DBProvider.Instance.userRef.child(accountId).child(USER_USERFOLLOWERS_NODE).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dict = snapshot.value as? NSDictionary {
                    print("hello")
                    var countLoop: Int = 0
                    for item in (dict.allKeys) {
                        UserDBHandler.Instance.getSingleUserDelegate = self
                        UserDBHandler.Instance.getSingleUser(userId: item as! String)
                        
                        
                    }
                }
            })
            
            if profileVisibilityLabel.text == "Private" {
                let toastString = "No body will be able to see your "+(selectedNetwork?.networkTitle)!+" info on your SMC card"
                self.view.makeToast(toastString, duration: 3.0, position: .center)
            }
        }
        else {
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            activeLabel.text = "Ping"
            sInfo.layer.borderColor = UIColor.darkGray.cgColor
            happeningBtn.isSelected = false
            selectedNetwork?.networkMessage = "0"
            DBProvider.Instance.userRef.child(accountId!).child("Happening").child((selectedNetwork?.networkTempData)!).removeValue()
            
        }
        closeDialogBtn.tag = 2
        closeDialogBtn.setBackgroundImage(UIImage(named: "checkmarkdone.png"), for: UIControlState.normal)
        print("starting")
        
//            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
//
//        DBProvider.Instance.userRef.child(accountId!).child(USER_USERFOLLOWERS_NODE).observeSingleEvent(of: .value, with: { (snapshot) in
//
//            if let dict = snapshot.value as? NSDictionary {
//                print("hello")
//                var countLoop: Int = 0
//                for item in (dict.allKeys) {
//                    UserDBHandler.Instance.getSingleUserDelegate = self
//                    UserDBHandler.Instance.getSingleUser(userId: item as! String)
//
//
//                }
//            }
//        })

    }
    
    @IBAction func HappeningFieldChangedText(_ sender: UITextField) {
        if sInfo.text?.count == 0 {
            //happeningBtn.isSelected = false
        }
        else {
            //happeningBtn.isSelected = true
        }
        closeDialogBtn.tag = 2
        closeDialogBtn.setBackgroundImage(UIImage(named: "checkmarkdone.png"), for: UIControlState.normal)
        print("starting")
    }
    
    
    func showUploadedImage(urlString: String) {
        let imgUrl = URL(string: urlString)
        largeImageView.kf.setImage(with: imgUrl)
        largePictureView.isHidden = false
    }
    
    
    @IBAction func hideLargeImageView(_ sender: UIButton) {
        largePictureView.isHidden = true
    }
    
    func GoToUserProfile(lUser: User) {
        selectedUser = lUser
        DBProvider.Instance.userRef.child((selectedUser?.id)!).child("Blocked").observeSingleEvent(of: .value, with: { (snapshot) in
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            if snapshot.hasChild(accountId!) {
                return
            }
            else {
                self.performSegue(withIdentifier: "goToProfile", sender: self)
            }
            
        })
        
    }
    
    func blurredViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       self.dialogView.isHidden = true
        self.dismissKeyboard()
        tapGestureRecognizer.view?.removeFromSuperview()
    }
    
    
    
    func dismissKeyboard() {
        sUsername.resignFirstResponder()
        sFullName.resignFirstResponder()
        sInfo.resignFirstResponder()
        secondProfileLink.resignFirstResponder()
        thirdProfileLink.resignFirstResponder()
    }
    
    @IBAction func ChangeProfileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSetProfile", sender: self)
    }
    
    
    @IBAction func GoToAddNetworkScreen(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSocial", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userDict = UserDefaults.standard.value(forKey: USER_DICT)
        let lUser = User(userdict: userDict as! NSDictionary)
        if segue.identifier == "goToFollowings" {
            let nextScene = segue.destination as! FollowingsViewController
            nextScene.selectedUser = lUser
            nextScene.type = type
        }
        else if segue.identifier == "goToProfile" {
            let nextScene = segue.destination as! UserProfileViewController
            nextScene.selectedUser = selectedUser
            nextScene.viewControllerName = "Activity"
        }
        else if segue.identifier == "goToSetProfile" {
            let nextScene = segue.destination as! SetProfileViewController
            nextScene.updateProfile = "update"
            nextScene.userBio = userBio.text
            nextScene.userProfession = profession.text
        }
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        if textView.numberOfLines() == 7 {
//            self.view.makeToast("Limit exceeded", duration: 3.0, position: .center)
//        }
//        return textView.numberOfLines() <= 7
//    }
}

extension MyProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sUsername.resignFirstResponder()
        sInfo.resignFirstResponder()
        sFullName.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension MyProfileViewController: SwiftySwitchDelegate {
    
    func valueChanged(sender: SwiftySwitch) {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        if sender.isOn {
            profileVisibilityLabel.text = "Public"
            privateLabel2.text = "Public"
            selectedNetwork?.networkStatus = "1"
            sender.myColor = UIColor.green
            DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").child((selectedNetwork?.networkTempData)!).updateChildValues(["mNetworkStatus" : 1])
            
        } else {
            profileVisibilityLabel.text = "Private"
            privateLabel2.text = "Private"
            sender.myColor = UIColor.black
            selectedNetwork?.networkStatus = "0"
            DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").child((selectedNetwork?.networkTempData)!).updateChildValues(["mNetworkStatus" : 0])
            
        }
    }
}

extension MyProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let tt = textView.numberOfLines()
        if tt > 7 {
            
        }
        if textView.text == "" {
            sInfoPlaceHolderLabel.isHidden = false
            let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
            activeLabel.text = "Ping"
            sInfo.layer.borderColor = UIColor.darkGray.cgColor
            happeningBtn.isSelected = false
            selectedNetwork?.networkMessage = "0"
            DBProvider.Instance.userRef.child(accountId!).child("Happening").child((selectedNetwork?.networkTempData)!).removeValue()
        }
        else {
            sInfoPlaceHolderLabel.isHidden = true
        }
        closeDialogBtn.tag = 2
        closeDialogBtn.setBackgroundImage(UIImage(named: "checkmarkdone.png"), for: UIControlState.normal)
        print("starting")
    }
}

extension UITextView{
    
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
}

