//
//  SupportViewController.swift
//  SMC
//
//  Created by JuicePhactree on 4/13/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var supportWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL (string: "https://www.thesmc.xyz");
        let request = URLRequest(url: url! as URL)
        supportWebView.loadRequest(request)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        // Do any additional setup after loading the view.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func GoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
