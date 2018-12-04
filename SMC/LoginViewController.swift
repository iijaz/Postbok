//
//  LoginViewController.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/27/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit
import AccountKit

class LoginViewController: UIViewController, AKFViewControllerDelegate, CheckUserExistDelegate {
    
    @IBOutlet weak var takingSmcLabel: UILabel!
    var accountKit: AKFAccountKit!
    var pendingLoginViewController: AKFViewController?
    var authorizationCode: String?
    
    @IBOutlet weak var cardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //cardView.roundViewAndSetShadow()
        
       // cardView.roundViewAndSetShadow()

        if (accountKit == nil) {
            accountKit = AKFAccountKit.init(responseType: AKFResponseType.accessToken)
        }
        pendingLoginViewController = accountKit?.viewControllerForLoginResume() as? AKFViewController
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDBHandler.Instance.checkUserExistDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //delegate account kit
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        
        loginViewController.delegate = self
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        proceedToNext()
        
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!){
        proceedToNext()
        
    }
    
    func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        print("error in login")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "goToPrivacy" {
            let nextScene = segue.destination as! TermsAndPrivacyViewController
            nextScene.lController = "Login"
        }
    }
    // this method is for login from phone number
    
    func loginWithPhone() {
        let preFillPhoneNumber: AKFPhoneNumber? = nil
        let inputState: String = UUID().uuidString
        let viewController = accountKit?.viewControllerForPhoneLogin(with: preFillPhoneNumber, state: inputState)
        self.prepareLoginViewController(loginViewController: viewController as! AKFViewController)
        self.present(viewController!, animated: true, completion: nil)
    }
    //after successfull athentication this piece of code will run
    func proceedToNext() {
        takingSmcLabel.isHidden = false
        accountKit = AKFAccountKit.init(responseType: AKFResponseType.accessToken)
        accountKit.requestAccount({ (account, error) in
        UserDefaults.standard.set(account?.phoneNumber?.stringRepresentation(), forKey: USER_PHONE_NUMBER)
        let phoneNum = account?.phoneNumber?.stringRepresentation().replacingOccurrences(of: "+", with: "")
        UserDefaults.standard.set(phoneNum, forKey: USER_ACCOUNT_ID)
        UserDBHandler.Instance.isUserExist(userId: (phoneNum)!)
        })
    }
    
    func checkUserExist(isExist: Bool) {
        if isExist {
            let userId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
            UserDBHandler.Instance.setFcmTokenToFirebase(userId: userId)
            self.performSegue(withIdentifier: "goToHomeScreen1", sender: nil)
        }
        else {
            createNewUser()
        }
    }
    
    func createNewUser() {
        
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        
        let phoneNumber = UserDefaults.standard.value(forKey: USER_PHONE_NUMBER) as! String
        let fcmToken = UserDefaults.standard.value(forKey: USER_FCM_TOKEN) as? String
        
        let lUser = User()
        lUser.activities = ""
        lUser.answers = "0"
        lUser.bio = ""
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
        lUser.profile = ""
        lUser.region = TimeZone.current.identifier
        lUser.replies = ""
        lUser.specialists = ""
        lUser.websites = ""
        lUser.username = ""
        lUser.mFcmId = fcmToken!
        lUser.device = "iphone"
        lUser.profession = ""
        UserDBHandler.Instance.addNewUserToFirebaseDatabase(user: lUser)
        self.performSegue(withIdentifier: "goToHomeScreen1", sender: nil)

    }
    
    func getUserName(userName: String) {
        let userId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        UserDBHandler.Instance.setFcmTokenToFirebase(userId: userId)
        UserDefaults.standard.setValue(userName, forKey: USER_UNIQUE_NAME)
        UserDefaults.standard.setValue(userName, forKey: USER_SERVER_NAME)
        self.performSegue(withIdentifier: "goToHomeScreen1", sender: nil)
        
    }
    @IBAction func LoginWithPhone(_ sender: UIButton) {
        loginWithPhone()
    }
    @IBOutlet weak var LoginWithFacebook: UIButton!

    @IBAction func PrivacyAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToPrivacy", sender: nil)
    }
}



extension UIView {
    func roundViewAndSetShadow() {
//        self.layer.cornerRadius = 10.0
//        self.layer.shadowColor = UIColor.init(colorLiteralRed: 205.0/255.0, green: 71.0/255.0, blue: 39.0/255.0, alpha: 1.0).cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowRadius = 5
//        self.backgroundColor = UIColor.init(colorLiteralRed: 205.0/255.0, green: 71.0/255.0, blue: 39.0/255.0, alpha: 1.0)
    }
}

