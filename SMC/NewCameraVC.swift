//
//  NewCameraVC.swift
//  SMC
//
//  Created by JuicePhactree on 8/16/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit
import SCRecorder
import FirebaseDatabase
import FirebaseStorage

class NewCameraVC: UIViewController, UIGestureRecognizerDelegate {
    
    let session = SCRecordSession()
    let recorder = SCRecorder()
    var toolView = SCRecorderToolsView()
    let player = SCPlayer()
    var timer: Timer?
    var isVideo: Bool?
    var seconds = 0
    var updateTimerCont: Int = 0
    var capturedImage: UIImage?
    var uniquePostbokId: String?
    var mediaLimitOver: Bool?
    
    var localFilters = [SCFilter.empty(),SCFilter.init(ciFilterName: "CISepiaTone"), SCFilter.init(ciFilterName: "CIPhotoEffectChrome"), SCFilter.init(ciFilterName: "CIPhotoEffectTonal"), SCFilter.init(ciFilterName: "CIColorMonochrome"), SCFilter.init(ciFilterName: "CIPhotoEffectTransfer"), SCFilter.init(ciFilterName: "CIColorPosterize"), SCFilter.init(ciFilterName: "CIVignette"), SCFilter.init(ciFilterName: "CIPhotoEffectProcess"), SCFilter.init(ciFilterName: "CIPhotoEffectMono"), SCFilter.init(ciFilterName: "CIPhotoEffectFade"), SCFilter.init(ciFilterName: "CIFalseColor")]
    
    @IBOutlet weak var previewView: SCRecorderToolsView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var postBokRedCircule: UIImageView!
    @IBOutlet weak var swipeFilterView: SCSwipeableFilterView!
    @IBOutlet weak var imgToastView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var recordingBtn: UIButton!
    
    @IBOutlet weak var processingView: UIView!
    
    @IBOutlet weak var loadingGif: UIImageView!
    @IBOutlet weak var processinglabel: UILabel!
    
    @IBOutlet weak var overLayerView: UIView!
    @IBOutlet weak var timeView: UIView!
    override func viewDidLayoutSubviews() {
        previewView.delegate = self
      //  self.previewView.recorder = recorder
        previewView.pinchToZoomEnabled = true
        recorder.previewView = previewView
        
        thumbImageView.layer.cornerRadius = 4.0
        thumbImageView.layer.borderWidth = 1.0
        thumbImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        //self.previewView.recorder = recorder

    }

