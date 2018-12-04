//
//  AnnaViewController.swift
//  SMC
//
//  Created by JuicePhactree on 7/13/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class AnnaViewController: UIViewController {
    @IBOutlet weak var annaBtn: UIButton!
    @IBOutlet weak var shareSocialBtn: UIButton!
    @IBOutlet weak var suggestBtn: UIButton!
    @IBOutlet weak var schedualeBtn: UIButton!
    @IBOutlet weak var throwBackBtn: UIButton!
    
    @IBOutlet weak var annaImgView: UIImageView!
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playSound(soundName: "iamanna")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            self.shareSocialBtn.isHidden = false
            self.suggestBtn.isHidden = false
            self.schedualeBtn.isHidden = false
            self.throwBackBtn.isHidden = false
        })

        let gifImage = UIImage.gif(name: "annaGif@3x")
        annaImgView.image = gifImage
        //annaBtn.setImage(gifImage, for: UIControlState.normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func AnnaAction(_ sender: UIButton) {
    }
    
    @IBAction func ShareAction(_ sender: UIButton) {
        self.playSound(soundName: "whatshare")
        let accountName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
        let someText = "www.thesmc.xyz/"+accountName!
        self.shareSMCId(shareText: someText, happening: "For quick access to all my Active social media and communication platforms, check out my Social Media card @.")
    }
    
    @IBAction func SuggestPostAction(_ sender: UIButton) {
        self.informativeAlert(msg: "This feature is under maintenance")
    }
    @IBAction func SchedualPostAction(_ sender: UIButton) {
        self.informativeAlert(msg: "This feature is under maintenance")
    }
    
    @IBAction func ThrowBackAction(_ sender: UIButton) {
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
    
    func shareSMCId(shareText:String?, happening: String?){
        
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
    
    @IBAction func GoBack(_ sender: UIButton) {
       // self.navigationController?.popViewController(animated: true)
        player?.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
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
