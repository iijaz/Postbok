//
//  ThemesViewController.swift
//  SMC
//
//  Created by JuicePhactree on 1/15/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit
import AVFoundation

class ThemesViewController: UIViewController, GetAllPostMediaDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loadingGifView: UIImageView!
    @IBOutlet weak var activityBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    // @IBOutlet weak var cardTestView: UIView!
    //@IBOutlet weak var backgroundImageView: UIImageView!
   // @IBOutlet weak var sampleUserImageView: UIImageView!
    
    var selectedCardImageName: String!
    var arrayOfPostbokMedia = [Postbok]()
    var selectedPostbokObject: Postbok?
    var imageSelected: UIImage?
    let picker = UIImagePickerController()
    var imageToUpload: UIImage?
    var videoDataToUpload: Data?
    var isVideo: Bool?
    var uniquePostbokId: String?
    var isEditMode: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingGifView.loadGif(name: "loadinganimation")
        collectionView.reloadData()
        let navColor = UIColor.init(red: 204.0/255.0, green: 54.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        activityBtn.layer.cornerRadius = 5.0
        activityBtn.clipsToBounds = true
        picker.delegate = self
       // sampleUserImageView.roundImageView()
        
//        topView.layer.shadowColor = UIColor.black.cgColor
//        topView.layer.shadowOpacity = 1.0
//        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        topView.layer.shadowRadius = 1.0
        
//        topView.layer.shadowColor = UIColor.black.cgColor
//        topView.layer.shadowOpacity = 5.0
//        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        topView.layer.shadowRadius = 1.0
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        PostbokDBhandler.Instance.getAllPostbokMediaDelegate = self
        PostbokDBhandler.Instance.getUserPostbokMedia(userId: accountId!)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        
        
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return
//    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    func getAllMedia(mediaDict:NSDictionary) {
        let ff = mediaDict["postId"] as? String
        if ff == "" || ff == nil {
            return
        }
        let lPostBok = Postbok(postMediaDict: mediaDict)
        
        var sArray = arrayOfPostbokMedia.filter() {
            
            $0.postId.contains(lPostBok.postId)
        }
        
        if sArray.count > 0 {
            
            let loc = arrayOfPostbokMedia.index(where: { (tempObject) -> Bool in

                tempObject.postId = sArray[0].postId
                return true
            })
            print("i")
            
            arrayOfPostbokMedia.remove(at: loc!)
            arrayOfPostbokMedia.insert(lPostBok, at: loc!)
            loadingGifView.isHidden = true
            collectionView.reloadData()
            return
        }
        
       // arrayOfPostbokMedia.append(lPostBok)
        arrayOfPostbokMedia.insert(lPostBok, at: 0)
        collectionView.reloadData()
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            isEditMode = true
            collectionView.reloadData()
            return
        }
        
        let point = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let index = indexPath {
            var cell = self.collectionView.cellForItem(at: index)
        } else {
            print("Could not find index path")
        }
    }
    
    func openPhotoLibrary() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        //picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func openVideoLibrary() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        //picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func openActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Select Media Type", message: "", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let selectImage: UIAlertAction = UIAlertAction(title: "Image", style: .default) { action -> Void in
            self.openPhotoLibrary()
        }
        let selectVideo: UIAlertAction = UIAlertAction(title: "Video", style: .default) { action -> Void in
            self.openVideoLibrary()
            
        }
        actionSheetController.addAction(selectImage)
        actionSheetController.addAction(selectVideo)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func openDeleteMeidaActionSheet(selectedRow: Int){
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete selected Media", message: "Are you sure you want to delete this?", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let deleteMedia: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action -> Void in
            let lPostedMedia = self.arrayOfPostbokMedia[selectedRow-1]
            PostbokDBhandler.Instance.deleteSelectedPostedMedia(postedId: lPostedMedia.postId)
            self.arrayOfPostbokMedia.remove(at: selectedRow-1)
            self.collectionView.reloadData()
        }

        actionSheetController.addAction(deleteMedia)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func uploadDataToFirebase(uniqueId: String, thumbLink: String, mediaType: String, videoData: NSData?, thumbData: Data?) {
        
        uniquePostbokId = DBProvider.Instance.postbokRef.childByAutoId().key
        let lPostbok = Postbok()
        lPostbok.mediaType = mediaType
        lPostbok.mediaPath = ""
        lPostbok.postId = uniquePostbokId!
        lPostbok.postText = ""
        lPostbok.thumbImage = ""
        
        PostbokDBhandler.Instance.adPostbokMedia(postbokDict: lPostbok)
        
        
        if mediaType == "video" {
            self.view.makeToast("Uploading your video", duration: 3.0, position: .bottom)
            PostbokDBhandler.Instance.uploadPostbokVideo(dataToUpload: videoData! as Data, uniqueId: UUID().uuidString, postbokId: uniquePostbokId!, thumbData: thumbData!)
        }
        else {
            self.view.makeToast("Uploading your Image", duration: 3.0, position: .bottom)
            let imageData = UIImageJPEGRepresentation(imageToUpload!, 0.6)
            PostbokDBhandler.Instance.uploadPostbokImage(dataToUpload: imageData!, uniqueId: UUID().uuidString, postbokId: uniquePostbokId!)
        }
        
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ActivityAction(_ sender: UIButton) {
        
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
       // cardTestView.isHidden = true
    }
    
    @IBAction func DeleteAction(_ sender: UIButton) {
        let collectionViewCell = sender.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: collectionViewCell)
//        let lPostedMedia = arrayOfPostbokMedia[(indexPath?.item)!-1]
//        PostbokDBhandler.Instance.deleteSelectedPostedMedia(postedId: lPostedMedia.postId)
//        arrayOfPostbokMedia.remove(at: (indexPath?.item)!-1)
//        collectionView.reloadData()
        self.openDeleteMeidaActionSheet(selectedRow: (indexPath?.item)!)
    }
    
    
    @IBAction func SetCardImage(_ sender: UIButton) {
        UserDefaults.standard.set(selectedCardImageName, forKey: WALLPAPER_NAME)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
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
            return
        }
        
        self.saveVideoToLocal(urlData: data, uniqueId: "WATCH")
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let videoDataPath = documentsPath + "/" + "WATCH.mp4"
        let tempUrl:NSURL = NSURL(fileURLWithPath: videoDataPath)
        
        let thumbImage = self.videoPreviewUIImage(moviePath: tempUrl as URL)
        //  self.stopLoadingIndicator()
        let thumbData = UIImageJPEGRepresentation(thumbImage!, 0.2)
        
        
        guard let newData = NSData(contentsOf: tempUrl as URL) else {
            return
        }
        
        
        //print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: tempUrl as URL, outputURL: compressedURL) { (exportSession) in
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
                
                
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                self.saveVideoToLocal(urlData: compressedData, uniqueId: "WATCH")
                self.isVideo = true
                self.uploadDataToFirebase(uniqueId: "", thumbLink: "", mediaType: "video", videoData: compressedData, thumbData: thumbData)
                
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
    
    func saveVideoToLocal(urlData: NSData, uniqueId: String) {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = uniqueId+".mp4"; //.stringByDeletingPathExtension
        let filePath="\(documentsPath)/\(fileName)"
        //saving is done on main thread
        //        DispatchQueue.main.async(execute: { () -> Void in
        //            urlData.write(toFile: filePath, atomically: true);
        //        })
        urlData.write(toFile: filePath, atomically: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPostbokPreview" {
            let nextScene = segue.destination as! PostbokPreviewVC
            if selectedPostbokObject?.mediaType == "image" {
                nextScene.capturedImage = imageSelected
            }
            nextScene.postbokObject = selectedPostbokObject
            
        }
    }
    
    
}

