//
//  CreateUserNameViewController.swift
//  SMC
//
//  Created by JuicePhactree on 11/14/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class CreateUserNameViewController: UIViewController, VerifyUserNameDelegate {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var numberBtn: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var topSpaceConstant: NSLayoutConstraint!
    @IBOutlet weak var uNameExistLabel: UILabel!
    
    var loadingIndicator: UIActivityIndicatorView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.roundViewAndSetShadow()
        
        UserDBHandler.Instance.verifyUserNameDelegate = self

        let userPhoneNum = UserDefaults.standard.value(forKey: USER_PHONE_NUMBER)
        numberBtn.setTitle(userPhoneNum as? String, for: UIControlState.normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_ notification: NSNotification){
        var keyboardHeight: CGFloat?
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            topSpaceConstant.constant = -40
            
        }
        
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        topSpaceConstant.constant = 163
    }
    
    func verifyUserName(usersDict:NSDictionary) {
        for item in usersDict as NSDictionary {
            if item.value as? String == "0" {
                DoRegisteruser(exist: false)
                return
            }
            let userD = item.value as! NSDictionary
            let str = userD["name"] as? String
            if str?.lowercased() == userNameTextField.text?.lowercased().trimmingCharacters(in: .whitespaces) {
                DoRegisteruser(exist: true)
                return
            }
        }
        DoRegisteruser(exist: false)
        
    }
    
    func DoRegisteruser(exist: Bool) {
        stopLoadingIndicator()
        uNameExistLabel.text = "This username already exist please try another"
        
        if exist {
            //self.informativeAlert(msg: "This username is already exist please try another")
            self.uNameExistLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.uNameExistLabel.isHidden = true
            })
            
        }
        else {
            UserDefaults.standard.set(userNameTextField.text?.lowercased().trimmingCharacters(in: .whitespaces), forKey: USER_UNIQUE_NAME)
            UserDefaults.standard.setValue(userNameTextField.text?.trimmingCharacters(in: .whitespaces), forKey: USER_SERVER_NAME)
            self.performSegue(withIdentifier: "goToSetProfile", sender: self)
            print("this is unique")
        }
    }

    @IBAction func GoNext(_ sender: UIButton) {
        if (userNameTextField.text?.characters.count)! < 1 {
            uNameExistLabel.text = "Username cannot be empty"
            uNameExistLabel.isHidden = false
            return
        }
        showLoadingIndicater()
        UserDBHandler.Instance.verifyUserName(userId: userNameTextField.text!.trimmingCharacters(in: .whitespaces))
    }
    @IBAction func DismissKeyboard(_ sender: UIButton) {
        userNameTextField.resignFirstResponder()
    }
    
    func informativeAlert(msg: String) {
        let alertController = UIAlertController(title: "Sorry", message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { (UIAlertAction) in
            //alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
    }
    
    func stopLoadingIndicator() {
        loadingIndicator?.stopAnimating()
        self.loadingIndicator?.removeFromSuperview()
        cardView.alpha = 1.0
    }
}
