//
//  PostbokPreviewVC.swift
//  SMC
//
//  Created by JuicePhactree on 8/20/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

//
//  PlayVideoViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/17/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import VGPlayer
import SnapKit
import Toast_Swift
import AssetsLibrary
import ImageScrollView
//import WSTagsField

class PostbokPreviewVC: UIViewController {
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var videoTitle: UITextField!
    @IBOutlet weak var shortDescription: UITextView!
    @IBOutlet weak var navigationTopSpace: NSLayoutConstraint!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopSpace: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var pinterestCheckBtn: UIButton!
    
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var extraView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var zoomImageView: ImageScrollView!
    @IBOutlet weak var pinterestLabel: UILabel!
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var largeView: UIView!
    @IBOutlet weak var instagramBtn: UIButton!
    
    @IBOutlet weak var enlargeBtn: UIButton!
    @IBOutlet weak var bottomLineSpace: NSLayoutConstraint!
    
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var twitterCheckBtn: UIButton!
    @IBOutlet weak var linkedinCheckBtn: UIButton!
    
    @IBOutlet fileprivate weak var tagsView: UIView!
    fileprivate let tagsField = WSTagsField()
    
    var capturedImage: UIImage?
    var postbokObject: Postbok?
    let lPublish = PublishPost()
    var socialMediaCount: Int = 0
    var instaCheck: Bool?
    var downloadedFilePath: String?
//    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "8637eehruyk1uk", clientSecret: "ibhlPr8BhP4DyyEi", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress", "w_share"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"))
    
    var player : VGPlayer = {
        let playeView = VGPlayerView()
        let playe = VGPlayer(playerView: playeView)
        return playe
    }()
    var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadVideoFromUrl()
        instaCheck = false
        lPublish.postedOn = " "
        if capturedImage == nil {
            twitterLabel.textColor = UIColor.lightGray
            pinterestLabel.textColor = UIColor.lightGray
        }
        else {
            enlargeBtn.isHidden = false
            largeImageView.image = capturedImage!
            zoomImageView.display(image: capturedImage!)
            
        }
        self.lPublish.postedOn = " "
      //  UserDefaults.standard.setValue(false, forKey: PINTEREST_LOGIN)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        extraView.layer.shadowColor = UIColor.darkGray.cgColor
        extraView.layer.shadowOpacity = 1.0
        extraView.layer.shadowOffset = CGSize(width: 0, height: 1)
        extraView.layer.shadowRadius = 1
        
        uploadBtn.layer.cornerRadius = 5.0
       // uploadBtn.layer.borderWidth = 1.0
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (capturedImage != nil) {
            imgView.image = capturedImage
            playerView.isHidden = true
            previewLabel.text = "Preview"
            return
        }
        previewLabel.text = "Preview"
        DispatchQueue.main.async {
            self.playVideoWithUrl()
            self.player.pause()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    func keyboardWillShow(_ notification: NSNotification){
        //        navigationTopSpace.constant = -150
        //        self.player.displayView.snp.makeConstraints { [weak self] (make) in
        //            guard let strongSelf = self else { return }
        //            make.top.equalTo(-100)
        //            make.left.equalTo(strongSelf.view.snp.left)
        //            make.right.equalTo(strongSelf.view.snp.right)
        //            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(1) // you can 9.0/16.0
        //        }
        
        var contentInsets:UIEdgeInsets
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, 80, 0.0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        self.scrollToLastRow()
        
    }
    
    
    
    func keyboardWillHide(_ notification: NSNotification){
        var contentInsets:UIEdgeInsets
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        
    }
    
    func scrollToLastRow() {
        UIView.setAnimationsEnabled(false)
        // let indexPath = NSIndexPath(forRow: messages.count - 1, section: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        UIView.setAnimationsEnabled(true)
        
    }
    
    func playVideoWithUrl() {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let videoDataPath = documentsPath + "/" + "WATCH.mp4"
        let videoUrl = postbokObject?.mediaPath
        let ff = URL(string: videoUrl!)
        let tempUrl:NSURL = NSURL(fileURLWithPath: videoUrl!)
        
        self.player.replaceVideo(ff!)
        player.displayView.closeButton.isHidden = true
        self.topView.addSubview(self.player.displayView)
        
        self.player.play()
        self.player.backgroundMode = .suspend
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(0)
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(0.685) // you can 9.0/16.0
        }
    }
    