extension ThemesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrayOfPostbokMedia.count == 0 {
            loadingGifView.isHidden = false
            collectionView.isHidden = true
        }
        else {
            loadingGifView.isHidden = true
            collectionView.isHidden = false
        }
        
        return arrayOfPostbokMedia.count+1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        let imgView = cell.viewWithTag(1) as! UIImageView
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        //imgView.layer.borderWidth = 1.0
        let playImgeivew = cell.viewWithTag(2) as! UIImageView
        let deleteBtn = cell.viewWithTag(3) as! UIButton
        if indexPath.item == 0 {
            imgView.image = UIImage(named: "Add Button New.png")
            imgView.layer.cornerRadius = 5.0
            imgView.clipsToBounds = true
            playImgeivew.isHidden = true
            deleteBtn.isHidden = true
            return cell
        }
        else if indexPath.item > 0 {
            let lPostMedia = arrayOfPostbokMedia[indexPath.row-1]
            
            
            if lPostMedia.mediaPath != "" {
                //            let postImageUrl = URL(string: lPostMedia.mediaPath)
                //            imgView.kf.setImage(with: postImageUrl)
                if lPostMedia.mediaType == "video" {
                    playImgeivew.isHidden = false
                    if lPostMedia.thumbImage != ""{
                        let postImageUrl = URL(string: lPostMedia.thumbImage!)
                        imgView.kf.setImage(with: postImageUrl)
                    }
                    else {
                        imgView.image = UIImage(named: "loadingBox.png")
                    }
                    
                }
                else {
                    if lPostMedia.mediaPath != "" {
                        playImgeivew.isHidden = true
                        let postImageUrl = URL(string: lPostMedia.mediaPath)
                       // imgView.kf.setImage(with: postImageUrl)
                        imgView.kf.setImage(with: postImageUrl, placeholder: nil, options: nil, progressBlock: { (x, y) in
                            imgView.image = UIImage(named: "loadingBox.png")
                        }, completionHandler: { (img, erorr, cType, url) in
                            imgView.image = img
                        })
                    }
                    else {
                        imgView.image = UIImage(named: "loadingBox.png")
                    }
                }
            }
            else {
                imgView.image = UIImage(named: "loadingBox.png")
            }
            
            
            
            imgView.layer.cornerRadius = 5.0
            imgView.clipsToBounds = true
        }
        
        if indexPath.item > 0 {
            deleteBtn.isHidden = !isEditMode
        }
        else {
            deleteBtn.isHidden = true
        }
        
        
      //  UIImage.init(ciImage: <#T##CIImage#>)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width-6
        
        let cellWidth = screenWidth/numberOfCell
        return CGSize(width: cellWidth, height: 200)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         //selectedCardImageName = String(indexPath.item+104)+".jpg"
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if isEditMode {
            isEditMode = false
            collectionView.reloadData()
            return
        }
        
        let imgView = cell?.viewWithTag(1) as! UIImageView
        if indexPath.item == 0 {
            self.openActionSheet()
            return
        }
        
        let lPostbok = arrayOfPostbokMedia[indexPath.item-1]
        selectedPostbokObject = lPostbok
        if lPostbok.mediaType == "image" {
            imageSelected = imgView.image
        }
        if lPostbok.mediaPath != "" {
            self.performSegue(withIdentifier: "goToPostbokPreview", sender: self)
        }
        else {
            //self.view.makeToast("Media is loading", duration: 3.0, position: .bottom)
        }
        if lPostbok.thumbImage == "" && lPostbok.mediaType == "video" {
            self.view.makeToast("Media is loading", duration: 3.0, position: .bottom)
        }
    }
}

extension ThemesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingImage image:UIImage!, editingInfo: [String : AnyObject])
    {
        picker.dismiss(animated: true, completion: nil)
        let chosenImage = image//2
        
        //self.AlertDialog(titletoshow: "Setting Profile Picture", Messagetoshow: "Your profile picture is being uploaded to server please wait!")
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let urlVideo = info[UIImagePickerControllerMediaURL]
        picker.dismiss(animated: true, completion: {
            if info[UIImagePickerControllerMediaType] as! String == "public.image"{
                print("this is image")
                self.imageToUpload = info[UIImagePickerControllerOriginalImage] as? UIImage
                self.uploadDataToFirebase(uniqueId: "", thumbLink: "", mediaType: "image", videoData: nil, thumbData: nil)
            }
            else {
                let urlVideo = info[UIImagePickerControllerMediaURL]
                self.compressVideoWithUrl(outputFileURL: urlVideo as! URL)
            }
        })
    }
}

