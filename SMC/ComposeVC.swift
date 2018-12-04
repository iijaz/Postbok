//
//  ComposeVC.swift
//  SMC
//
//  Created by JuicePhactree on 8/29/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import VGPlayer
import SnapKit
import Toast_Swift
import MobileCoreServices
import AssetsLibrary
import PhotosUI
import Photos
//import WSTagsField

class ComposeVC: UIViewController {
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var videoTitle: UITextField!
    @IBOutlet weak var shortDescription: UITextView!
    @IBOutlet weak var navigationTopSpace: NSLayoutConstraint!
    @IBOutlet weak var enlargeBtn: UIButton!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopSpace: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var resetMediaBtn: UIButton!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var largeView: UIView!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var bottomLineSpace: NSLayoutConstraint!
    
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pinterestLabel: UILabel!
    
    @IBOutlet fileprivate weak var tagsView: UIView!
    fileprivate let tagsField = WSTagsField()
    
    var capturedImage: UIImage?
    var postbokObject: Postbok?
    let lPublish = PublishPost()
    var socialMediaCount: Int = 0
    var instaCheck: Bool?
    var twitterCheck: Bool?
    var pintCheck: Bool?
    var vUrl: URL?
    var isVideo: Bool?
    var thumbData: Data?
    
    var player : VGPlayer = {
        let playeView = VGPlayerView()
        let playe = VGPlayer(playerView: playeView)
        return playe
    }()
    
    let picker = UIImagePickerController()
    var alert = UIAlertController()
    var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navColor = UIColor.init(red: 204.0/255.0, green: 54.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        UserDefaults.standard.set(false, forKey: PINTEREST_LOGIN)
        self.lPublish.mediaType = "text"
        instaCheck = false
        isVideo = false
        twitterCheck = false
        pintCheck = false
        resetMediaBtn.isHidden = true
       // UIApplication.shared.statusBarView?.backgroundColor = UIColor.green
         picker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        buttonView.layer.shadowColor = UIColor.darkGray.cgColor
        buttonView.layer.shadowOpacity = 4.0
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 1)
        buttonView.layer.shadowRadius = 1
        uploadBtn.layer.cornerRadius = 5.0
        
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
        playerView.isHidden = true
        previewLabel.text = "Compose"
//        DispatchQueue.main.async {
//            self.playVideoWithUrl()
//            self.player.pause()
//        }
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
    
