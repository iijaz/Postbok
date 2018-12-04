//
//  CameraViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/13/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit
import SCRecorder

class CameraViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let session = SCRecordSession()
    let recorder = SCRecorder()
    let player = SCPlayer()
    var timer: Timer?
    var seconds = 0
    var calledfrom: String?
    var questionId: String?
    var selectedUser: NSDictionary?
    var updateTimerCont: Int = 0
    var capturedImage: UIImage?

    @IBOutlet weak var pgrBar: UIProgressView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var goForwardBtn: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var flashBtn: UIButton!
    
    override func viewDidLayoutSubviews() {
        recorder.previewView = previewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //recorder.commitConfiguration()
        self.tabBarController?.tabBar.isHidden = true
        recorder.flashMode = SCFlashMode.on
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        recorder.commitConfiguration()
        //recorder.flashMode = SCFlashMode.on
        updateTimerCont = 0
        capturedImage = nil
        self.tabBarController?.tabBar.isHidden = true
        if calledfrom == "question" {
            recordLabel.text = "Record Response"
        }
        else {
            recordLabel.text = "Update Your SMC"
        }
        
        if (!recorder.startRunning()) {
            debugPrint("Recorder error: ", recorder.error)
        }
        goForwardBtn.isHidden = true
        timeLabel.text = "0"+String(seconds)
        
        recorder.session = session
        recorder.device = AVCaptureDevicePosition.front
        recorder.videoConfiguration.size = CGSize(width: 800,height: 800)
        recorder.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = false
        recorder.stopRunning()
        recorder.maxRecordDuration = CMTime.init(seconds: 5.0, preferredTimescale: CMTimeScale.init())
        session.removeAllSegments()
        pgrBar.progress = 0.0
        seconds = 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            
        
            let tabBarr = gestureReconizer.view as? UITabBar
            if tabBarr?.selectedItem?.tag == 1 {
                print("yahooo")
            }
            
            print("pakistan return")
            return
        }
        print("pakistan")
    }
    
    @IBAction func openFlash(_ sender: UIButton) {
        //recorder.beginConfiguration()
        if recorder.flashMode.hashValue == 3 {
            recorder.flashMode = .off
        }
        else {
            recorder.flashMode = .light
        }
        
       // recorder.beginConfiguration()
      //  recorder.commitConfiguration()
        
    }
    
    @IBAction func SwitchCamera(_ sender: UIButton) {
        recorder.switchCaptureDevices()
        if recorder.device.rawValue == 2 {
           // flashBtn.isHidden = true
            flashBtn.isHighlighted = true
            flashBtn.isEnabled = false
        }
        else {
           // flashBtn.isHidden = false
            flashBtn.isHighlighted = false
            flashBtn.isEnabled = true
        }
        

        recorder.flashMode = .off
    }
    
    @IBAction func RecordVideo(_ sender: UIButton) {
        if seconds > 59 {
            return
        }
//        if seconds > 59 {
//
//            session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
//                if (error == nil) {
//                    self.compressVideoWithUrl(outputFileURL: url!)
//
//                } else {
//                    debugPrint(error ?? "this is default value of error in saving")
//                }
//
//            }
//            return
//        }
        print("recording start")
        recorder.record()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @IBAction func PostAction(_ sender: UIButton) {
        self.informativeAlert(msg: "This feature is under maintenance")
    }
    @IBAction func AttachementAction(_ sender: UIButton) {
        self.informativeAlert(msg: "This feature is under maintenance")
    }
    
    func informativeAlert(msg: String) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { (UIAlertAction) in
            //alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func PauseVideo(_ sender: UIButton) {
        print("recording stopped")
        if questionId == nil {
            if seconds <= 1 {
                recorder.capturePhoto { (error, img) in
                    self.capturedImage = img
                    self.performSegue(withIdentifier: "goToPlayer", sender: self)
                }
            }
        }
        
        
        recorder.pause()
        timer?.invalidate()
    }
    
    
    @IBAction func GoForward(_ sender: Any) {
        //self.performSegue(withIdentifier: "goToPlayer", sender: self)
        
        session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
            if (error == nil) {
                self.compressVideoWithUrl(outputFileURL: url!)
                
            } else {
                debugPrint(error ?? "this is default value of error in saving")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayer" {
            let nextScene = segue.destination as! PlayVideoViewController
            nextScene.questionId = questionId
            nextScene.selectedUser = selectedUser
            nextScene.capturedImage = capturedImage
        }
    }
    
    
    @IBAction func GoBack(_ sender: UIButton) {
        
        if calledfrom == "question" {
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
        else if calledfrom == "smc" {
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
            //self.navigationController?.popToRootViewController(animated: true)
        }
        else {
           self.tabBarController?.selectedIndex = 0
        }
        
    }
    
    func updateProgress() {
        seconds += 1
        let tt = Float(seconds)/Float(60)
        pgrBar.progress = tt
        if seconds > 59 {
            
            if updateTimerCont == 1 {
                return
            }
            recorder.pause()
            timer?.invalidate()
            updateTimerCont = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.GoForward(self.goForwardBtn)
            })
            
        }
    }
    
    func compressVideoWithUrl(outputFileURL: URL) {
        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            return
        }
        
        self.saveVideoToLocal(urlData: data, uniqueId: "WATCH")
        self.performSegue(withIdentifier: "goToPlayer", sender: self)
        return
        
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
                
                
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                self.saveVideoToLocal(urlData: compressedData, uniqueId: "WATCH")
                self.performSegue(withIdentifier: "goToPlayer", sender: self)
                
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
        DispatchQueue.main.async(execute: { () -> Void in
            urlData.write(toFile: filePath, atomically: true);
        })
    }

}

extension CameraViewController: SCRecorderDelegate {
    
    func recorder(_ recorder: SCRecorder, didAppendVideoSampleBufferIn session: SCRecordSession) {
        updateTimeText(session)
    }
    
    func updateTimeText(_ session: SCRecordSession) {
        self.timeLabel.text = String(session.duration.seconds)
        if seconds > 3 {
            goForwardBtn.isHidden = false
        }
        if seconds < 10 {
            timeLabel.text = "0"+String(seconds)
        }
        else {
           timeLabel.text = String(seconds)
        }
        
    }
}
