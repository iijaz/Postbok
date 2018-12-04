//
//  Common.swift
//  CodeVise
//
//  Created by JuicePhactree on 11/4/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit

class Common: NSObject {

    public static func convertDate(dateInteger: NSNumber)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm"
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return dateFormatter.string(from: Date(timeIntervalSince1970: (TimeInterval(dateInteger.intValue / 1000))))
    }
    
    public static func convertDateToString(lDate: Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm"
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        return dateFormatter.string(from: lDate)
    }
    
    public static func getMyDate()->MyDate {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekDay = calendar.component(.weekdayOrdinal, from: date)
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let ldate = MyDate()
        ldate.date = String(day)
        ldate.day = String(weekDay)
        ldate.hours = String(hours)
        ldate.minutes = String(minutes)
        ldate.months = String(month)
        ldate.seconds = String(seconds)
        ldate.time = String(Date().millisecondsSince1970)
        ldate.year = String(year)
        ldate.timezoneOffset = TimeZone.current.abbreviation()!
        return ldate
    }
    
    class func sendPusNotification(userNumber: String, title:String,body:String, fcmID: String) {
        //return
        var request = URLRequest(url: URL(string: PUSH_NOTIFICATION_URL)!)
        
        if !body.contains("activity") {
            return
            
        }
        
        request.httpMethod = "POST"
        
        let postString = "token=\(fcmID)&title=\(title)&body=\(body)&userNumber=\(userNumber)&"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error ?? "" as! Error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString ?? "")")
        }
        
        task.resume()
    }
    
    class func sendPusNotificationToAndroid(userNumber: String, title:String,body:String, fcmID: String) {
       // return
        if body != "Added new happening" {
            return
        }
        var request = URLRequest(url: URL(string: ANDROID_PUSH_NOTIFICATION_URL)!)
        
        request.httpMethod = "POST"
        let poststrings = "user_reg_id=\(fcmID)&post_content=\(title)&message_body=\(body)&sender_name=\(userNumber)&"
        let poststringss = "user_reg_id=\(fcmID)&post_content=\(title)&message_body=\(body)&sender_name=\(userNumber)&"
        request.httpBody = poststrings.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error ?? "" as! Error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString ?? "")")
        }
        
        task.resume()
    }
    
    class func sendPusNotificationPingToAndroid(userNumber: String, title:String,body:String, fcmID: String) {
        // return
//        if body != "Added new happening" {
//            return
//        }
        
        if !body.contains("activity") {
            return
            
        }
        
        let acountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        let activityStr = "LikeProfileViewActivity"
        let titleStr = "SMC Ping"
        let todayTime = Date().millisecondsSince1970
        var request = URLRequest(url: URL(string: ANDROID_PUSH_NOTIFICATION_PING_URL)!)
        
        request.httpMethod = "POST"
       // let poststrings = "user_reg_id=\(fcmID)&post_content=\(title)&message_body=\(body)&sender_name=\(userNumber)&"
        let poststrings = "user_reg_id=\(fcmID)&title=\(titleStr)&message=\(body)&sentTo=\(userNumber)&sentBy=\(acountId)&activity=\(activityStr)&timestamp=\(todayTime)&"
        request.httpBody = poststrings.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error ?? "" as! Error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString ?? "")")
        }
        
        task.resume()
    }
    
    class func ChangeTabIcons(vc: UIViewController) {
        
        let userdict = UserDefaults.standard.value(forKey: USER_DICT)
        let lUser = User(userdict: userdict as! NSDictionary)
        
        if lUser.activities == "1" || lUser.replies == "1" {
            vc.tabBarController?.tabBar.items![4].image = UIImage(named: "home_with_notification.jpg")
            vc.tabBarController?.tabBar.items?[4].image = vc.tabBarController?.tabBar.items?[4].image?.withRenderingMode(.alwaysOriginal)
            
            vc.tabBarController?.tabBar.items![4].selectedImage = UIImage(named: "coloured_home_with_notification.jpg")
            vc.tabBarController?.tabBar.items?[4].selectedImage = vc.tabBarController?.tabBar.items?[4].selectedImage?.withRenderingMode(.alwaysOriginal)
        }
            
        else {
            
            vc.tabBarController?.tabBar.items![4].image = UIImage(named: "profile_icon__gr.png")
            vc.tabBarController?.tabBar.items?[4].image = vc.tabBarController?.tabBar.items?[4].image?.withRenderingMode(.alwaysOriginal)
            
            vc.tabBarController?.tabBar.items![4].selectedImage = UIImage(named: "selected4.png")
            vc.tabBarController?.tabBar.items?[4].selectedImage = vc.tabBarController?.tabBar.items?[4].selectedImage?.withRenderingMode(.alwaysOriginal)
            
        }
        
        if lUser.notification == "1" {
            vc.tabBarController?.tabBar.items![3].selectedImage = UIImage(named: "coloured_messeages_with_notification.png")
            vc.tabBarController?.tabBar.items?[3].selectedImage = vc.tabBarController?.tabBar.items?[3].selectedImage?.withRenderingMode(.alwaysOriginal)
            
            vc.tabBarController?.tabBar.items![3].image = UIImage(named: "messeages_with_notification.png")
            vc.tabBarController?.tabBar.items?[3].image = vc.tabBarController?.tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
        }
            
        else {
            vc.tabBarController?.tabBar.items![3].image = UIImage(named: "messeges_icon__gr.png")
            vc.tabBarController?.tabBar.items?[3].image = vc.tabBarController?.tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
            
            vc.tabBarController?.tabBar.items![3].selectedImage = UIImage(named: "selected3.png")
            vc.tabBarController?.tabBar.items?[3].selectedImage = vc.tabBarController?.tabBar.items?[3].selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    
}
