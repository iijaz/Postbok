//
//  PostbokSettingsVC.swift
//  SMC
//
//  Created by JuicePhactree on 9/20/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit

class PostbokSettingsVC: UIViewController {

    @IBOutlet weak var proUpgradeBtn: UIButton!
    
    @IBOutlet weak var firstSwipeViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondSwipeViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var freePlanImageView: UIImageView!
    
    @IBOutlet weak var mediumPlanImageView: UIImageView!
    
    @IBOutlet weak var proPlanImageView: UIImageView!
    
    @IBOutlet weak var FreePlanBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var thirdSwipeViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var freePlanView: UIView!
    
    @IBOutlet weak var mediumPlanView: UIView!
    @IBOutlet weak var proPlanView: UIView!
    
    var isLeft: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let navColor = UIColor.init(red: 204.0/255.0, green: 54.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        let str = UserDefaults.standard.value(forKey: POSTBOK_ACCOUNT_TYPE) as? String
        if str == PRO_ACCOUNT {
            //proUpgradeBtn.imageView?.image = UIImage(named: "Active Button.jpg")
            proUpgradeBtn.setTitle("Active", for: .normal)
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        FreePlanBtn.layer.cornerRadius = 10.0
        mediumBtn.layer.cornerRadius = 10.0
        proUpgradeBtn.layer.cornerRadius = 10.0
        
        freePlanImageView.layer.cornerRadius = 20.0
        mediumPlanImageView.layer.cornerRadius = 20.0
        proPlanImageView.layer.cornerRadius = 20.0
        
        freePlanView.layer.cornerRadius = 20.0
        mediumPlanView.layer.cornerRadius = 20.0
        proPlanView.layer.cornerRadius = 20.0

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let str = UserDefaults.standard.value(forKey: POSTBOK_ACCOUNT_TYPE) as? String
        if str == PRO_ACCOUNT {
           proUpgradeBtn.setTitle("Active", for: .normal)
            //proUpgradeBtn.imageView?.image = UIImage(named: "Active Button.jpg")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if firstSwipeViewConstraint.constant < 0 {
                    UIView.animate(withDuration: 0.5,
                                   delay: TimeInterval(0),
                                   options: UIViewAnimationOptions.transitionCurlDown,
                                   animations: {
                                    self.firstSwipeViewConstraint.constant = self.firstSwipeViewConstraint.constant+500
                                    self.secondSwipeViewConstraint.constant = self.secondSwipeViewConstraint.constant+500
                                    self.thirdSwipeViewConstraint.constant = self.thirdSwipeViewConstraint.constant+500
                                    
                                    self.view.layoutIfNeeded()
                    },
                                   completion: { (true) in
                    })
                    
                }
                print("swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                if thirdSwipeViewConstraint.constant > 0 {
                    UIView.setAnimationsEnabled(true)
                    UIView.animate(withDuration: 0.5,
                                   delay: TimeInterval(0),
                                   options: UIViewAnimationOptions.transitionCurlDown,
                                   animations: {
                                    self.firstSwipeViewConstraint.constant = self.firstSwipeViewConstraint.constant-500
                                    self.secondSwipeViewConstraint.constant = self.secondSwipeViewConstraint.constant-500
                                    self.thirdSwipeViewConstraint.constant = self.thirdSwipeViewConstraint.constant-500
                                    
                                    self.view.layoutIfNeeded()
                    },
                                   completion: { (true) in
                    })
                }
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    @IBAction func GoBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func goToContacts(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInvite", sender: self)
    }
    
    
    @IBAction func goToInvite(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInvite", sender: self)
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

extension PostbokSettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }
    
}