    func openPhotoLibrary() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
           // picker.mediaTypes = [kUTTypeImage as String]
            picker.cameraCaptureMode = .photo
            picker.cameraCaptureMode = .video
            picker.videoMaximumDuration = 60
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        }
    }
    
    func instaAlert(msg: String, instaUrl: URL) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { (UIAlertAction) in
            UIApplication.shared.open(instaUrl)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func playVideoWithUrl(tempUrl: URL) {
        
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let videoDataPath = documentsPath + "/" + "WATCH.mp4"
//        let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
        
        self.player.replaceVideo(tempUrl as URL)
        player.displayView.closeButton.isHidden = true
        self.topView.addSubview(self.player.displayView)
        self.topView.bringSubview(toFront: resetMediaBtn)
        
        self.player.play()
        self.player.backgroundMode = .suspend
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(40)
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(0.6) // you can 9.0/16.0
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

    
    @IBAction func HideLargImageView(_ sender: UIButton) {
        largeView.isHidden = true
    }
    
    
    
    @IBAction func ShowLargeImageAction(_ sender: UIButton) {
        largeView.isHidden = false
    }
    
    
    @IBAction func GoToCamera(_ sender: UIButton) {
        openCamera()
    }
    
    @IBAction func GoToPhotoLibrary(_ sender: UIButton) {
        openPhotoLibrary()
    }
    
    
    @IBAction func ResetMediaAction(_ sender: UIButton) {
        openActionSheet()
    }
    
    
    
    
    func openActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete Media", message: "Are you sure you want to discad this media?", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let discardMedia: UIAlertAction = UIAlertAction(title: "Discard", style: .default) { action -> Void in
            self.playerView.isHidden = true
            self.player.displayView.removeFromSuperview()
            self.imgView.isHidden = true
            self.resetMediaBtn.isHidden = true
            self.enlargeBtn.isHidden = true
            self.isVideo = false
            self.lPublish.mediaType = "text"
            self.twitterLabel.textColor = UIColor.init(red: 85.0/255.0, green: 173.0/255.0, blue: 238.0/255.0, alpha: 1.0)
            self.pinterestLabel.textColor = UIColor.init(red: 85.0/255.0, green: 173.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        }
        actionSheetController.addAction(discardMedia)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func SendVideo(_ sender: UIButton) {
        if instaCheck == true {
            if (imgView.image == nil || imgView.isHidden) && !isVideo! {
                self.informativeAlert(msg: "You must upload a picture to post on instagram!")
            }
            else {
                instagramPost()
            }
        }
        
        if twitterCheck == true {
            if isVideo == true {
                self.informativeAlert(msg: "This feature is undermaintenance")
            }
            else {
                postToTwitter()
            }
            
        }
        if pintCheck == true {
            if isVideo == true {
                self.informativeAlert(msg: "This feature is undermaintenance")
            }
            else {
                postToPinterest()
            }
        }
        
        uploadDataToPublishFirebase()
        if !instaCheck! {
            self.performSegue(withIdentifier: "goToActivity", sender: self)
        }
        
        
       // postToTwitter()
        
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let videoDataPath = documentsPath + "/" + "WATCH.mp4"
//        let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
       // showLoadingIndicater()
        
        
    }
    
    func instagramPost() {
        /// let fff = UIImage(named: "mari.jpg")
        
        let library = ALAssetsLibrary()
        if imgView.image == nil || imgView.isHidden {
            library.writeVideoAtPath(toSavedPhotosAlbum: vUrl) { (url, error) in
                if let url = url {
                    DispatchQueue.main.async {
                        let path = url.absoluteString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                        let instagram = URL(string: "instagram://library?AssetPath="+path!)
                        self.lPublish.instagram = "yes"
                        if self.pintCheck == true || self.twitterCheck == true {
                            self.instaAlert(msg: "Post on instagram Now. Content has been posted on other ", instaUrl: instagram!)
                        }
                        else {
                            UIApplication.shared.open(instagram!)
                        }
                        //UIApplication.shared.open(instagram!)
                    }
                }
            }
        }
        else {
            library.writeImage(toSavedPhotosAlbum: capturedImage?.cgImage, metadata: nil) { (url, error) in
                if let url = url {
                    DispatchQueue.main.async {
                        let path = url.absoluteString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                        let instagram = URL(string: "instagram://library?AssetPath="+path!)
                        self.lPublish.instagram = "yes"
                        if self.pintCheck == true || self.twitterCheck == true {
                            self.instaAlert(msg: "Post on instagram Now. Content has been posted on other ", instaUrl: instagram!)
                        }
                        else {
                            UIApplication.shared.open(instagram!)
                        }
                        //UIApplication.shared.open(instagram!)
                    }
                }
            }
        }
        
        
        
        
        
    }
    
    func uploadDataToPublishFirebase() {

        let uniqueId = DBProvider.Instance.publishPostRef.childByAutoId().key
        lPublish.mediaPath = ""
        lPublish.postText = videoTitle.text!
        lPublish.timeStamp = String(Date().millisecondsSince1970)
        lPublish.postId = uniqueId
        lPublish.scheduledOn = ""
        if pintCheck! || instaCheck! || twitterCheck! {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                PublishPostDBHandler.Instance.adPublishedMedia(publishDict: self.lPublish)
                if self.lPublish.mediaType == "image" {
                    let imageData = UIImageJPEGRepresentation(self.capturedImage!, 0.75)
                    PublishPostDBHandler.Instance.uploadPublishImage(dataToUpload: imageData!, uniqueId: UUID().uuidString, publishId: uniqueId)
                }
                else {
                    PublishPostDBHandler.Instance.uploadPublishThumb(uniqueId: UUID().uuidString, publishId: uniqueId, thumbData: self.thumbData!)
                }
                

            })
            
        }
        if !instaCheck! {
            self.performSegue(withIdentifier: "goToActivity", sender: self)
        }
        
        
    }
    
    func postToTwitter() {
        var title = String()
        var message = String()
        
        
        
        
        var textToTweet: String?
        if videoTitle.text == "" {
            textToTweet = " "
        }
        else {
            textToTweet = videoTitle.text
        }
        if capturedImage == nil || imgView.isHidden {
            FHSTwitterEngine.shared().postTweet(textToTweet)
            socialMediaCount = socialMediaCount+1
            lPublish.postedOn = "twitter,"
            lPublish.twitter = "yes"
            return
        }
        let data = UIImageJPEGRepresentation(capturedImage!, 0.75)
        
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
            lPublish.postedOn = "twitter,"
            lPublish.twitter = "yes"
            //uploadDataToPublishFirebase()
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
            
            if isVideo == true {
                self.informativeAlert(msg: "This feature is undermaintenance")
                return
            }
            
            if !sender.isSelected {
                if let isLogin = UserDefaults.standard.value(forKey: TWITTER_LOGIN) as? Bool {
                    if isLogin {
                        sender.isSelected = !sender.isSelected
                        twitterCheck = !twitterCheck!
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
                twitterCheck = !twitterCheck!
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
        else if sender.tag == 3 {
            let pintUrl = URL(string: "instagram://")
            if UIApplication.shared.canOpenURL(pintUrl!) {
                
            }
            else {
                self.view.makeToast("Instagram is not installed", duration: 3.0, position: .bottom)
                return
            }
            sender.isSelected = !sender.isSelected
            instaCheck = !instaCheck!
        }
            
        else if sender.tag == 5 {
            
            if isVideo! {
                self.informativeAlert(msg: "Pinterest does not allow to post videos")
                return
            }
            if imgView.image == nil || imgView.isHidden {
                self.informativeAlert(msg: "You have to select an image to post on pinterest")
                return
            }
            
            if !sender.isSelected {
                if let isLogin = UserDefaults.standard.value(forKey: PINTEREST_LOGIN) as? Bool {
                    if isLogin {
                        sender.isSelected = !sender.isSelected
                        pintCheck = !pintCheck!
                    }
                    else {
                        pinterestLogin()
                        
                    }
                }
                else {
                    pinterestLogin()
                    sender.isSelected = !sender.isSelected
                    pintCheck = !pintCheck!
                }
            }
        }
        
        else {
            self.informativeAlert(msg: "This feature is under maintenance")
        }
        
        //sender.isSelected = !sender.isSelected
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
            
//            let fields = Set<AnyHashable>()
//            PDKClient.sharedInstance().getAuthenticatedUserBoards(withFields: fields, success: { (responseObject) in
//                print("hiii")
//
//            }, andFailure: { (error) in
//                print("hi")
//            })
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
    
    func postToPinterest() {
        
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
                    PDKClient.sharedInstance().createPin(with: self.imgView.image, link: linkk, onBoard: boardId as! String, description: "my testing pin", progress: { (uploading) in
                        self.socialMediaCount = self.socialMediaCount+1
                        self.lPublish.pinterest = "yes"
                        
                    }, withSuccess: { (success) in
                        print("aa")
                        self.lPublish.pinterest = "yes"
                        
                    }) { (error) in
                        print("aaa")
                    }
                }, andFailure: { (error) in
                    print(error?.localizedDescription)
                })
            }
            else {
                let linkk = URL(string: "https://images.pexels.com")
                PDKClient.sharedInstance().createPin(with: self.imgView.image, link: linkk, onBoard: boardId as! String, description: "my testing pin", progress: { (uploading) in
                    self.socialMediaCount = self.socialMediaCount+1
                    self.lPublish.pinterest = "yes"
                    
                }, withSuccess: { (success) in
                    print("aa")
                    self.lPublish.pinterest = "yes"
                    
                }) { (error) in
                    print("aaa")
                }
            }
            
            
        }) { (error) in
            print("failed")
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
    
    func informativeAlert(msg: String) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { (UIAlertAction) in
            //alertController.dismiss(animated: true, completion: nil)
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
    
    func flipImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else {
            // Could not form CGImage from UIImage for some reason.
            // Return unflipped image
            return image
        }
        let flippedImage = UIImage(cgImage: cgImage,
                                   scale: image.scale,
                                   orientation: .leftMirrored)
        return flippedImage
    }
}

