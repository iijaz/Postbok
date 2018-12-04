//
//  UserProfileViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/8/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit
import PageMenu
class UserProfileViewController: UIViewController, IsBeingFollowedDelegate, GetConvIdDelegate, CAPSPageMenuDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var noOfFollowers: UILabel!
    @IBOutlet weak var noOfFollowings: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var circuleView: UIImageView!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var privateProfileView: UIView!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var imgLine1: UIImageView!
    @IBOutlet weak var imgLine2: UIImageView!
    @IBOutlet weak var largeImageView: UIView!
    @IBOutlet weak var largeProfileImageView: UIImageView!
    
    @IBOutlet weak var smcImageView: UIImageView!
    @IBOutlet weak var postFeedImageView: UIImageView!
    
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var followerBtn: UIButton!
    @IBOutlet weak var blockBtn: UIButton!
    @IBOutlet weak var statusBoundry: UIImageView!
    @IBOutlet weak var whatsNewImgView: UIImageView!
    
    @IBOutlet weak var blackViewLayer: UIView!
    
    @IBOutlet weak var statusBoundryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userInfoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userInfoRightSpace: NSLayoutConstraint!
    
    @IBOutlet weak var statusBoxRightSpace: NSLayoutConstraint!
    @IBOutlet weak var statusBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var userInfoHeight: NSLayoutConstraint!
    @IBOutlet weak var openSocialProfileBtn: UIButton!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userSocialUserName: UILabel!
    @IBOutlet weak var userSocialInfo: UILabel!
    
    @IBOutlet weak var userSocialInfoTextView: UITextView!
    @IBOutlet weak var selectedNetworkName: UILabel!
    
    @IBOutlet weak var selectedSocialImage: UIImageView!
    
    @IBOutlet weak var gradiantImageView: UIImageView!
    
    @IBOutlet weak var secondProfileLabelView: UIView!
    @IBOutlet weak var thirdLabelView: UIView!
    @IBOutlet weak var secondProfileLabel: UILabel!
    @IBOutlet weak var thirdProfileLabel: UILabel!
    
    @IBOutlet weak var secondLabelViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dialogViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdLabelViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var networksBtn: UIButton!
    @IBOutlet weak var postsBtn: UIButton!
    @IBOutlet weak var polygonImgView: UIImageView!
    
    @IBOutlet weak var idBox: UIImageView!
    @IBOutlet weak var statusBox: UIImageView!
    @IBOutlet weak var statusBoxWhtieView: UIView!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var eyeImgView: UIImageView!
    @IBOutlet weak var phoneImgView: UIImageView!
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var coverImageView: UIImageView!
     let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
    
    var selectedUser: User?
    var pageMenu : CAPSPageMenu?
    var viewControllerName: String?
    var selectedVideo: NSDictionary?
    var arrayOfVideoQuestions = [NSDictionary]()
    var isFollowed: Bool = false
    var loadCount = 0
    var tTimer: Timer?
    var type: String?
    var conversationId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue("0", forKey: "userConstraintValue")
        networksBtn.isSelected = true
        gradiantImageView.layer.shadowColor = UIColor.gray.cgColor
        gradiantImageView.layer.shadowOpacity = 1
        gradiantImageView.layer.shadowOffset = CGSize.zero
        gradiantImageView.layer.shadowRadius = 3
        
        //followerBtn.layer.borderWidth = 1.0
        //followerBtn.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        followerBtn.layer.borderColor = UIColor.black.cgColor
       // followingBtn.layer.borderWidth = 1.0
        //followingBtn.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        followingBtn.layer.borderColor = UIColor.black.cgColor
        followingBtn.layer.cornerRadius = 3.0
        followerBtn.layer.cornerRadius = 3.0
        
        //suserImageView.layer.borderWidth = 1.5
       // followBtn.layer.borderWidth = 1.0
        //followBtn.layer.borderColor = UIColor.black.cgColor
        followBtn.layer.cornerRadius = 5.0
        followBtn.layer.borderWidth = 1.0
        followBtn.layer.borderColor = UIColor.white.cgColor
       // openSocialProfileBtn.layer.borderWidth = 1.0
       // openSocialProfileBtn.layer.cornerRadius = 5.0
        conversationId = accountId!+"_"+(selectedUser?.id)!
        if accountId! == selectedUser?.id {
            followBtn.isHidden = true
            sendBtn.isHidden = true
            blockBtn.isHidden = true
            
        }
        if viewControllerName == "Home" {
           // backImageView.isHidden = true
        }
        loadCount = 1
        setAllDelegates()
       // dialogView.layer.borderWidth = 2.0
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle(rawValue: 1)!)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = coverImageView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        coverImageView.addSubview(blurEffectView)
        self.addViewControlers()
        self.pageMenu?.delegate = self
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.setAnimationsEnabled(false)
        if loadCount == 0 {
            setAllDelegates()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        loadCount = 0
        UIView.setAnimationsEnabled(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//        loadCount = 0
//        UIView.setAnimationsEnabled(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func addViewControlers() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "VisitorSocialViewController") as! VisitorSocialViewController
        vc.title = ""
        let vc1 = storyboard.instantiateViewController(withIdentifier: "VisitorVideoViewController") as! VisitorVideoViewController
        vc1.title = ""
        vc.selectedUser = selectedUser
        vc1.selectedUser = selectedUser
        var controllerArray : [UIViewController] = []
        controllerArray.append(vc)
        controllerArray.append(vc1)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(false),
            .menuItemSeparatorPercentageHeight(0.0),
            .scrollMenuBackgroundColor(UIColor.clear),
            .viewBackgroundColor(UIColor.clear),
            .menuHeight(50.0),
            .menuItemSeparatorWidth(20.0),
            .menuItemWidth(50.0),
            .centerMenuItems(true),
            .selectionIndicatorColor(UIColor.clear),
            .menuMargin(50.0),
            .addBottomMenuHairline(false)
        ]
        
        let rect = CGRect(origin: CGPoint(x: 2,y :topView.frame.height), size: CGSize(width: self.view.frame.width-4, height: self.view.frame.height-topView.frame.height-4))
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        
        pageMenu!.didMove(toParentViewController: self)
        self.restorationIdentifier = selectedUser?.id
        
        for view in self.pageMenu!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }

        
    }
    
    func setAllDelegates() {
        //f?.getUpdatedUserDelegate = self
        arrayOfVideoQuestions.removeAll()
       // QuestionsDBHandler.Instance.getFilteredVideoQuestionsDelegate = self
        UserDBHandler.Instance.isBeingFollowedDelegate = self
        ChatingDBHandler.Instance.getConvIdDelegate = self
        UserDBHandler.Instance.isBeingFollowed(accountId: accountId!, userId: (selectedUser?.id)!)
       // QuestionsDBHandler.Instance.getFilteredQuestionsWithUserId(userId: (selectedUser?.id)!)
        ChatingDBHandler.Instance.getConvId(userId: (selectedUser?.id)!, accountId: accountId!)
        
        self.followBtn.layer.cornerRadius = 3.0
        userImageView.roundImageView()
        makePolyGon()
        setUserValues()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getConvId(convId:String) {
        conversationId = convId
    }
    
    func isBeingFollowed(followed:Bool) {
        if followed {
            followBtn.setTitle("Following", for: UIControlState.normal)
        }
        else {
            followBtn.setTitle("FOLLOW", for: UIControlState.normal)
            if selectedUser?.accountType.lowercased() == "private" {
                privateProfileView.isHidden = false
                self.view.bringSubview(toFront: privateProfileView)
            }
        }
        isFollowed = followed
        
        if let blockedUsersList = UserDefaults.standard.value(forKey: BLOCKED_USERS) as? NSDictionary {
            for blockedId in blockedUsersList.allKeys {
                if selectedUser?.id == blockedId as? String {
                    followBtn.setTitle("Blocked", for: UIControlState.normal)
                    followBtn.isUserInteractionEnabled = false
                    followBtn.backgroundColor = UIColor.white
                    followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                }
            }
        }
    }
    
    func isRequestSent(request: Bool) {
        if request {
            followBtn.setTitle("Pending", for: UIControlState.normal)
        }
        
        if let blockedUsersList = UserDefaults.standard.value(forKey: BLOCKED_USERS) as? NSDictionary {
            for blockedId in blockedUsersList.allKeys {
                if selectedUser?.id == blockedId as? String {
                    followBtn.setTitle("Blocked", for: UIControlState.normal)
                    followBtn.isUserInteractionEnabled = false
                    followBtn.backgroundColor = UIColor.white
                    followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                }
            }
        }
    }
    
    func getFilteredVideoQuestions(questionsDict:NSMutableDictionary, key: String) {
        questionsDict["key"] = key
        arrayOfVideoQuestions.insert(questionsDict, at: 0)
        collectionView.reloadData()
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        print("hello")
        changeButtonColor(index: index)
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
     //   changeButtonColor(index: index)
    }
    

    
    func setUserValues() {
        
        userName.text = "@"+(selectedUser?.username)!
        userBio.text = selectedUser?.bio
        profession.text = selectedUser?.profession
        userEmail.text = selectedUser?.email
        noOfFollowers.text = selectedUser?.followers
        noOfFollowings.text = selectedUser?.following
        
        let profileString = selectedUser?.profile
        let profileUrl = URL(string: profileString!)
        userImageView.kf.setImage(with: profileUrl)
        largeProfileImageView.kf.setImage(with: profileUrl)
        coverImageView.kf.setImage(with: profileUrl)
        //coverImageView.alpha = 0.2
        
    
    }
    
    @IBAction func FollowAction(_ sender: UIButton) {
        
        if sender.titleLabel?.text?.lowercased() == "pending" {
            UserDBHandler.Instance.deleteFollowRequest(userId: accountId!, accountId: (selectedUser?.id)!)
            followBtn.setTitle("Follow", for: UIControlState.normal)
            isFollowed = false
            return
        }
        
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let activityString: String?
        let otherString: String?
        var otherFollowString: String?
        let commentString: String?
        if isFollowed {
            followBtn.setTitle("Follow", for: UIControlState.normal)
            noOfFollowers.text = String(Int(noOfFollowers.text!)! - 1)
            isFollowed = false
            activityString = "You just unfollowed "+userName.text!
            otherString = uniqueName+" just unfollowed "+userName.text!
            otherFollowString = uniqueName+" just unfollowed "+userName.text!
            commentString = uniqueName+" just unfollowed you"
        }
        else {
            if selectedUser?.accountType.lowercased() == "private" {
                commentString = "exit"
                followBtn.setTitle("Pending", for: UIControlState.normal)
                isFollowed = true
            }
            else {
                followBtn.setTitle("Following", for: UIControlState.normal)
                noOfFollowers.text = String(Int(noOfFollowers.text!)! + 1)
                isFollowed = true
                activityString = "You started following "+userName.text!
                otherString = uniqueName+" started following "+userName.text!
                otherFollowString = uniqueName+" started following "+userName.text!
                
                commentString = uniqueName+" started following you"
                if selectedUser?.device == "iphone" {
                    Common.sendPusNotification(userNumber: "", title: "", body: commentString!, fcmID: (selectedUser?.mFcmId)!)
                }
                else {
                    Common.sendPusNotificationToAndroid(userNumber: uniqueName, title: "a", body: commentString!, fcmID: (selectedUser?.mFcmId)!)
                }
            }
            
           
        }
        if commentString != "exit" {
            UserDBHandler.Instance.setOtherUserFollowingActivities(activityString: commentString!, userId: (selectedUser?.id)!, accountId: accountId!)
            selectedUser?.followers = noOfFollowers.text!
            UserDBHandler.Instance.setNoOfUserFollowing(userId: (selectedUser?.id)!, isFollowed: isFollowed, accountId: accountId!)
        }
        
       // UserDBHandler.Instance.setUserFollowingActivities(activityString: activityString!, questionId: "", answerId: "", otherString: otherString!, userId: (selectedUser?.id)!)
        
        
        UserDBHandler.Instance.setUserFollowing(userId: (selectedUser?.id)!, isFollowed: isFollowed, accountId: accountId!, accountType: (selectedUser?.accountType)!)
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
        let rect = polygonImgView.bounds
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
        polygonImgView.image = hexagon
        
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
    
    func onTimerEvent(timer: Timer) {
        let imgView = timer.userInfo as! UIImageView
        //imgView.isHidden = !imgView.isHidden
        if imgView.alpha == 0 {
            imgView.alpha = 1
        }
        else {
            imgView.alpha = 0
        }
    }
    
    func showDialog(lNetwork: SocialNetworks, isAnimation: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        tTimer?.invalidate()
        blackViewLayer.isHidden = false
        self.view.bringSubview(toFront: blackViewLayer)
        if userFullName.text != "ID not displayed" {
            openSocialProfileBtn.isHidden = false
        }
        
        if isAnimation {
             tTimer =  Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(onTimerEvent(timer:)), userInfo: whatsNewImgView, repeats: true)
            whatsNewImgView.image = UIImage(named: "whatsNewRed.png")
        }
        else {
            whatsNewImgView.isHidden = false
            whatsNewImgView.image = UIImage(named: "whatsNewBlack.png")
            tTimer?.invalidate()
        }
        
        if lNetwork.networkProfileLink.characters.count < 1 {
//            openSocialProfileBtn.isEnabled = false
//            openSocialProfileBtn.isHighlighted = false
            
        }
        else {
            //openSocialProfileBtn.isEnabled = true
        }
        
        if lNetwork.networkProfileLink2.characters.count > 0 {
            secondProfileLabel.text = lNetwork.networkProfileLink2
            secondProfileLabelView.isHidden = false
            secondLabelViewHeight.constant = 50
        }
        else {
            secondProfileLabelView.isHidden = true
            secondLabelViewHeight.constant = 0
        }
        
        if lNetwork.networkProfileLink3.characters.count > 0 {
            thirdProfileLabel.text = lNetwork.networkProfileLink3
            thirdLabelView.isHidden = false
            thirdLabelViewHeight.constant = 50
        }
        else {
            thirdLabelView.isHidden = true
            thirdLabelViewHeight.constant = 0
        }
        
        dialogViewHeight.constant = 306+thirdLabelViewHeight.constant+secondLabelViewHeight.constant
        
        selectedNetworkName.text = lNetwork.networkTitle
        userFullName.text = lNetwork.networkProfileLink
       // userSocialInfo.text = lNetwork.additionalInfo1
        userSocialInfoTextView.text = lNetwork.additionalInfo1
      //  userSocialUserName.text = lNetwork.networkProfileLink
        
        let urlString = lNetwork.networkTitle.lowercased()+".png"
        selectedSocialImage.image = UIImage(named: urlString)
        
        dialogView.isHidden = false
        self.view.bringSubview(toFront: dialogView)
        
        
        if ((lNetwork.networkProfileLink.characters.count) < 1) {
            userFullName.text = "ID not displayed"
        }
        
        if (lNetwork.additionalInfo1)  == nil || ((lNetwork.additionalInfo1?.characters.count)! < 1){
           // userSocialInfo.text = "No new updates"
            userSocialInfoTextView.text = "No new updates"
        }
        
        if selectedNetworkName.text?.lowercased() == "whatsapp" || selectedNetworkName.text?.lowercased() == "viber" || selectedNetworkName.text?.lowercased() == "line" || selectedNetworkName.text?.lowercased() == "wechat" || selectedNetworkName.text?.lowercased() == "phone" {
            openSocialProfileBtn.isSelected = true
        }
        else {
            openSocialProfileBtn.isSelected = false
        }
        
        if selectedNetworkName.text?.lowercased() == "phone" {
            openSocialProfileBtn.isSelected = true
        }
        else {
            openSocialProfileBtn.isSelected = false
        }
        
        if selectedNetworkName.text?.lowercased() == "email" || selectedNetworkName.text?.lowercased() == "hotmail" || selectedNetworkName.text?.lowercased() == "outlook" || selectedNetworkName.text?.lowercased() == "gmail" || selectedNetworkName.text?.lowercased() == "yahoo" {
            idBox.image = UIImage(named: "Email Address1.png")
            statusBox.image = UIImage(named: "status_box_w_label.png")
            idBox.isHidden = false
            userFullName.isHidden = false
            whatsNewImgView.isHidden = false
            statusBoxWhtieView.isHidden = false
            copyBtn.isHidden = false
            statusBoundryTopConstraint.constant = 13
            userInfoHeight.constant = 95
            statusBoxHeight.constant = 115
            userInfoTopConstraint.constant = 17
            statusBoxRightSpace.constant = 24
            userInfoRightSpace.constant = 70
            
        }
        else if selectedNetworkName.text?.lowercased() == "website" {
            idBox.image = UIImage(named: "Website.png")
            statusBox.image = UIImage(named: "status_box_w_label.png")
            idBox.isHidden = false
            userFullName.isHidden = false
            whatsNewImgView.isHidden = false
            statusBoxWhtieView.isHidden = false
            copyBtn.isHidden = false
            statusBoundryTopConstraint.constant = 13
            userInfoHeight.constant = 95
            statusBoxHeight.constant = 115
            userInfoTopConstraint.constant = 17
            statusBoxRightSpace.constant = 24
            userInfoRightSpace.constant = 70
            openSocialProfileBtn.isHidden = false
            
        }
        else if selectedNetworkName.text?.lowercased() == "about me" {
            statusBox.image = UIImage(named: "AboutMeBlack.png")
            idBox.image = UIImage(named: "id_box_w_label.png")
            idBox.isHidden = true
            userFullName.isHidden = true
            whatsNewImgView.isHidden = true
            statusBoxWhtieView.isHidden = true
            copyBtn.isHidden = true
            statusBoundryTopConstraint.constant = -40
            userInfoHeight.constant = 120
            statusBoxHeight.constant = 170
            userInfoTopConstraint.constant = -20
            statusBoxRightSpace.constant = -15
            userInfoRightSpace.constant = 30
            openSocialProfileBtn.isHidden = true
            
            
            
        }
        else {
            idBox.image = UIImage(named: "id_box_w_label.png")
            statusBox.image = UIImage(named: "status_box_w_label.png")
            idBox.isHidden = false
            userFullName.isHidden = false
            whatsNewImgView.isHidden = false
            statusBoxWhtieView.isHidden = false
            copyBtn.isHidden = false
            statusBoundryTopConstraint.constant = 13
            userInfoHeight.constant = 95
            statusBoxHeight.constant = 115
            userInfoTopConstraint.constant = 17
            statusBoxRightSpace.constant = 24
            userInfoRightSpace.constant = 70
            openSocialProfileBtn.isHidden = false
        }
        
        if userFullName.text == "ID not displayed" {
            openSocialProfileBtn.isHidden = true
        }

        
    }
    
    
    @IBAction func BlockUser(_ sender: UIButton) {
        UIView.setAnimationsEnabled(true)
        self.openActionSheet()
    }
    
    func blockSelectedUser() {
        UserDBHandler.Instance.blockSelectedUser(userId: (selectedUser?.id)!)
        if isFollowed {
            followBtn.setTitle("Follow", for: UIControlState.normal)
            noOfFollowers.text = String(Int(noOfFollowers.text!)! - 1)
            isFollowed = false
            UserDBHandler.Instance.setNoOfUserFollowing(userId: (selectedUser?.id)!, isFollowed: isFollowed, accountId: accountId!)
            UserDBHandler.Instance.setUserFollowing(userId: (selectedUser?.id)!, isFollowed: isFollowed, accountId: accountId!, accountType: (selectedUser?.accountType)!)
        }
        followBtn.setTitle("Blocked", for: UIControlState.normal)
        followBtn.isUserInteractionEnabled = false
        followBtn.backgroundColor = UIColor.white
        followBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
    }
    
    func unBlockSelectedUser() {
        UserDBHandler.Instance.unBlockSelectedUser(userId: (selectedUser?.id)!)
        followBtn.setTitle("Follow", for: UIControlState.normal)
        followBtn.isUserInteractionEnabled = true
        followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        followBtn.backgroundColor = UIColor.init(red: 206/255.0, green: 156.0/255.0, blue: 150/255.0, alpha: 1.0)
        
    }
    
    func openActionSheet() {
        var sheetTitle = "Block this User"
        var sheetMessage = "Are you sure you want to Block this User?"
        var actionTitle = "Block User"
        var toastTitle = "User has been blocked"
        var isBlocked: Bool = false
        if let blockedUsersList = UserDefaults.standard.value(forKey: BLOCKED_USERS) as? NSDictionary {
            for blockedId in blockedUsersList.allKeys {
                if selectedUser?.id == blockedId as? String {
                    sheetTitle = "UnBlock this user"
                    sheetMessage = "Are you sure you want to UnBlock this User?"
                    actionTitle = "UnBlock User"
                    toastTitle = "User has been UnBlocked"
                    isBlocked = true
                }
            }
        }
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: sheetTitle, message: sheetMessage, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
            UIView.setAnimationsEnabled(false)
        }
        actionSheetController.addAction(cancelAction)
        
        let blockUser: UIAlertAction = UIAlertAction(title: actionTitle, style: .default) { action -> Void in
            
            if isBlocked {
                self.unBlockSelectedUser()
            }
            else {
                self.blockSelectedUser()
            }
            UIView.setAnimationsEnabled(false)
            self.view.makeToast(toastTitle, duration: 2.0, position: .top)
        }
        actionSheetController.addAction(blockUser)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func FollowersAction(_ sender: UIButton) {
        type = USER_FOLLOWERS
        self.performSegue(withIdentifier: "goToFollowings", sender: self)
    }
    
    @IBAction func FollowingAction(_ sender: UIButton) {
        type = USER_FOLLOWING
        self.performSegue(withIdentifier: "goToFollowings", sender: self)
    }
    
    @IBAction func ChatAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToChat", sender: self)
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
//        if backImageView.isHidden {
//            return
//        }
        if viewControllerName == "Home" {
            
            if let navigationController = self.navigationController{
                if navigationController.viewControllers.first != self{
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
            
            if self.presentingViewController == nil {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }

        }
        if viewControllerName == "rootViewController" {
            UserDefaults.standard.setValue("0", forKey: "constraintValue")
            self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
            
        }
        else {
            if let navigationController = self.navigationController{
                if navigationController.viewControllers.first != self{
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
            
            if self.presentingViewController == nil {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }

        }
        
    }
    
    
    @IBAction func HideLargeView(_ sender: UIButton) {
        largeImageView.isHidden = true
    }
    
    @IBAction func ShowLargeProfile(_ sender: UIButton) {
        largeImageView.isHidden = false
        self.view.bringSubview(toFront: largeImageView)
    }
    
    @IBAction func HideDialogView(_ sender: UIButton) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.dialogView.isHidden = true
        blackViewLayer.isHidden = true
    }
    
    @IBAction func CopyText(_ sender: UIButton) {
        if userFullName.text == "ID not displayed" {
            self.view.makeToast("User has not provided username")
            return
        }
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let someText = userFullName.text
        UIPasteboard.general.string = someText
        self.view.makeToast("Link copied")
    }
    
    
    
    
    
    @IBAction func OpenProfile(_ sender: UIButton) {
        if userFullName.text == "ID not displayed" {
            self.view.makeToast("There's an issue with user's details Inbox user", duration: 2.0, position: .top)
            return
        }
        if (userFullName.text?.contains(" "))! {
            self.view.makeToast("There's an issue with user's details Inbox user", duration: 2.0, position: .top)
            return
        }
        
        if selectedNetworkName.text?.lowercased() == "facebook" {
            let fbAppUrl = "fb://profile?id="+userFullName.text!
            var fbWebUrl = "https://www.facebook.com/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                fbWebUrl = userFullName.text!
            }
            UIApplication.tryURL([fbAppUrl, fbWebUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "instagram" {
            //let instAppUrl = "instagram://user?username="+userFullName.text!
            var instaWebUrl = "https://www.instagram.com/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                instaWebUrl = userFullName.text!
            }
            UIApplication.tryURL([instaWebUrl, instaWebUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "twitter" {
            let twitterUrl = "twitter://user?screen_name="+userFullName.text!
            var twitterWebUrl = "https://www.twitter.com/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                twitterWebUrl = userFullName.text!
            }
            UIApplication.tryURL([twitterUrl, twitterWebUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "pinterest" {
            //let pinUrl = "www.pinterest.com"+userFullName.text!
            var pinWebUrl = "https://www.pinterest.com/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                pinWebUrl = userFullName.text!
            }
            
            UIApplication.tryURL([pinWebUrl, pinWebUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "snapchat" {
            var snapUrl = "https://www.snapchat.com/add/"+userFullName.text!
           // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                snapUrl = userFullName.text!
            }
            UIApplication.tryURL([snapUrl, snapUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "viber" {
            var vibUrl = "viber://chat:"+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                vibUrl = userFullName.text!
            }
            UIApplication.tryURL([vibUrl, vibUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "whatsapp" {
            var appUrl = "https://api.whatsapp.com/send?phone="+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                appUrl = userFullName.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "google+" {
            var appUrl = "https://plus.google.com/"+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                appUrl = userFullName.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "linkedin" {
            var appUrl = "https://www.linkedin.com/in/"+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                appUrl = userFullName.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "youtube" {
            let appUrl = userFullName.text
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            UIApplication.tryURL([appUrl!, appUrl!])
        }
        else if selectedNetworkName.text?.lowercased() == "vk" {
            var appUrl = "https://www.vk.com/"+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                appUrl = userFullName.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "flicker" {
            var appUrl = "https://www.flicker.com/photos/"+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                appUrl = userFullName.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "soundcloud" {
            var appUrl = "https://soundcloud.com/"+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                appUrl = userFullName.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "skype" {
            var appUrl = "https://join.skype.com/invite"+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                appUrl = userFullName.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "telegram" {
            var appUrl = "http://www.telegram.me/"+userFullName.text!
            // let snapWebUrl = "https://www.snapchat.com/add/"+userFullName.text!
            if (userFullName.text?.contains(".com"))! {
                appUrl = userFullName.text!
            }
            UIApplication.tryURL([appUrl, appUrl])
        }
        else if selectedNetworkName.text?.lowercased() == "gmail" || selectedNetworkName.text?.lowercased() == "email" || selectedNetworkName.text?.lowercased() == "hotmail" || selectedNetworkName.text?.lowercased() == "yahoo" {
            
            let email = userFullName.text!
            if let url = NSURL(string: "mailto:\(email)") {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
            
        else if selectedNetworkName.text?.lowercased() == "phone" {
            guard let number = URL(string: "tel://" + userFullName.text!) else { return }
            UIApplication.shared.open(number)
        }
            
        else if selectedNetworkName.text?.lowercased() == "messenger" {
            let userID = userFullName.text
            let urlStr = String(format: "fb-messenger://user-thread/%d", userID!)
            UIApplication.tryURL([urlStr, urlStr])
        }
            
        else {
            let appUrl = userFullName.text!
            UIApplication.tryURL([appUrl, appUrl])
            
            if (userFullName.text?.lowercased().contains(".com"))! {
                var appUrl = userFullName.text!
                if (userFullName.text?.lowercased().contains("https://"))! {
                    appUrl = userFullName.text!
                }
                else if (userFullName.text?.lowercased().contains(".com"))! && !(userFullName.text?.lowercased().contains("www"))! {
                    appUrl = "https://www."+userFullName.text!
                }
                else if (userFullName.text?.lowercased().contains("www"))! {
                    appUrl = "https://"+userFullName.text!
                }
                UIApplication.tryURL([appUrl, appUrl])
            }
            else {
                self.view.makeToast("There's an issue with user's details. Inbox user", duration: 2.0, position: .center)
            }
        }

        
        
//        let fbAppUrl = "fb://profile?id="+"sami.aftab.3"
//        let fbWebUrl = "https://www.facebook.com/831831923611308"
//
//        let instAppUrl = "instagram://user?username=ijaz0066"
//        let twitterUrl = "twitter://user?screen_name=ijazahmad166"
//
//        UIApplication.tryURL([fbAppUrl, fbWebUrl])
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayVideoController" {//goToFollowings
            let nextScene = segue.destination as! VideoViewController
            nextScene.selectedQuestion = selectedVideo as? NSMutableDictionary
        }
        else if segue.identifier == "goToFollowings" {
                let nextScene = segue.destination as! FollowingsViewController
            nextScene.selectedUser = selectedUser
            nextScene.type = type
        }
        else if segue.identifier == "goToChat" {
            let nextScene = segue.destination as! ChatViewController
            nextScene.selectedUser = selectedUser
            nextScene.conversationId = conversationId
        }
    }
    
    func changeButtonColor(index: Int) {
        if index == 0 {
            smcImageView.image = UIImage(named: "SMC1.png")
            postFeedImageView.image = UIImage(named: "post_feed_icon.png")
            networksBtn.isSelected = true
            postsBtn.isSelected = false

        }
        else if index == 1 {
            networksBtn.isSelected = false
            postsBtn.isSelected = true
            smcImageView.image = UIImage(named: "SMC.png")
            postFeedImageView.image = UIImage(named: "post_feed_icon1.png")

        }
    }

    
}

extension UserProfileViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        questionImgView.kf.setImage(with: imgUrl)
        let localDate = Date(timeIntervalSince1970: (TimeInterval((serverDate?.intValue)! / 1000)))
        print(localDate)
        
            
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 3 {
            let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
            let screenWidth: CGFloat = UIScreen.main.bounds.size.width-4
            
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


extension UIApplication {
    class func tryURL(_ urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.open(URL(string: url)!, options: [:], completionHandler: nil)
                
                return
                
            }
        }
    }
}