    override func viewDidLoad() {
        super.viewDidLoad()
       // recorder.videoConfiguration.size = CGSize(width: 200,height: 200)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
    
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesutre(gestureReconizer:)))
        
        tapGesture.delaysTouchesBegan = true
        tapGesture.delegate = self
        self.previewView.addGestureRecognizer(tapGesture)
        
        //let tempView = UIView()
        
        previewView.addSubview(swipeFilterView)
        swipeFilterView.filters = [SCFilter.empty(),SCFilter.init(ciFilterName: "CISepiaTone"), SCFilter.init(ciFilterName: "CIPhotoEffectChrome"), SCFilter.init(ciFilterName: "CIPhotoEffectTonal"), SCFilter.init(ciFilterName: "CIColorMonochrome"), SCFilter.init(ciFilterName: "CIPhotoEffectTransfer"), SCFilter.init(ciFilterName: "CIColorPosterize"), SCFilter.init(ciFilterName: "CIVignette"), SCFilter.init(ciFilterName: "CIPhotoEffectProcess"), SCFilter.init(ciFilterName: "CIPhotoEffectMono"), SCFilter.init(ciFilterName: "CIPhotoEffectFade"), SCFilter.init(ciFilterName: "CIFalseColor")]
        collectionView.reloadData()
        recorder.scImageView = swipeFilterView
       // recorder.scImageView?.contentMode = .scaleAspectFill
        swipeFilterView.selectedFilter = SCFilter.empty()
        previewView.recorder?.scImageView = swipeFilterView
        
        swipeFilterView.ciImage = CIImage(color: CIColor.blue())
        player.scImageView = swipeFilterView
       // player.scImageView?.contentMode = .scaleAspectFit
        
        
        let navColor = UIColor.init(red: 204.0/255.0, green: 54.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        UIApplication.shared.statusBarView?.backgroundColor = navColor
        previewView.delegate = self
        swipeFilterView.delegate = self
        mediaLimitOver = false
        self.previewView.recorder = recorder
        
        checkMediaCount()
        recorder.flashMode = SCFlashMode.on
        previewView.pinchToZoomEnabled = true
        recorder.maxVideoZoomFactor = 4.0
        
        //previewView.tapToFocusEnabled = true
        postBokRedCircule.roundImageView()
        recordingBtn.layer.cornerRadius = recordingBtn.frame.size.width/2
        recordingBtn.clipsToBounds = true
        //self.previewView.recorder = recorder
        UserDefaults.standard.setValue("newCamera", forKey: INITIAL_CONTROLLER)
        
        
        recorder.commitConfiguration()
        recorder.mirrorOnFrontCamera  = true
        
        //recorder.flashMode = SCFlashMode.on
        updateTimerCont = 0
        capturedImage = nil
        
        if (!recorder.startRunning()) {
            debugPrint("Recorder error: ", recorder.error)
        }
        timeLabel.text = "0"+String(seconds)
        postBokRedCircule.isHidden = true
        recorder.session = session
        recorder.device = AVCaptureDevicePosition.front
        recorder.videoConfiguration.size = CGSize(width: 200,height: 200)
        recorder.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        recorder.commitConfiguration()
//        recorder.mirrorOnFrontCamera  = true
//
//        //recorder.flashMode = SCFlashMode.on
//        updateTimerCont = 0
//        capturedImage = nil
//
//        if (!recorder.startRunning()) {
//            debugPrint("Recorder error: ", recorder.error)
//        }
//        timeLabel.text = "0"+String(seconds)
//        postBokRedCircule.isHidden = true
//        recorder.session = session
//        recorder.device = AVCaptureDevicePosition.front
//        recorder.videoConfiguration.size = CGSize(width: 200,height: 200)
//        recorder.delegate = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = false
       // recorder.stopRunning()
        recorder.maxRecordDuration = CMTime.init(seconds: 5.0, preferredTimescale: CMTimeScale.init())
        session.removeAllSegments()
        seconds = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTapGesutre(gestureReconizer: UITapGestureRecognizer) {
        self.collectionView.isHidden = true
    }
    
    func checkMediaCount() {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.postbokRef.child(accountId!).observe(.value, with: { (snapshot: DataSnapshot!) in
            print(snapshot.childrenCount)
            if snapshot.childrenCount > 290 {
                if UserDefaults.standard.value(forKey: POSTBOK_ACCOUNT_TYPE) as? String == FREE_ACCOUNT {
                    self.mediaLimitOver = true
                }
                
            }
        })
    }
    
    
    
    func uploadDataToFirebase(uniqueId: String, thumbLink: String, mediaType: String, videoData: NSData?, thumbData: Data?) {
        
//        if !Connectivity.isConnectedToNetwork() {
//            self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
//            return
//        }
        
        if !Connectivity.isConnectedToInternet() {
            //self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
            return
        }
        if mediaLimitOver! {
            return
        }
        
        uniquePostbokId = DBProvider.Instance.postbokRef.childByAutoId().key
        let lPostbok = Postbok()
        lPostbok.mediaType = mediaType
        lPostbok.mediaPath = ""
        lPostbok.postId = uniquePostbokId!
        lPostbok.postText = ""
        lPostbok.thumbImage = ""
        
        PostbokDBhandler.Instance.adPostbokMedia(postbokDict: lPostbok)
        
        
        if mediaType == "video" {
            PostbokDBhandler.Instance.uploadPostbokVideo(dataToUpload: videoData! as Data, uniqueId: UUID().uuidString, postbokId: uniquePostbokId!, thumbData: thumbData!)
        }
        else {
            let imageData = UIImageJPEGRepresentation(capturedImage!, 0.75)
             PostbokDBhandler.Instance.uploadPostbokImage(dataToUpload: imageData!, uniqueId: UUID().uuidString, postbokId: uniquePostbokId!)
        }
       
    }
    
    
    @IBAction func openFlash(_ sender: UIButton) {
        if recorder.flashMode.hashValue == 3 {
            recorder.flashMode = .off
        }
        else {
            recorder.flashMode = .light
        }
        
    }
    
    @IBAction func ShowFilters(_ sender: UIButton) {
        collectionView.isHidden = !collectionView.isHidden
    }
    
    
    @IBAction func SwitchCamera(_ sender: UIButton) {
        recorder.switchCaptureDevices()
        if recorder.device.rawValue == 2 {
            flashBtn.isHighlighted = true
            flashBtn.isEnabled = false
        }
        else {
            flashBtn.isHighlighted = false
            flashBtn.isEnabled = true
        }
        recorder.flashMode = .off
    }
    
    @IBAction func RecordVideo(_ sender: UIButton) {
        if mediaLimitOver! {
            return
        }
        if seconds > 59 {
            return
        }
        
        print("recording start")
        recorder.record()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @IBAction func PauseVideo(_ sender: UIButton) {
        print("recording stopped")
        
        if seconds <= 1 {
            isVideo = false
            recorder.capturePhoto { (error, img) in
                self.capturedImage = img
                self.capturedImage = self.swipeFilterView.renderedUIImage()
                self.thumbImageView.isHidden = false
                self.thumbImageView.image = self.swipeFilterView.renderedUIImage()
                self.seconds = 0
                self.timer?.invalidate()
                self.isVideo = false
                //self.performSegue(withIdentifier: "goToPlayer", sender: self)
                self.uploadDataToFirebase(uniqueId: "", thumbLink: "", mediaType: "image", videoData: nil, thumbData: nil)
            }
        }
        else {
           recorder.pause()
            isVideo = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
                    if (error == nil) {
                        let asset = AVAsset.init(url: url!)
                        let lFilter = self.swipeFilterView.selectedFilter
                        let export = SCAssetExportSession.init(asset: asset)
                        var sVideoCon: SCVideoConfiguration?
                        sVideoCon?.filter = lFilter
                        export.videoConfiguration.filter = lFilter
                        export.videoConfiguration.preset = SCPresetHighestQuality
                        export.audioConfiguration.preset = SCPresetHighestQuality
                        export.outputUrl = url!
                        export.outputFileType = AVFileTypeMPEG4
                        export.contextType = SCContextType.auto
                        self.compressVideoWithUrl(outputFileURL: export.outputUrl!)
                        
                    } else {
                        debugPrint(error ?? "this is default value of error in saving")
                    }
                }
                
            })
            
//            session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
//                //self.compressVideoWithUrl(outputFileURL: url!)
//                if (error == nil) {
//                    self.compressVideoWithUrl(outputFileURL: url!)
//
//                } else {
//                    debugPrint(error ?? "this is default value of error in saving")
//                }
//            }
            
            //recorder.pause()
            seconds = 0
            timer?.invalidate()
            //self.compressVideoWithUrl(outputFileURL: session.outputUrl)
        }
        if !Connectivity.isConnectedToInternet() {
            self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
            return
        }
        if mediaLimitOver! {
            self.view.makeToast("Your media limit is over", duration: 2.0, position: .bottom)
            recordingBtn.layer.borderWidth = 0.0
            timeView.isHidden = true
            return
        }
        recordingBtn.layer.borderWidth = 0.0