extension ComposeVC: UITableViewDelegate, UITableViewDataSource {
    
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

extension ComposeVC: VGPlayerDelegate {
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

extension ComposeVC: VGPlayerViewDelegate {
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

extension ComposeVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        }
        else {
            placeHolderLabel.isHidden = true
        }
    }
}

extension ComposeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingImage image:UIImage!, editingInfo: [String : AnyObject])
    {
        picker.dismiss(animated: true, completion: nil)
        let chosenImage = image//2
        capturedImage = chosenImage //4
        imgView.image = chosenImage
        let imageData = UIImageJPEGRepresentation(chosenImage!, 0.75)
        
        
        //self.AlertDialog(titletoshow: "Setting Profile Picture", Messagetoshow: "Your profile picture is being uploaded to server please wait!")
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        resetMediaBtn.isHidden = false
        
        playerView.isHidden = false
        imgView.isHidden = false
        
        let urlVideo = info[UIImagePickerControllerMediaURL]
        picker.dismiss(animated: true, completion: {
            if info[UIImagePickerControllerMediaType] as! String == "public.image"{
                self.playerView.isHidden = true
                self.player.displayView.removeFromSuperview()
                 var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                chosenImage = self.flipImage(image: chosenImage)
                self.capturedImage = chosenImage //4
                self.imgView.image = chosenImage
                self.largeImageView.image = chosenImage
                self.enlargeBtn.isHidden = false
                self.isVideo = false
                self.lPublish.mediaType = "image"
                self.twitterLabel.textColor = UIColor.init(red: 85.0/255.0, green: 173.0/255.0, blue: 238.0/255.0, alpha: 1.0)
                self.pinterestLabel.textColor = UIColor.init(red: 85.0/255.0, green: 173.0/255.0, blue: 238.0/255.0, alpha: 1.0)
            }
            else {
                DispatchQueue.main.async {
                    self.playVideoWithUrl(tempUrl: urlVideo as! URL)
                    self.vUrl = urlVideo as? URL
                    let thumbImage = self.videoPreviewUIImage(moviePath: self.vUrl!)
                    self.thumbData = UIImageJPEGRepresentation(thumbImage!, 0.2)
                    self.player.pause()
                    self.enlargeBtn.isHidden = true
                    self.twitterLabel.textColor = UIColor.lightGray
                    self.pinterestLabel.textColor = UIColor.lightGray
                    self.isVideo = true
                    self.lPublish.mediaType = "video"
                    
                }
            }
        })
    }
}

extension ComposeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        videoTitle.resignFirstResponder()
        return true
    }
}




