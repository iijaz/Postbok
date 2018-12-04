//
//  SetProfileViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/15/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class SetProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var profession: UITextField!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var aboutView: UIView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    let picker = UIImagePickerController()
    var alert = UIAlertController()
    var loadingIndicator: UIActivityIndicatorView?
    
    var updateProfile: String?
    var userBio: String?
    var userProfession: String?

    @IBOutlet weak var topSpaceConstant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if updateProfile != nil {
            saveBtn.isHidden = false
            forwardBtn.isHidden = true
        }
        else {
            saveBtn.isHidden = true
            forwardBtn.isHidden = false
        }
        //profession.layer.borderWidth = 1.0
        profession.layer.cornerRadius = 8.0
      //  aboutView.layer.borderWidth = 1.0
        aboutView.layer.cornerRadius = 8.0
        profession.attributedPlaceholder = NSAttributedString(string:profession.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.black])
        picker.delegate = self
        cardView.roundViewAndSetShadow()
        
        
        
        let profileUrl = UserDefaults.standard.value(forKey: USER_PROFILE_URL) as? String
        aboutTextView.text = userBio
        profession.text = userProfession
        if profileUrl != nil {
            profileImageView.kf.setImage(with: URL(string: profileUrl!))
            profileImageView.roundImageView()
        }
        if aboutTextView.text.characters.count > 0 {
            placeHolderLabel.isHidden = true
        }

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func keyboardWillShow(_ notification: NSNotification){
        topSpaceConstant.constant = -140
        
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        topSpaceConstant.constant = 10
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 100
    }
    
    func openActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Upload Photo", message: "Please! Choose an option!", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
            self.openCamera()
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { action -> Void in
            self.openPhotoLibrary()
        }
        actionSheetController.addAction(choosePictureAction)
        
//        let removePictureAction: UIAlertAction = UIAlertAction(title: "Remove Photo", style: .default) { action -> Void in
//            self.removePhoto()
//        }
       // actionSheetController.addAction(removePictureAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        }
    }
    
    func AlertDialog(titletoshow: String, Messagetoshow: String)
    {
        alert = UIAlertController(title: titletoshow, message: Messagetoshow, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func openPhotoLibrary() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func removePhoto() {
        UserDBHandler.Instance.updateUserInFirebase(profileUrl: "", bio: aboutTextView.text, profession: profession.text!)
        profileImageView.image = nil
    }
    
    @IBAction func SetProfilePic(_ sender: UIButton) {
    }
    @IBAction func GoForword(_ sender: UIButton) {
        let profileUrl = UserDefaults.standard.value(forKey: USER_PROFILE_URL) as? String
        if updateProfile != nil {
            if (updateProfile?.characters.count)! > 0 {
//                if (profession.text?.characters.count)! < 1 {
//                    self.view.makeToast("Profession field can not be empty")
//                    return
//                }
                UserDBHandler.Instance.updateUserInFirebase(profileUrl: profileUrl!, bio: aboutTextView.text, profession: profession.text!)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        
        let phoneNumber = UserDefaults.standard.value(forKey: USER_PHONE_NUMBER) as! String
        let userName = UserDefaults.standard.value(forKey: USER_UNIQUE_NAME) as! String
        if profileUrl == nil {
            self.view.makeToast("Picture must be uploaded", duration: 2.0, position: .top)
            return
        }
//        if (profession.text?.characters.count)! < 1 {
//            self.view.makeToast("Profession field can not be empty")
//            return
//        }
        let fcmToken = UserDefaults.standard.value(forKey: USER_FCM_TOKEN) as? String
        
        let lUser = User()
        lUser.activities = ""
        lUser.answers = "0"
        lUser.bio = aboutTextView.text
        lUser.email = ""
        lUser.mFcmId = ""
        lUser.followers = "0"
        lUser.following = "0"
        lUser.id = accountId
        lUser.inApp = "true"
        lUser.lastSeen = String(Date().millisecondsSince1970)
        lUser.notification = ""
        lUser.online = "true"
        lUser.password = ""
        lUser.phone = phoneNumber
        lUser.posts = "0"
        lUser.profile = profileUrl!
        lUser.region = TimeZone.current.identifier
        lUser.replies = ""
        lUser.specialists = ""
        lUser.websites = ""
        lUser.username = userName
        lUser.mFcmId = fcmToken!
        lUser.device = "iphone"
        lUser.profession = profession.text!
        
        UserDBHandler.Instance.addNewUserToFirebaseDatabase(user: lUser)
        self.performSegue(withIdentifier: "goToSocial", sender: self)
        
    }
    
    @IBAction func GoBackword(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ChooseProfilePic(_ sender: UIButton) {
        self.openActionSheet()
        
    }

    @IBAction func DismissKeyboard(_ sender: UIButton) {
        aboutTextView.resignFirstResponder()
    }
    
    func showLoadingIndicater() {
        cardView.alpha = 0.5
        let screenSize: CGRect = UIScreen.main.bounds
        let indicatorWidth = screenSize.width-50
        let indicatorHeight = screenSize.height-50
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: indicatorWidth/2, y: indicatorHeight/2, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator?.startAnimating()
        self.view.addSubview(loadingIndicator!)
        self.view.isUserInteractionEnabled = false
    }
    
    func stopLoadingIndicator() {
        loadingIndicator?.stopAnimating()
        self.loadingIndicator?.removeFromSuperview()
        cardView.alpha = 1.0
        self.view.isUserInteractionEnabled = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SetProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingImage image:UIImage!, editingInfo: [String : AnyObject])
    {
        picker.dismiss(animated: true, completion: nil)
        let chosenImage = image//2
        profileImageView.image = chosenImage //4
        profileImageView.roundImageView()
        let imageData = UIImageJPEGRepresentation(chosenImage!, 0.2)
        showLoadingIndicater()
        
       // UserDBHandler.Instance.uploadProfileImage(dataToUpload: imageData!)
        UserDBHandler.Instance.uploadProfileImage(dataToUpload: imageData!, completion: { (str) in
            self.stopLoadingIndicator()
        }) { (error) in
            self.stopLoadingIndicator()
        }

        //self.AlertDialog(titletoshow: "Setting Profile Picture", Messagetoshow: "Your profile picture is being uploaded to server please wait!")
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SetProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        }
        else {
            placeHolderLabel.isHidden = true
        }
    }
}

extension SetProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        profession.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
