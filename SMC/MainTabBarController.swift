//
//  MainTabBarController.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/27/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.selectedIndex = 4
        selectedIndex = 4
       // UITabBar.appearance().layer.borderWidth = 0.0
       // UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().backgroundColor = UIColor.black
        UITabBar.appearance().barTintColor = UIColor.init(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
       // UITabBar.appearance().tintColor = UIColor.black
        for i in 0 ..< 5 {
            //tabBar.items?[i].selectedImage = tabBar.items?[i].selectedImage?.withRenderingMode(.alwaysOriginal)
            tabBar.items?[i].image = tabBar.items?[i].image?.withRenderingMode(.alwaysOriginal)
            let imgString = "selected"+String(i)+".png"
            tabBar.items?[i].selectedImage = UIImage(named: imgString)
            tabBar.items?[i].selectedImage = tabBar.items?[i].selectedImage?.withRenderingMode(.alwaysOriginal)
           // tabBar.items?[3].image = UIImage(contentsOfFile: "facebook.png")
            
            
        }
        
        self.ChangeTabBarImages()
        
        


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        //self.tabBarController?.tabBar.addGestureRecognizer(lpgr)
        
        self.tabBar.addGestureRecognizer(lpgr)
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let tabBarr = gestureReconizer.view as? UITabBar
            let loc = gestureReconizer.location(in: tabBarr)
            let screenSize: CGRect = UIScreen.main.bounds
            if loc.x > screenSize.width/2-15 && loc.x < screenSize.width/2+15 {
                self.performSegue(withIdentifier: "goToAnna", sender: self)
                self.tabBar.removeGestureRecognizer(gestureReconizer)
            }
            return
        }
        
        print("pakistan")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("acha g")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    func ChangeTabBarImages() {
        
        let userdict = UserDefaults.standard.value(forKey: USER_DICT)
        if userdict == nil {
            return
        }
        let lUser = User(userdict: userdict as! NSDictionary)
        
        if lUser.activities == "1" || lUser.replies == "1" {
            tabBar.items![4].image = UIImage(named: "home_with_notification.png")
            tabBar.items?[4].image = tabBar.items?[4].image?.withRenderingMode(.alwaysOriginal)
            
            tabBar.items![4].selectedImage = UIImage(named: "coloured_home_with_notification.png")
            tabBar.items?[4].selectedImage = tabBar.items?[4].selectedImage?.withRenderingMode(.alwaysOriginal)
        }
        
        if lUser.notification == "1" {
            tabBar.items![3].selectedImage = UIImage(named: "coloured_messeages_with_notification.png")
            tabBar.items?[3].selectedImage = tabBar.items?[3].selectedImage?.withRenderingMode(.alwaysOriginal)
            
            tabBar.items![3].image = UIImage(named: "messeages_with_notification.png")
            tabBar.items?[3].image = tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