    func videoPreviewUIImage(moviePath: URL) -> UIImage? {
        let asset = AVURLAsset(url: moviePath)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        if let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) {
            return UIImage(cgImage: imageRef)
        } else {
            return nil
        }
    }



    @IBAction func GoBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SendVideo(_ sender: UIButton) {
        
        if instaCheck == true {
            instagramPost()
        }
        
        if twitterCheckBtn.isSelected {
            postToTwitter()
        }
        
        if pinterestCheckBtn.isSelected {
            postToPinterest()
        }
        
//        if socialMediaCount > 0 {
//            uploadDataToPublishFirebase()
//        }
        uploadDataToPublishFirebase()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let videoDataPath = documentsPath + "/" + "WATCH.mp4"
        let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
        //showLoadingIndicater()
        
    }
    
    func downloadVideoFromUrl() {
        let videoImageUrl = postbokObject?.mediaPath
        
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoImageUrl!),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                self.downloadedFilePath = "\(documentsPath)/tempFile.MOV"
                DispatchQueue.main.async(execute: { () -> Void in
                    urlData.write(toFile: self.downloadedFilePath!, atomically: true)
                })
                print("download completed!")
            }
        }
    }
    
    func uploadDataToPublishFirebase() {
        let uniqueId = DBProvider.Instance.publishPostRef.childByAutoId().key
       // lPublish.mediaPath = (postbokObject?.mediaPath)!
        lPublish.postText = ""
        lPublish.timeStamp = String(Date().millisecondsSince1970)
        lPublish.postId = uniqueId
        lPublish.scheduledOn = ""
        
        if capturedImage == nil {
            lPublish.mediaType = "video"
            lPublish.mediaPath = (postbokObject?.thumbImage)!
        }
        else {
            lPublish.mediaType = "image"
            lPublish.mediaPath = (postbokObject?.mediaPath)!
        }
        
        if socialMediaCount > 0 {
            
        }
        
        if pinterestCheckBtn.isSelected || twitterCheckBtn.isSelected || instagramBtn.isSelected {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                PublishPostDBHandler.Instance.adPublishedMedia(publishDict: self.lPublish)
            })
        }
        
        if !instaCheck! {
            self.performSegue(withIdentifier: "goToActivity", sender: self)
        }
        
    }
    
    func postToTwitter() {
        var title = String()
        var message = String()
        
        //        let filepath = Bundle.main.path(forResource: "temp", ofType: "mp4")
        //        let vidData = NSData(contentsOfFile: filepath!)
        //        let dd = Data(referencing: vidData!)
        
        
        let data = UIImageJPEGRepresentation(capturedImage!, 0.2)
        var textToTweet: String?
        if videoTitle.text == "" {
            textToTweet = " "
        }
        else {
            textToTweet = videoTitle.text
        }
        
        
        let ll = FHSTwitterEngine.shared().postTweet(textToTweet, withImageData: data)
        
        if(ll != nil)
        {
            title = "Error"
            message = "error occured while poting"
        }
        else
        {
            title = "Success"
            message = "Successfully posted."
            socialMediaCount = socialMediaCount+1
            lPublish.postedOn = lPublish.postedOn!+"twitter,"
            lPublish.twitter = "yes"
           // self.uploadDataToPublishFirebase()
        }
    }
    
    @IBAction func OpenCalender(_ sender: UIButton) {
        //self.calenderView.isHidden = false
        self.informativeAlert(msg: "This feature is under maintenance")
    }
    
    @IBAction func ClosePickerAction(_ sender: UIButton) {
        self.calenderView.isHidden = true
    }
    
    
    @IBAction func CheckBoxAction(_ sender: UIButton) {
        if sender.tag == 0 {
            return
        }
        if sender.tag == 2 {
            
            if capturedImage == nil {
                self.informativeAlert(msg: "This feature is under maintenance")
                return
            }
            
            if !sender.isSelected {
                if let isLogin = UserDefaults.standard.value(forKey: TWITTER_LOGIN) as? Bool {
                    if isLogin {
                        sender.isSelected = !sender.isSelected
                    }
                    else {
                        twitterLogin()
                        
                    }
                }
                else {
                    twitterLogin()
                }
            }
            else {
                sender.isSelected = !sender.isSelected
            }
            
        }
        else if sender.tag == 4 {
            self.informativeAlert(msg: "This feature is undermaintenance")
            return
            
            if !sender.isSelected {
                if let isLogin = UserDefaults.standard.value(forKey: LINKEDIN_LOGIN) as? Bool {
                    if isLogin {
                        sender.isSelected = !sender.isSelected
                    }
                    else {
                        linkedInlogin()
                    }
                }
                else {
//                    if LISDKSessionManager.hasValidSession() {
//                        postToLinkedin()
//                    }
//                    else {
//                        linkedInlogin()
//                    }
                    
                    
                }
            }
            else {
                sender.isSelected = !sender.isSelected
            }
            
        }
        else if sender.tag == 5 {
            
            if capturedImage == nil {
                self.informativeAlert(msg: "Pinterest does not allow to post videos")
                return
            }
            
            if !sender.isSelected {
                if let isLogin = UserDefaults.standard.value(forKey: PINTEREST_LOGIN) as? Bool {
                    if isLogin {
                        sender.isSelected = !sender.isSelected
                    }
                    else {
                        pinterestLogin()
                        
                    }
                }
                else {
                    pinterestLogin()
                }
            }
        }
        else if sender.tag == 3 {
            sender.isSelected = !sender.isSelected
            instaCheck = !instaCheck!
        }
        else {
            self.informativeAlert(msg: "This feature is under maintenance")
        }
        
        //sender.isSelected = !sender.isSelected
    }
    
    @IBAction func EnlargePictureAction(_ sender: UIButton) {
        largeView.isHidden = false
    }
    
    
    @IBAction func HideLargeImageView(_ sender: UIButton) {
        largeView.isHidden = true
    }
    
    
    func twitterLogin() {
        let loginController = FHSTwitterEngine .shared() .loginController { (success) -> Void in
            UserDefaults.standard.set(true, forKey: TWITTER_LOGIN)
            
            } as UIViewController
        self .present(loginController, animated: true, completion: nil)
    }
    
    func pinterestLogin() {
        
       let pintUrl = URL(string: "pinterest://")
        if UIApplication.shared.canOpenURL(pintUrl!) {
            
        }
        else {
            self.view.makeToast("Pinterest is not installed", duration: 3.0, position: .bottom)
            return
        }
        
        PDKClient.sharedInstance().authenticate(withPermissions: [PDKClientWritePublicPermissions, PDKClientReadPublicPermissions, PDKClientReadRelationshipsPermissions, PDKClientWriteRelationshipsPermissions], withSuccess: { (response) in
            print(PDKClient.sharedInstance().oauthToken)
            UserDefaults.standard.set(true, forKey: PINTEREST_LOGIN)
            
            let randomNum:UInt32 = arc4random_uniform(1000)
            let randString:String = String(randomNum)
            let boardName = "Testing"+randString
            
            PDKClient.sharedInstance().createBoard(boardName, boardDescription: "this is testing board", withSuccess: { (responseObject) in
                let boardid = responseObject?.board().identifier
                UserDefaults.standard.setValue(boardid, forKey: "boardId")
            }, andFailure: { (error) in
                print(error?.localizedDescription)
            })
            
            
        }) { (errorr) in
            print(errorr.debugDescription)
        }
    }
    
    func linkedInlogin() {
//        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
//                print(lsToken)
//
//            }, error: { [unowned self] (error) -> Void in
//                print("hi")
//
//            }, cancel: { [unowned self] () -> Void in
//                print("hioo")
//        })
    }
    
    func postToLinkedin() {
        
//        let urlString = "https://api.linkedin.com/v1/people/~/shares"
//        //let urlString = "https://www.google.com/"
//        let payLoad = "{\"comment\":\"Check out developer.linkedin.com! http://linkd.in/1FC2PyG\",\"visibility\":{\"code\":\"anyone\"}}"
//
//        let permissions = ["r_basicprofile", "r_emailaddress", "w_share"]
//        LISDKSessionManager.createSession(withAuth: permissions, state: nil, showGoToAppStoreDialog: true, successBlock: { (success) in
//            print("permitted")
//
//            if LISDKSessionManager.hasValidSession() {
//                let dataa = UIImageJPEGRepresentation(self.capturedImage!, 0.2)!
//
//                LISDKAPIHelper.sharedInstance().postRequest(urlString, body: dataa, success: { (response) in
//                    print("aa")
//                }, error: { (error) in
//                    print("aaa")
//                })
//
//
//            }
//        }) { (failure) in
//            print("not permitted")
//        }
    }
    
    func postToPinterest() {
        DispatchQueue.main.async {
        PDKClient.sharedInstance().silentlyAuthenticate(success: { (response) in
            print("successed")//24206985436384914
            let boardId = UserDefaults.standard.value(forKey: "boardId")
            
            if boardId == nil {
                let randomNum:UInt32 = arc4random_uniform(1000)
                let randString:String = String(randomNum)
                let boardName = "Testing"+randString
                PDKClient.sharedInstance().createBoard(boardName, boardDescription: "this is testing board", withSuccess: { (responseObject) in
                    let boardid = responseObject?.board().identifier
                    UserDefaults.standard.setValue(boardid, forKey: "boardId")
                    let linkk = URL(string: "https://images.pexels.com")
                    PDKClient.sharedInstance().createPin(with: self.capturedImage, link: linkk, onBoard: boardId as! String, description: "my testing pin", progress: { (uploading) in
                        self.socialMediaCount = self.socialMediaCount+1
                        self.lPublish.postedOn = self.lPublish.postedOn!+"pinterest,"
                        self.lPublish.pinterest = "yes"
                        
                    }, withSuccess: { (success) in
                        
                        
                    }) { (error) in
                        
                    }
                }, andFailure: { (error) in
                    print(error?.localizedDescription)
                })
            }
            else {
                let linkk = URL(string: "https://images.pexels.com")
                PDKClient.sharedInstance().createPin(with: self.capturedImage, link: linkk, onBoard: boardId as! String, description: "my testing pin", progress: { (uploading) in
                    self.socialMediaCount = self.socialMediaCount+1
                    self.lPublish.postedOn = self.lPublish.postedOn!+"pinterest,"
                    self.lPublish.pinterest = "yes"
                    
                }, withSuccess: { (success) in
                    
                    
                }) { (error) in
                    
                }
            }
            
            

        }) { (error) in
            print("failed")
        }
        }

        
    }
    
    func shareMediaActivity(shareImage:UIImage?, shareVideo: URL?){
        
        var objectsToShare = [AnyObject]()
        if let shareVideo = shareVideo{
            objectsToShare.append(shareVideo as AnyObject)
        }
        
        if let sImage = shareImage{
            //objectsToShare.append(shareTextObj as AnyObject)
            objectsToShare.append(sImage as AnyObject)
        }
        
        //objectsToShare.append(shareImage as AnyObject)
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func shareVideo() {
        //let videoURL = URL(fileURLWithPath: self.downloadedFilePath!)
        let vUrl = URL(fileURLWithPath: self.downloadedFilePath!) as URL
        
        let activityItems: [Any] = [vUrl]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = view
        activityController.popoverPresentationController?.sourceRect = view.frame
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    func shareImage() {
        let activityItems: [Any] = [capturedImage]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = view
        activityController.popoverPresentationController?.sourceRect = view.frame
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    func instagramPost() {
       /// let fff = UIImage(named: "mari.jpg")
        let library = ALAssetsLibrary()
        if self.capturedImage == nil {
            let vUrl = URL(fileURLWithPath: self.downloadedFilePath!) as URL
           // let vUrl = URL(string: self.downloadedFilePath!) as! URL
            library.writeVideoAtPath(toSavedPhotosAlbum: vUrl) { (url, error) in
                if let url = url {
                    DispatchQueue.main.async {
                        let path = url.absoluteString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                        let instagram = URL(string: "instagram://library?AssetPath="+path!)
                        self.lPublish.instagram = "yes"
                        if UIApplication.shared.canOpenURL(instagram!) {
                           UIApplication.shared.open(instagram!)
                        }
                        else {
                            self.view.makeToast("Instagram is not installed", duration: 3.0, position: .bottom)
                        }
                        
                        //UIApplication.shared.open(instagram!)
                    }
                }
            }
        }
        else {
            let img = capturedImage?.imageRotatedByDegrees(degrees: 360.0)
            library.writeImage(toSavedPhotosAlbum: img?.cgImage, metadata: nil) { (url, error) in
                if let url = url {
                    DispatchQueue.main.async {
                        let path = url.absoluteString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                        let instagram = URL(string: "instagram://library?AssetPath="+path!)
                        self.lPublish.instagram = "yes"
                        
                        
                        if self.pinterestCheckBtn.isSelected || self.twitterCheckBtn.isSelected {
                            self.instaAlert(msg: "Post on instagram Now. Content has been posted on other ", instaUrl: instagram!)
                        }
                        else {
                            if UIApplication.shared.canOpenURL(instagram!) {
                                UIApplication.shared.open(instagram!)
                            }
                            else {
                                self.view.makeToast("Instagram is not installed", duration: 3.0, position: .bottom)
                            }
                            //UIApplication.shared.open(instagram!)
                        }
                        // UIApplication.shared.open(instagram!)
                    }
                }
            }
            
        }
    }
    
    func linkedinLogin() {
        //        let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "77tn2ar7gq6lgv", clientSecret: "iqkDGYpWdhf7WKzA", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"))
        //
        //        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
        //
        //            self.writeConsoleLine("Login success lsToken: \(lsToken)")
        //            UserDefaults.standard.set(true, forKey: LINKEDIN_LOGIN)
        //            }, error: { [unowned self] (error) -> Void in
        //
        //                self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
        //            }, cancel: { [unowned self] () -> Void in
        //
        //                self.writeConsoleLine("User Cancelled!")
        //        })
    }
    
    
    @IBAction func ShareMedia(_ sender: UIButton) {
        if postbokObject?.mediaType == "video" {
            //let fUrl = URL(fileURLWithPath: self.downloadedFilePath!) as URL
           // shareMediaActivity(shareImage: nil, shareVideo: fUrl)
            //shareVideo()
        }
        else {
            //shareMediaActivity(shareImage: capturedImage, shareVideo: nil)
            shareImage()
        }
        
    }
    
    func informativeAlert(msg: String) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { (UIAlertAction) in
            //alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func instaAlert(msg: String, instaUrl: URL) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { (UIAlertAction) in
            if UIApplication.shared.canOpenURL(instaUrl) {
               UIApplication.shared.open(instaUrl)
            }
            else {
                self.view.makeToast("Instagram is not installed", duration: 3.0, position: .bottom)
            }
            
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func showLoadingIndicater() {
        //self.view.isUserInteractionEnabled = false
        //  self.uploadBtn.isUserInteractionEnabled = false
        
        self.view.alpha = 0.5
        let screenSize: CGRect = UIScreen.main.bounds
        let indicatorWidth = screenSize.width
        let indicatorHeight = screenSize.height
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: indicatorWidth/2, y: indicatorHeight/2, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator?.startAnimating()
        self.view.addSubview(loadingIndicator!)
    }
    
    func stopLoadingIndicator() {
        //self.view.isUserInteractionEnabled = true
        self.uploadBtn.isUserInteractionEnabled = true
        loadingIndicator?.stopAnimating()
        self.loadingIndicator?.removeFromSuperview()
        self.view.alpha = 1.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension PostbokPreviewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 667
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        return topView
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }
    
}

extension PostbokPreviewVC: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}

extension PostbokPreviewVC: VGPlayerViewDelegate {
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        shortDescription.resignFirstResponder()
        videoTitle.resignFirstResponder()
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
    }
}

extension PostbokPreviewVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        }
        else {
            placeHolderLabel.isHidden = true
        }
    }
}

extension PostbokPreviewVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        videoTitle.resignFirstResponder()
        return true
    }
}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }}




