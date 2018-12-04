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
//import WSTagsField

class PlayVideoViewController: UIViewController, GetQuestionThumbLinkDelegate, GetAnswerThumbLinkDelegate {
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
    
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    
    @IBOutlet weak var bottomLineSpace: NSLayoutConstraint!
    
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet fileprivate weak var tagsView: UIView!
    fileprivate let tagsField = WSTagsField()
    
    var questionId: String?
    var selectedUser: NSDictionary?
    var capturedImage: UIImage?
    var uniqueQuestionId: String?
    var uniqueAnswerId: String?
    
    let uniqueId = UUID().uuidString
    var player : VGPlayer = {
        let playeView = VGPlayerView()
        let playe = VGPlayer(playerView: playeView)
        return playe
    }()
    var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagFieldSettings()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        QuestionsDBHandler.Instance.getQuestionThumbLinkDelegate = self
        AnswersDBHandler.Instance.getAnswerThumblinkDelegate = self

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
            previewLabel.text = "Preview Image"
            return
        }
        previewLabel.text = "Preview Video"
        DispatchQueue.main.async {
            self.playVideoWithUrl()
            self.player.pause()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    func tagFieldSettings() {
        if self.questionId != nil {
            return
        }
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        
        tagsField.placeholder = "Tag#"
        tagsField.backgroundColor = .white
        tagsField.frame = tagsView.bounds
        tagsField.returnKeyType = .next
        tagsField.delimiter = " "
        
        tagsField.placeholderAlwayVisible = true
        tagsField.maxHeight = 40.0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
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
        let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
        
        self.player.replaceVideo(tempUrl as URL)
        player.displayView.closeButton.isHidden = true
        self.topView.addSubview(self.player.displayView)
        
        self.player.play()
        self.player.backgroundMode = .suspend
        self.player.delegate = self
        self.player.displayView.delegate = self
        var topHeight: Int = 0
        if self.questionId != nil {
            topHeight = 70
        }
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(topHeight)
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(1) // you can 9.0/16.0
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
    
    func compressVideoWithUrl(outputFileURL: URL) {
        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            if capturedImage != nil {
                if self.questionId != nil {
                    
                }
                else {
                    let imageData = UIImageJPEGRepresentation(capturedImage!, 0.2)
                    QuestionsDBHandler.Instance.uploadQuestionImage(dataToUpload: imageData!, uniqueId: self.uniqueId, questionId: self.uniqueQuestionId!)
                }
                return
            }
            return
        }
        
        
            print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                
                self.uploadVideoToServer(videoData: compressedData)
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                
            case .failed:
                print("failed")
                break
            case .cancelled:
                break
            }
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    func uploadVideoToServer(videoData: NSData) {
        
        if capturedImage != nil {
            if self.questionId != nil {
                
            }
            else {
                let imageData = UIImageJPEGRepresentation(capturedImage!, 0.2)
                QuestionsDBHandler.Instance.uploadQuestionImage(dataToUpload: imageData!, uniqueId: self.uniqueId, questionId: self.uniqueQuestionId!)
            }
            return
        }
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let videoDataPath = documentsPath + "/" + "WATCH.mp4"
        let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
        let thumbImage = self.videoPreviewUIImage(moviePath: tempUrl as URL)
        //  self.stopLoadingIndicator()
        let imageData = UIImageJPEGRepresentation(thumbImage!, 0.2)
        
        if self.questionId != nil {
            DispatchQueue.main.async {
                AnswersDBHandler.Instance.uploadAnswerVideo(dataToUpload: videoData as Data, uniqueId: self.uniqueId, answerId: self.uniqueAnswerId!, quesId: self.questionId!)
                
                AnswersDBHandler.Instance.uploadAnswerThumb(dataToUpload: imageData!, uniqueId: self.uniqueId, answerId: self.uniqueAnswerId!, quesId: self.questionId!)
            }
        }
        else {
            DispatchQueue.main.async {
                QuestionsDBHandler.Instance.uploadQuestionVideoData(dataToUpload: videoData as Data, uniqueId: self.uniqueId, questionId: self.uniqueQuestionId!)
                
                QuestionsDBHandler.Instance.uploadQuestionThumb(dataToUpload: imageData!, uniqueId: self.uniqueId, questionId: self.uniqueQuestionId!)
            }
        }
        
//        Server.uploadVideoToServer(videoData: videoData, uniqueId: uniqueId, completion: { (dict) in
//
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//            let videoDataPath = documentsPath + "/" + "WATCH.MOV"
//            let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
//            let thumbImage = self.videoPreviewUIImage(moviePath: tempUrl as URL)
//          //  self.stopLoadingIndicator()
//            let imageData = UIImageJPEGRepresentation(thumbImage!, 0.2)
//            if self.questionId != nil {
//                DispatchQueue.main.async {
//                    AnswersDBHandler.Instance.uploadAnswerThumb(dataToUpload: imageData!, uniqueId: self.uniqueId, answerId: self.uniqueAnswerId! )
//                }
//
//            }
//            else {
//                DispatchQueue.main.async {
//                    QuestionsDBHandler.Instance.uploadQuestionThumb(dataToUpload: imageData!, uniqueId: self.uniqueId, questionId: self.uniqueQuestionId!)
//                }
//
//            }
//
////            DispatchQueue.main.async {
////                self.view.makeToast("Video uploaded successfully", duration: 1.3, position: .bottom)
////            }
//
//        }) { (error) in
//            DispatchQueue.main.async {
//                self.stopLoadingIndicator()
//                self.view.makeToast("Network Issue occured Please try again", duration: 1.3, position: .top)
//            }
//
//        }
    }
    
    func uploadDataToFirebase(uniqueId: String, thumbLink: String) {
        var tagString: String = ""
        for tagItem in tagsField.tags {
            tagString = tagString+tagItem.text+" "
        }
        if tagsField.tags.count < 1 {
            tagString = tagsField.text!
        }
        
        uniqueQuestionId = DBProvider.Instance.questionsRef.childByAutoId().key
        let lQuestion = Questions()
        lQuestion.title = videoTitle.text!
        lQuestion.shortDescription = shortDescription.text
        lQuestion.date = String(Date().millisecondsSince1970)
        lQuestion.likes = "0"
        lQuestion.thumbLink = thumbLink
        lQuestion.ansId = ""
        lQuestion.comments = ""
        lQuestion.tag = tagString
        lQuestion.quesId = uniqueQuestionId!
        
        if capturedImage != nil {
            lQuestion.videoLink = ""
        }
        else {
           lQuestion.videoLink = UPLOADED_VIDEO_URL+uniqueId+".mp4"
        }

        QuestionsDBHandler.Instance.addVideo(questionDict: lQuestion)
        UserDefaults.standard.setValue("camera", forKey: "controller")
        self.performSegue(withIdentifier: "goToHome", sender: self)

        //UserDefaults.standard.setValue("camera", forKey: "controller")
        //self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func uploadAnsDataToFirebase(uniqueId: String, thumbLink: String, questionId: String) {
        let lAnswer = Answers()
        uniqueAnswerId = DBProvider.Instance.questionsRef.child(questionId).child("Answers").childByAutoId().key
        lAnswer.date = String(Date().millisecondsSince1970)
        lAnswer.likes = "0"
       // lAnswer.videoLink = UPLOADED_VIDEO_URL+uniqueId+".mp4"
        lAnswer.thumbLink = thumbLink
        lAnswer.ansId = uniqueAnswerId!
        lAnswer.comments = ""
        lAnswer.quesId = questionId
        if capturedImage != nil {
            lAnswer.videoLink = ""
        }
        else {
            //lAnswer.videoLink = UPLOADED_VIDEO_URL+uniqueId+".mp4"
            lAnswer.videoLink = ""
        }
        QuestionsDBHandler.Instance.addVideoAnswer(answerDict: lAnswer, questionId: questionId)
        UserDefaults.standard.setValue("camera", forKey: "controller")
        self.performSegue(withIdentifier: "goToHome", sender: self)
        DispatchQueue.main.async {
            self.view.makeToast("Video uploaded successfully", duration: 1.3, position: .top)
        }
    }
    
    func getQuestionThumb(thumbLink: String) {
        
       // uploadDataToFirebase(uniqueId: uniqueId, thumbLink: thumbLink)
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        var activityString = "You uploaded a Video"
        var otherString = uniqueName+" uploaded a Video"
        if (capturedImage != nil) {
            activityString = "You uploaded a Image"
            otherString = "You uploaded a Image"
        }
        
        //UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: uniqueQuestionId!, answerId: "", otherString: otherString, userId: accountId)
    }
    
    func getAnswerThumb(thumbLink: String) {
        
       // uploadAnsDataToFirebase(uniqueId: uniqueId, thumbLink: thumbLink, questionId: questionId!)
        let userName = selectedUser?["name"] as! String
        let uniqueName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        let activityString = "You Responded on "+userName+" Video"
        let otherString = uniqueName+" Responded on your Video"
        UserDBHandler.Instance.setUserActivities(activityString: activityString, questionId: questionId!, answerId: "", otherString: otherString, userId: selectedUser?["id"] as! String)
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SendVideo(_ sender: UIButton) {
        
        if self.questionId != nil {
            uploadAnsDataToFirebase(uniqueId: uniqueId, thumbLink: "", questionId: questionId!)
        }
        else {
            if (videoTitle.text?.characters.count)! < 1 {
                self.view.makeToast("video title cannot be empty", duration: 3.0, position: .top)
                return
            }
            uploadDataToFirebase(uniqueId: uniqueId, thumbLink: "")
            postToTwitter()
        }
        
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let videoDataPath = documentsPath + "/" + "WATCH.mp4"
        let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
        showLoadingIndicater()
        compressVideoWithUrl(outputFileURL: tempUrl as URL)
        
        
    }
    
    func postToTwitter() {
        var title = String()
        var message = String()
        
//        let filepath = Bundle.main.path(forResource: "temp", ofType: "mp4")
//        let vidData = NSData(contentsOfFile: filepath!)
//        let dd = Data(referencing: vidData!)
        
        
        let data = UIImageJPEGRepresentation(capturedImage!, 0.2)
         let ll = FHSTwitterEngine.shared().postTweet(videoTitle.text, withImageData: data)
        
        if(ll != nil)
        {
            title = "Error"
            message = "error occured while poting"
        }
        else
        {
            title = "Success"
            message = "Successfully posted."
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
        else if sender.tag == 3 {
            
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
        if segue.identifier == "goToHome" {
            let nextScene = segue.destination as! MainTabBarController
        }
    }
}

extension PlayVideoViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension PlayVideoViewController: VGPlayerDelegate {
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

extension PlayVideoViewController: VGPlayerViewDelegate {
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

extension PlayVideoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        }
        else {
            placeHolderLabel.isHidden = true
        }
    }
}

extension PlayVideoViewController {
    fileprivate func textFieldEventss() {
        tagsField.onDidAddTag = { _ in
            print("DidAddTag")
        }
        
        tagsField.onDidRemoveTag = { _ in
            print("DidRemoveTag")
        }
        
        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")
        }
        
        tagsField.onDidBeginEditing = { _ in
            print("DidBeginEditing")
        }
        
        tagsField.onDidEndEditing = { _ in
            print("DidEndEditing")
        }
        
        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }
        
        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }
        
        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
    }
}


