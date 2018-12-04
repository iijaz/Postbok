//
//  AppDelegate.swift
//  CodeVise
//
//  Created by Arslan Javed on 9/25/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID
import PDFKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GetSingleUserDelegate {

    var window: UIWindow?
    var methodCall: Bool = false
    var cameFromurl: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       // UserDefaults.standard.setValue("14372248293", forKey: USER_ACCOUNT_ID)//14372248293
        if ((UserDefaults.standard.value(forKey: POSTBOK_ACCOUNT_TYPE) as? String) != nil) {
            
        }
        else {
            UserDefaults.standard.setValue(FREE_ACCOUNT, forKey: POSTBOK_ACCOUNT_TYPE)
        }
        if ((UserDefaults.standard.value(forKey: NUMBER_OF_INVITED_USERS) as? Int) != nil) {
            
        }
        else {
            UserDefaults.standard.set(0, forKey: NUMBER_OF_INVITED_USERS)
        }
        
        
        FHSTwitterEngine.shared().permanentlySetConsumerKey("evq8IttiVGXrA1ozDifwvNRm8", andSecret: "xYEGIJaTjFuK0LXbncNIquHPFbAwQv3joFHwHNoYLuZXgR02k6")
        FHSTwitterEngine.shared().loadAccessToken()
        PDKClient.configureSharedInstance(withAppId: "4977449986619881680")
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        UserDBHandler.Instance.setOnlineStatus(status: "true")
        UserDefaults.standard.setValue(false, forKey: "isNewUser")
        UserDefaults.standard.setValue("0", forKey: "constraintValue")
        UserDefaults.standard.setValue("0", forKey: "userConstraintValue")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if(UserDefaults.standard.object(forKey: INITIAL_CONTROLLER) != nil) {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: UserDefaults.standard.value(forKey: INITIAL_CONTROLLER) as! String)
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        }
        else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "toturialScreen")
            self.window?.rootViewController = initialViewController
        }
        
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "newCamera")
//        self.window?.rootViewController = initialViewController
        // newCamera
        if #available(iOS 10.0, *) {
            
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
            
            UNUserNotificationCenter.current().getDeliveredNotifications {
                (notifications) in
                print("notifications arrived")
            }
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        //UIApplication.shared.statusBarStyle = .lightContent
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,selector: #selector(tokenRefreshNotification),name: NSNotification.Name.InstanceIDTokenRefresh,object: nil)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "testing")
//        self.window?.rootViewController = initialViewController
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        UserDBHandler.Instance.setOnlineStatus(status: "false")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.setValue("a", forKey: "controller")
        UserDBHandler.Instance.setOnlineStatus(status: "false")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UserDBHandler.Instance.setOnlineStatus(status: "true")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UserDBHandler.Instance.setOnlineStatus(status: "true")
        if let accountdId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as? String{
            methodCall = true
            cameFromurl = false
            UserDBHandler.Instance.getSingleUserDelegate = self
            UserDBHandler.Instance.getSingleUser(userId: accountdId)
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.setValue("a", forKey: "controller")
        UserDBHandler.Instance.setOnlineStatus(status: "false")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        methodCall = false
        
        let urlPath : String = url.host as String!
//        UserDBHandler.Instance.getSingleUserDelegate = self
//        UserDBHandler.Instance.getSingleUser(userId: urlPath)
        
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        print("hihi")
        cameFromurl = true
        UserDBHandler.Instance.getSingleUserDelegate = self
        
        let arrayOfStrings = userActivity.webpageURL?.absoluteString.components(separatedBy: "/")
        let uName = arrayOfStrings![(arrayOfStrings?.count)!-1]
        
        print(arrayOfStrings![(arrayOfStrings?.count)!-1])
        
        UserDBHandler.Instance.getUserFormUserName(userName: uName)
        return true
    }
    
    func getSingleUser(userDict:NSDictionary) {
        var uDict: NSDictionary?
        if userDict.allKeys.count == 1 {
            
            if userDict.allKeys[0] as! String == "fcm" {
                let accountdId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as? String
                DBProvider.Instance.userRef.child(accountdId!).removeValue()
              //  UserDefaults.standard.setValue(nil, forKey: USER_DICT)
                return
            }
            
            uDict = userDict[userDict.allKeys[0]] as! NSDictionary
        }
        else {
            uDict = userDict
        }
        let lUser = User(userdict: uDict!)
        if methodCall && userDict.allKeys.count > 1 {
            UserDefaults.standard.setValue(userDict, forKey: USER_DICT)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationDot"), object: nil)
            return
        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let innerPage: UserProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        innerPage.selectedUser = lUser
        innerPage.viewControllerName = "rootViewController"
        self.window?.rootViewController = innerPage
        
    }
    
    func getSpecificSingleUser(userDict:NSDictionary) {
        UserDefaults.standard.setValue(userDict, forKey: USER_DICT)
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationDot"), object: nil)
    }
    
    //////////////////push notifications
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
       // completionHandler(UIBackgroundFetchResult.newData)
        print("notification")
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("hi")

    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
                
        // Linkedin sdk handle redirect
//        if LinkedinSwiftHelper.shouldHandle(url) {
//            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: nil, annotation: nil)
//        }
        return PDKClient.sharedInstance().handleCallbackURL(url)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("hi")
    }
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            UserDefaults.standard.set(refreshedToken, forKey: USER_FCM_TOKEN)
            print("InstanceID token: \(refreshedToken)")
        }
        
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        // Messaging.messaging().disconnect()
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.prod)
        
    }

}
extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String){
        print(fcmToken)
        UserDefaults.standard.set(fcmToken, forKey: USER_FCM_TOKEN)
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
};
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
        //completionHandler(UNNotificationPresentationOptions.alert)
    }
    /// when app is in background and notification comes
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Print message ID.
        
        //clear all notifications
        //        let center = UNUserNotificationCenter.current()
        //        center.removeAllDeliveredNotifications()
        
        //requestForSendMessage(sender: userNumber, receiver: receiverContact.number, message: message)
        //        if notiBody["title"].range(of:"Missed") != nil {
        //            print("exists")
        //        }
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToChatController"), object: contact)
        
        completionHandler()
    }
    
}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