//        processingView.isHidden = false
//        overLayerView.isHidden = false
//        self.loadingGif.loadGif(name: "loadinganimation")
//       // postBokRedCircule.isHidden = false
//       // imgToastView.isHidden = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//            self.imgToastView.isHidden = false
//            self.processingView.isHidden = true
//            self.overLayerView.isHidden = true
//            self.processinglabel.text = "Processing"
//            self.loadingGif.loadGif(name: "loadinganimation")
//        })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.processinglabel.text = "Stored"
//            self.loadingGif.image = UIImage(named: "whiteCheck")
//        })
        if isVideo! {
            self.view.makeToast("Video recorded", duration: 2.0, position: .bottom)
            imgToastView.image = UIImage(named: "Video Toast.png")
        }
        else {
            self.view.makeToast("Image captured", duration: 2.0, position: .bottom)
            imgToastView.image = UIImage(named: "Image Toast.png")
        }
        
        timeView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.imgToastView.isHidden = true
            self.thumbImageView.isHidden = true
        })
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
    
    func updateProgress() {
        seconds += 1
       // let tt = Float(seconds)/Float(60)
        if seconds >= 1 {
            recordingBtn.layer.borderColor = UIColor.red.cgColor
            recordingBtn.layer.borderWidth = 10.0
            timeView.isHidden = false
        }
        if seconds > 59 {
            
            if updateTimerCont == 1 {
                return
            }
            recorder.pause()
            timer?.invalidate()
            updateTimerCont = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                //self.GoForward(self.goForwardBtn)
            })
            
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
        
        var thumbImage = self.videoPreviewUIImage(moviePath: tempUrl as URL)
        if #available(iOS 11.0, *) {
            thumbImage?.ciImage?.applyingFilter((swipeFilterView.selectedFilter?.ciFilter?.name)!)
        } else {
            let filter = swipeFilterView.selectedFilter?.ciFilter
            filter?.setValue(CIImage(image: thumbImage!), forKey: kCIInputImageKey)
           // filter.setValue(20.0, forKey: kCIInputRadiusKey)
            thumbImage = UIImage(ciImage: (filter?.outputImage)!)
        }
        //  self.stopLoadingIndicator()
        let thumbData = UIImageJPEGRepresentation(thumbImage!, 0.2)

        
        guard let newData = NSData(contentsOf: tempUrl as URL) else {
            return
        }
        
        //print("File size before compression: \(Double(data.length / 1048576)) mb")
       // let lFilter = self.swipeFilterView.selectedFilter?.ciFilter
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: tempUrl as URL, outputURL: compressedURL, filter: (swipeFilterView.selectedFilter?.ciFilter)!) { (exportSession) in
            
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
    
    func compressVideo(inputURL: URL, outputURL: URL, filter: CIFilter, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        //let filter = CIFilter(name: "CIPhotoEffectChrome")!
        let composition = AVVideoComposition(asset: urlAsset, applyingCIFiltersWithHandler: { request in
            
            // Clamp to avoid blurring transparent pixels at the image edges
            let source = request.sourceImage.clampingToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            
            // Vary filter parameters based on video timing
//            let seconds = CMTimeGetSeconds(request.compositionTime)
//            filter.setValue(seconds * 10.0, forKey: kCIInputRadiusKey)
            
            // Crop the blurred output to the bounds of the original image
            let output = filter.outputImage!.cropping(to: request.sourceImage.extent)
            
            // Provide the filter output to the composition
            request.finish(with: output, context: nil)
        })
        //////////////////////////////////////////////////////////////////////////////////////////////
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = composition
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


}
extension NewCameraVC: SCRecorderDelegate {
    
    func recorder(_ recorder: SCRecorder, didAppendVideoSampleBufferIn session: SCRecordSession) {
        updateTimeText(session)
    }
    
    func updateTimeText(_ session: SCRecordSession) {
        self.timeLabel.text = String(session.duration.seconds)
        if seconds < 10 {
            timeLabel.text = "0"+String(seconds)
        }
        else {
            timeLabel.text = String(seconds)
        }
        
    }
}

extension NewCameraVC: SCRecorderToolsViewDelegate {
    func recorderToolsView(_ recorderToolsView: SCRecorderToolsView, didTapToFocusWith gestureRecognizer: UIGestureRecognizer) {
        print("hi")
    }
}

extension NewCameraVC: SCSwipeableFilterViewDelegate {
    func swipeableFilterView(_ swipeableFilterView: SCSwipeableFilterView, didScrollTo filter: SCFilter?) {
        swipeFilterView.selectedFilter = filter
        recorder.scImageView = swipeableFilterView
        swipeFilterView.ciImage = CIImage(color: CIColor.blue())
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("hidd")
    }
}

extension NewCameraVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return swipeFilterView.filters!.count
        //return localFilters.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        let imgView = cell.viewWithTag(1) as! UIImageView
        
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        let tempImage = UIImage(named: "flower.jpeg")
        let sFilter = swipeFilterView.filters![indexPath.item] as! SCFilter
        let sepiaFilter = sFilter.ciFilter
        if sepiaFilter == nil {
            imgView.image = tempImage
            return cell
        }
        let ciInput = CIImage(image: tempImage!)
        sepiaFilter?.setValue(ciInput, forKey: "inputImage")
        // sepiaFilter?.setValue(0.9, forKey: kCIInputIntensityKey)
        let cmage = sepiaFilter?.outputImage
        
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage!, from: cmage!.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        imgView.image = image
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //selectedCardImageName = String(indexPath.item+104)+".jpg"
        
        if indexPath.item == 0 {
            swipeFilterView.selectedFilter = SCFilter.empty()
        }
        else {
            self.swipeFilterView.selectedFilter = swipeFilterView.filters![indexPath.item] as? SCFilter
        }
        
        
        
    }
}

