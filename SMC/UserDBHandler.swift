//
//  UserDBHandler.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/31/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol GetAllUsersDelegate:class {
    func getAllUsers(userDict:NSDictionary)
}

@objc protocol GetSingleUserDelegate:class {
    func getSingleUser(userDict:NSDictionary)
    @objc optional func getSpecificSingleUser(userDict:NSDictionary)
    @objc optional func getUpdatedUser(userDict: NSDictionary)
    
}

protocol GetNewMessageUsersDelegate:class {
    func getNewMessgedUsers(userDict:NSDictionary)
    
}



 protocol GetUpdatedUserDelegate:class {
    func getUpdatedUserVal(userDict:NSDictionary)
    
}

protocol VerifyUserNameDelegate: class {
    func verifyUserName(usersDict:NSDictionary)
}

protocol IsQuestionLikedDelegate:class {
    func isQuestionLiked(liked:Bool)
}


@objc protocol GetUserFollowingDelegate:class {
    func getUserFollowing(userFollowingId:String)
    @objc optional func getUserPendingRequests(userPendingId: String)
}

@objc protocol IsBeingFollowedDelegate:class {
    func isBeingFollowed(followed:Bool)
    @objc optional func isRequestSent(request: Bool)
}

@objc protocol CheckUserFollowingDelegate:class {
    func checkIsUserFollowing(followed:Bool)
     @objc optional func isRequested(request: Bool)
}

protocol IsAnswerLikedDelegate:class {
    func isAnswerLiked(liked:Bool)
}

protocol GetSelectedSocialNetworksDelegate:class {
    func getSelectedNetworks(networkDict:NSDictionary)
}

protocol GetUserActivitiesDelegate:class {
    func getUserActivities(userActiviyDict:NSDictionary)
}

protocol GetUserFollowingActivitiesDelegate:class {
    func getUserFollowingActivities(userFollowingActiviyDict:NSDictionary)
}

protocol GetOnlineUserDelegate:class {
    func getOnlineUser(userDict: NSDictionary)
}

protocol CheckUserExistDelegate:class {
    func checkUserExist(isExist: Bool)
    func getUserName(userName: String)
}

class UserDBHandler {
    private static let _instance = UserDBHandler()
    private init() {}
    
    weak var getAllUsersDelegate: GetAllUsersDelegate?
    weak var getSingleUserDelegate: GetSingleUserDelegate?
    weak var getUpdatedUserdelegate: GetUpdatedUserDelegate?
    weak var verifyUserNameDelegate: VerifyUserNameDelegate?
    weak var isQuestionLikedDelegate: IsQuestionLikedDelegate?
    weak var isAnswerLikedDelegate: IsAnswerLikedDelegate?
    weak var isBeingFollowedDelegate: IsBeingFollowedDelegate?
    weak var getUserFollowingDelegate: GetUserFollowingDelegate?
    weak var checkUserFollowingDelegate: CheckUserFollowingDelegate?
    weak var getSelectedSocialNetworkDelegate: GetSelectedSocialNetworksDelegate?
    weak var getUserActivitiesDelegate: GetUserActivitiesDelegate?
    weak var getUserFollowingActivitiesDelegate: GetUserFollowingActivitiesDelegate?
    weak var checkUserExistDelegate: CheckUserExistDelegate?
    weak var getNewMessagedUserDelegate: GetNewMessageUsersDelegate?
    weak var getOnlineUserDelegate: GetOnlineUserDelegate?
    
    static var Instance: UserDBHandler {
        return _instance;
    }
    
    func isUserExist(userId: String) {
        DBProvider.Instance.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.checkUserExistDelegate?.checkUserExist(isExist: snapshot.hasChild(userId))
            if snapshot.hasChild(userId) {
                DBProvider.Instance.userRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                    //let dict = snapshot.value as! NSDictionary
                   // self.checkUserExistDelegate?.getUserName(userName: dict["name"] as! String)
                   // UserDefaults.standard.setValue(dict["profile"] as! String, forKey: USER_PROFILE_URL)
                    
                })
            }
            else {
                print("ih")
            }
            
        })
    }
    
    func addNewUserToFirebaseDatabase(user: User) {
        if let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID) {
            DBProvider.Instance.userRef.child(accountId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let userDict = snapshot.value as? [String:AnyObject] {
                    if user.id == userDict[USER_USERId] as? String {
                        print("USERDB: User Already Found On Firebase Database")
                        let data: Dictionary<String, Any> = [USER_NAME: user.username,
                                                             USER_REGION: user.region,
                                                             USER_USERId: user.id,
                                                             USER_BIO: user.bio,
                                                             USER_FCM: user.mFcmId,
                                                             USER_EMAIL: user.email,
                                                             USER_INAPP: user.inApp,
                                                             USER_PHONE: user.phone,
                                                             USER_POSTS: user.posts,
                                                             USER_ONLINE: user.online,
                                                             USER_ANSWERS: user.answers,
                                                             USER_ACTIVITES: user.activities,
                                                             USER_WEBSITE: user.websites,
                                                             USER_SPECIALISTS: user.specialists,
                                                             USER_FOLLOWERS: user.followers,
                                                             USER_FOLLOWING: user.following,
                                                             USER_REPLIES: user.replies,
                                                             USER_FOLLOW_STATUS: 0,
                                                             USER_PROFILE: user.profile,
                                                             USER_NOTIFICATION: user.notification,
                                                             USER_LASTSEEN: NSNumber(value: Int(user.lastSeen)!),
                                                             USER_PASSWORD: user.password,
                                                             USER_DEVICE: user.device,
                                                             USER_PROFESSION: user.profession,
                                                             USER_ACCOUNT_TYPE: user.accountType
                        ]
                        DBProvider.Instance.userRef.child(user.id).setValue(data)
                        UserDefaults.standard.setValue(false, forKey: "isNewUser")
                    }
                    else {
                        print("USERDB: new else")
                        let data: Dictionary<String, Any> = [USER_NAME: user.username,
                                                             USER_REGION: user.region,
                                                             USER_USERId: user.id,
                                                             USER_BIO: user.bio,
                                                             USER_FCM: user.mFcmId,
                                                             USER_EMAIL: user.email,
                                                             USER_INAPP: user.inApp,
                                                             USER_PHONE: user.phone,
                                                             USER_POSTS: user.posts,
                                                             USER_ONLINE: user.online,
                                                             USER_ANSWERS: user.answers,
                                                             USER_ACTIVITES: user.activities,
                                                             USER_WEBSITE: user.websites,
                                                             USER_SPECIALISTS: user.specialists,
                                                             USER_FOLLOWERS: user.followers,
                                                             USER_FOLLOWING: user.following,
                                                             USER_REPLIES: user.replies,
                                                             USER_FOLLOW_STATUS: 0,
                                                             USER_PROFILE: user.profile,
                                                             USER_NOTIFICATION: "1",
                                                             USER_LASTSEEN: NSNumber(value: Int(user.lastSeen)!),
                                                             USER_DEVICE: user.device,
                                                             USER_PROFESSION: user.profession,
                                                             USER_ACCOUNT_TYPE: "Public"
                        ]
                        DBProvider.Instance.userRef.child(user.id).setValue(data)
                        UserDefaults.standard.setValue(true, forKey: "isNewUser")

                        
                    }
                }
                else {
                    print("USERDB: User Didn't Found On Firebase Database")
                    let data: Dictionary<String, Any> = [USER_NAME: user.username,
                                                         USER_REGION: user.region,
                                                         USER_USERId: user.id,
                                                         USER_BIO: user.bio,
                                                         USER_FCM: user.mFcmId,
                                                         USER_EMAIL: user.email,
                                                         USER_INAPP: user.inApp,
                                                         USER_PHONE: user.phone,
                                                         USER_POSTS: user.posts,
                                                         USER_ONLINE: user.online,
                                                         USER_ANSWERS: user.answers,
                                                         USER_ACTIVITES: user.activities,
                                                         USER_WEBSITE: user.websites,
                                                         USER_SPECIALISTS: user.specialists,
                                                         USER_FOLLOWERS: user.followers,
                                                         USER_FOLLOWING: user.following,
                                                         USER_REPLIES: user.replies,
                                                         USER_FOLLOW_STATUS: 0,
                                                         USER_PROFILE: user.profile,
                                                         USER_NOTIFICATION: "1",
                                                         USER_LASTSEEN: NSNumber(value: Int(user.lastSeen)!),
                                                         USER_DEVICE: user.device,
                                                         USER_PROFESSION: user.profession,
                                                         USER_ACCOUNT_TYPE: "Public"
                    ]
                    DBProvider.Instance.userRef.child(user.id).setValue(data)
                    UserDefaults.standard.setValue(true, forKey: "isNewUser")

                    
                }
            })
        }

    }
    
    func setFcmTokenToFirebase(userId: String) {
        
        let fcmToken = UserDefaults.standard.value(forKey: USER_FCM_TOKEN) as! String
        let data: Dictionary<String, Any> = ["fcm": fcmToken]
        DBProvider.Instance.userRef.child(userId).updateChildValues(data)
    }
    
    func setOnlineStatus(status: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let data: Dictionary<String, Any> = ["online": status]
        if accountId == nil {
            return
        }
       // DBProvider.Instance.userRef.child(accountId!).updateChildValues(data)
        if let dictt = UserDefaults.standard.value(forKey: USER_DICT) as? NSDictionary {
            if dictt.count > 4 {
               DBProvider.Instance.userRef.child(accountId!).updateChildValues(data)
            }
        }
    }
    
    func updateUserInFirebase(profileUrl: String, bio: String, profession: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let data: Dictionary<String, Any> = [USER_BIO: bio,
                                             USER_PROFILE: profileUrl,
                                             USER_PROFESSION: profession
                                             ]
        DBProvider.Instance.userRef.child(accountId!).updateChildValues(data)
        UserDefaults.standard.set(profileUrl, forKey: USER_PROFILE_URL)
    }
    
    func updateUserName(userName: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let data: Dictionary<String, Any> = [USER_NAME: userName,
        ]
        DBProvider.Instance.userRef.child(accountId!).updateChildValues(data)
    }
    
    func getUsers() {
        DBProvider.Instance.userRef.queryOrdered(byChild: USER_POSTS).queryLimited(toLast: 10).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getAllUsersDelegate?.getAllUsers(userDict: snapshot.value as! NSDictionary)
        }
        print("hello")
    }
    
    func getAllRegisterdUsers() {
//        DBProvider.Instance.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            self.getAllUsersDelegate?.getAllUsers(userDict: snapshot.value as! NSDictionary)
//        })
        
        DBProvider.Instance.userRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            let dictt = snapshot.value as! NSDictionary
            if dictt.allKeys.count < 3 {
                return
            }
            self.getAllUsersDelegate?.getAllUsers(userDict: snapshot.value as! NSDictionary)
        }
    }
    
    func getSingleUser(userId: String) {
        return
        DBProvider.Instance.userRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictt = snapshot.value as? NSDictionary {
                //UserDefaults.standard.set(dictt, forKey: USER_DICT)
                self.getSingleUserDelegate?.getSingleUser(userDict: snapshot.value as! NSDictionary)
                
            }
           
            })
    }
    
    func getUpdatedUserValues() {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        DBProvider.Instance.userRef.child(accountId).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            DBProvider.Instance.userRef.child(accountId).observeSingleEvent(of: .value, with: { (snapshot1) in
                let dict = snapshot1.value as! NSDictionary
                UserDefaults.standard.setValue(dict, forKey: USER_DICT)
                //self.getSingleUserDelegate?.getUpdatedUser!(userDict: dict)
                self.getUpdatedUserdelegate?.getUpdatedUserVal(userDict: dict)
            })
        }
    }
    
    func getOnlineUserStatus(userId: String) {
        //let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        DBProvider.Instance.userRef.child(userId).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            DBProvider.Instance.userRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot1) in
                let dict = snapshot1.value as! NSDictionary
                //self.getSingleUserDelegate?.getUpdatedUser!(userDict: dict)
                self.getOnlineUserDelegate?.getOnlineUser(userDict: dict)
            })
        }
    }
    
    func getSpecificSingleUser(userId: String) {
        DBProvider.Instance.userRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
          //  self.getSingleUserDelegate?.getSingleUser(userDict: snapshot.value as! NSDictionary)
            self.getSingleUserDelegate?.getSpecificSingleUser!(userDict: snapshot.value as! NSDictionary)
        })
    }
    
    func verifyUserName(userId: String) {
        DBProvider.Instance.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictt = snapshot.value as? NSDictionary {
               self.verifyUserNameDelegate?.verifyUserName(usersDict: snapshot.value as! NSDictionary)
                let dict1 = snapshot.value as! NSDictionary
                let item: NSDictionary?
                for item in dict1 as NSDictionary {
                    let userD = item.value as! NSDictionary
                    
                }
            }
            else {
                self.verifyUserNameDelegate?.verifyUserName(usersDict: ["val":"0"])
            }
            
            
            print("hello")
            
        })
    }
    
    func getUserFormUserName(userName: String) {
//        DBProvider.Instance.userRef.queryOrdered(byChild: "name").queryEqual(toValue: "p").observeSingleEvent(of: .value , with: { (snapshot) in
//           self.getSingleUserDelegate?.getSingleUser(userDict: snapshot.value as! NSDictionary)
//        })
//        DBProvider.Instance.userRef.queryEqual(toValue: "jaspreetshien", childKey: "name").observeSingleEvent(of: .value , with: { (snapshot) in
//            self.getSingleUserDelegate?.getSingleUser(userDict: snapshot.value as! NSDictionary)
//        })
        DBProvider.Instance.userRef.queryEqual(toValue: userName).queryOrdered(byChild: "name").observeSingleEvent(of: .value , with: { (snapshot) in
                       self.getSingleUserDelegate?.getSingleUser(userDict: snapshot.value as! NSDictionary)
            
                    })
    }
    
    func GetNewMessagesUsers() {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        DBProvider.Instance.userRef.child(accountId).child("message").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                self.getNewMessagedUserDelegate?.getNewMessgedUsers(userDict: dict)
            }
            else {
                let dict = ["empty":"empty"] as NSDictionary
                self.getNewMessagedUserDelegate?.getNewMessgedUsers(userDict: dict)
            }
            
        })
    }
    
    func isQuestionLiked(questionKey: String, userId: String) {
        DBProvider.Instance.userRef.child(userId).child(USER_LIKE_NODE).child(questionKey).observeSingleEvent(of: .value, with: { (snapshot) in
            if let likedVal = snapshot.value as? String {
                print(likedVal)
                self.isQuestionLikedDelegate?.isQuestionLiked(liked: true)
            }
            else {
                self.isQuestionLikedDelegate?.isQuestionLiked(liked: false)
            }
        })
    }
    
    func isAnswerLiked(answerKey: String, userId: String) {
        DBProvider.Instance.userRef.child(userId).child(USER_LIKE_NODE).child(answerKey).observeSingleEvent(of: .value, with: { (snapshot) in
            if let likedVal = snapshot.value as? String {
                print(likedVal)
                self.isAnswerLikedDelegate?.isAnswerLiked(liked: true)
            }
            else {
                self.isAnswerLikedDelegate?.isAnswerLiked(liked: false)
            }
        })
    }
    
    func setLikeOfVideoQuestionInUserNode(questionKey: String, userId: String, isLiked: Bool) {
        DBProvider.Instance.userRef.child(userId).child(USER_LIKE_NODE).child(questionKey).observeSingleEvent(of: .value, with: { (snapshot) in
            print("hi")
            if isLiked {
                DBProvider.Instance.userRef.child(userId).child(USER_LIKE_NODE).child(questionKey).setValue(questionKey)
            }
            else {
                DBProvider.Instance.userRef.child(userId).child(USER_LIKE_NODE).child(questionKey).removeValue()
            }
        })
    }
    
    func setLikeOfVideoAnswerInUserNode(answerKey: String, userId: String, isLiked: Bool) {
        DBProvider.Instance.userRef.child(userId).child(USER_LIKE_NODE).child(answerKey).observeSingleEvent(of: .value, with: { (snapshot) in
            print("hi")
            if isLiked {
                DBProvider.Instance.userRef.child(userId).child(USER_LIKE_NODE).child(answerKey).setValue(answerKey)
            }
            else {
                DBProvider.Instance.userRef.child(userId).child(USER_LIKE_NODE).child(answerKey).removeValue()
            }
        })
    }
    ///////////////////////////////////////////user following methods////////////////////////////////////////////////////////////////
    
    func getUserFollowings(userId: String) {
        DBProvider.Instance.userRef.child(userId).child(USER_USERFOLLOWING_NODE).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getUserFollowingDelegate?.getUserFollowing(userFollowingId: snapshot.key)
        }
        DBProvider.Instance.userRef.child(userId).child(USER_RECIEVED_REQUESTS).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getUserFollowingDelegate?.getUserPendingRequests!(userPendingId: snapshot.key)
        }
    }
    
    func getUserFollowers(userId: String) {
        DBProvider.Instance.userRef.child(userId).child(USER_USERFOLLOWERS_NODE).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getUserFollowingDelegate?.getUserFollowing(userFollowingId: snapshot.key)
        }
        DBProvider.Instance.userRef.child(userId).child(USER_RECIEVED_REQUESTS).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getUserFollowingDelegate?.getUserPendingRequests!(userPendingId: snapshot.key)
        }
    }
    
    func getQuestionLikeUsers(questionId: String) {
        
        DBProvider.Instance.questionsRef.child(questionId).child("Likes").observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getUserFollowingDelegate?.getUserFollowing(userFollowingId: snapshot.key)
        }

    }
    
    func isBeingFollowed(accountId: String, userId: String) {
        DBProvider.Instance.userRef.child(userId).child(USER_USERFOLLOWERS_NODE).child(accountId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let likedVal = snapshot.value as? String {
                print(likedVal)
                self.isBeingFollowedDelegate?.isBeingFollowed(followed: true)
            }
            else {
                self.isBeingFollowedDelegate?.isBeingFollowed(followed: false)
            }
        })
        
        DBProvider.Instance.userRef.child(accountId).child(USER_SENT_REQUESTS).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let requestVal = snapshot.value as? String {
                print(requestVal)
                self.isBeingFollowedDelegate?.isRequestSent!(request: true)
            }
            else {
                self.isBeingFollowedDelegate?.isRequestSent!(request: false)
            }
        })
    }
    
    func setUserFollowing(userId: String, isFollowed: Bool, accountId: String, accountType: String) {
        
        
        if accountType.lowercased() == "private" && isFollowed {
            
            DBProvider.Instance.userRef.child(accountId).child(USER_SENT_REQUESTS).child(userId).setValue(userId)
            DBProvider.Instance.userRef.child(userId).child(USER_RECIEVED_REQUESTS).child(accountId).setValue(accountId)
            DBProvider.Instance.userRef.child(userId).child(USER_FOLLOW_STATUS).setValue(1)
            return
            
        }
        else if accountType.lowercased() == "private" && !isFollowed {
            print("hi")
        }
        DBProvider.Instance.userRef.child(accountId).child(USER_USERFOLLOWING_NODE).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            print("hi")
            if isFollowed {
                DBProvider.Instance.userRef.child(accountId).child(USER_USERFOLLOWING_NODE).child(userId).setValue(userId)
                DBProvider.Instance.userRef.child(userId).child(USER_USERFOLLOWERS_NODE).child(accountId).setValue(accountId)
                DBProvider.Instance.userRef.child(userId).child("replies").setValue("1")
            }
            else {
                DBProvider.Instance.userRef.child(accountId).child(USER_USERFOLLOWING_NODE).child(userId).removeValue()
                DBProvider.Instance.userRef.child(userId).child(USER_USERFOLLOWERS_NODE).child(accountId).removeValue()
            }
            
        })
    }
    
    func acceptFollowRequest(userId: String, accountId: String) {
        
        DBProvider.Instance.userRef.child(userId).child(USER_USERFOLLOWING_NODE).child(accountId).setValue(accountId)
        DBProvider.Instance.userRef.child(accountId).child(USER_USERFOLLOWERS_NODE).child(userId).setValue(userId)
        
        DBProvider.Instance.userRef.child(userId).child(USER_SENT_REQUESTS).child(accountId).removeValue()
        DBProvider.Instance.userRef.child(accountId).child(USER_RECIEVED_REQUESTS).child(userId).removeValue()
        
        UserDBHandler.Instance.setNoOfUserFollowing(userId: accountId, isFollowed: true, accountId: userId)
        DBProvider.Instance.userRef.child(accountId).child("replies").setValue("1")
        DBProvider.Instance.userRef.child(userId).child("followerRequestStatus").setValue(1)
    }
    
    func deleteFollowRequest(userId: String, accountId: String) {
        
      DBProvider.Instance.userRef.child(userId).child(USER_USERFOLLOWING_NODE).child(accountId).removeValue()
      DBProvider.Instance.userRef.child(accountId).child(USER_USERFOLLOWERS_NODE).child(userId).removeValue()
        
      DBProvider.Instance.userRef.child(userId).child(USER_SENT_REQUESTS).child(accountId).removeValue()
      DBProvider.Instance.userRef.child(accountId).child(USER_RECIEVED_REQUESTS).child(userId).removeValue()
        
    }
    
    func setNoOfUserFollowing(userId: String, isFollowed: Bool, accountId: String) {
        DBProvider.Instance.userRef.child(accountId).child(USER_FOLLOWING).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var totalLikes = snapshot.value as? String
            if isFollowed {
                totalLikes = String(Int(totalLikes!)! + 1)
            }
            else {
                totalLikes = String(Int(totalLikes!)! - 1)
            }
            DBProvider.Instance.userRef.child(accountId).child(USER_FOLLOWING).setValue(totalLikes)
            //DBProvider.Instance.userRef.child(userId).child(USER_FOLLOWERS).setValue(totalLikes)
        })
        
        DBProvider.Instance.userRef.child(userId).child(USER_FOLLOWERS).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var totalLikes = snapshot.value as? String
            if isFollowed {
                totalLikes = String(Int(totalLikes!)! + 1)
            }
            else {
                totalLikes = String(Int(totalLikes!)! - 1)
            }
            DBProvider.Instance.userRef.child(userId).child(USER_FOLLOWERS).setValue(totalLikes)
        })
    }
    
    func checkUserFollowing(userId: String, accountId: String) {
        
        DBProvider.Instance.userRef.child(accountId).child(USER_USERFOLLOWING_NODE).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.checkUserFollowingDelegate?.checkIsUserFollowing(followed: snapshot.hasChild(userId))
        })
        DBProvider.Instance.userRef.child(accountId).child(USER_SENT_REQUESTS).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.checkUserFollowingDelegate?.isRequested!(request: snapshot.hasChild(userId))
        })
        
    }
    
    func uploadProfileImage(dataToUpload: Data, completion: ((String) -> Swift.Void)? = nil, faliure: ((String) -> Swift.Void)? = nil) {
        let accountId = UserDefaults.standard.value(forKey: USER_ACCOUNT_ID) as! String
        let newChild = accountId+".jpg"
        let newRef = DBProvider.Instance.profileImageRef.child(newChild)
        
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                faliure!("failiur")
                return
            }
            UserDefaults.standard.set(metadata.downloadURL()?.absoluteString, forKey: USER_PROFILE_URL)
            completion!("success")
        }
    }
    
    func setUserNetworks(sNetwork: [SocialNetworks], userId: String) {
        
        for network in sNetwork {
            
            let uniqueId = DBProvider.Instance.userRef.child(userId).child("SocialNetworks").childByAutoId().key
            let data: Dictionary<String, Any> = ["mNetwokMessage": network.networkMessage,
                                                 "mNetworkPath": network.networkPath,
                                                 "mNetworkProfileLink": network.networkProfileLink,
                                                 "mNetworkStatus": 1,
                                                 "mNetworkTempData": uniqueId,
                                                 "mNetworkTitle": network.networkTitle,
                                                 "mNetworkType": network.networkType,
                                                 "mAdditionalInfo1": "",
                                                 "mAdditionalInfo2": "",
                                                 "mNetworkProfileLink1": "",
                                                 "mNetworkProfileLink2": ""
            ]
            DBProvider.Instance.userRef.child(userId).child("SocialNetworks").child(uniqueId).setValue(data)
            
        }
    }
    
    func getSelectedSocialNetworks(accountId: String) {
       // let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId).child("SocialNetworks").queryOrderedByPriority().observeSingleEvent(of: .value, with: { (snapshot) in
            if  let dictt = snapshot.value as? NSDictionary {
                self.getSelectedSocialNetworkDelegate?.getSelectedNetworks(networkDict: snapshot.value as! NSDictionary)
            }
            else {
                let dict = ["value":"0"]
                self.getSelectedSocialNetworkDelegate?.getSelectedNetworks(networkDict: dict as NSDictionary)
            }
            
        })
    }
    
    func blockSelectedUser(userId: String) {
       let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child("Blocked").child(userId).setValue(userId)
        DBProvider.Instance.userRef.child(userId).child("GotBlocked").child(accountId!).setValue(accountId!)
        
        DBProvider.Instance.userRef.child(accountId!).child("Blocked").observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! NSDictionary
            UserDefaults.standard.setValue(dict, forKey: BLOCKED_USERS)
            
        })
    }
    
    func unBlockSelectedUser(userId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child("Blocked").child(userId).removeValue()
        DBProvider.Instance.userRef.child(userId).child("GotBlocked").child(accountId!).removeValue()
        
        DBProvider.Instance.userRef.child(accountId!).child("Blocked").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
              UserDefaults.standard.setValue(dict, forKey: BLOCKED_USERS)
            }
            else {
                UserDefaults.standard.setValue(nil, forKey: BLOCKED_USERS)
            }
            
            
        })
    }
    
    func reportSelectedPost(quesId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child("Reported").child(quesId).setValue(quesId)
        
        DBProvider.Instance.userRef.child(accountId!).child("Reported").observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! NSDictionary
            UserDefaults.standard.setValue(dict, forKey: REPORTED_POSTS)
            
        })
        
    }
    
    func setUserActivities(activityString: String, questionId: String, answerId: String, otherString: String, userId: String) {
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let userName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
       // let uniqueStr = DBProvider.Instance.userRef.child(accountId!).child("Activities").childByAutoId()
       // let dict = UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary
        //let lUser = User(userdict: dict)
        
//        let data: Dictionary<String, Any> = ["activities": activityString,
//                                             "activityId": uniqueStr.key,
//                                             "answerId": answerId,
//                                             "id": "",
//                                             "profilePicture": lUser.profile,
//                                             "questionId": questionId,
//                                             "userId": accountId!,
//                                             "userName": userName!
//        ]
//
//        uniqueStr.setValue(data)
        let lReceiverDate = Common.getMyDate()
        let data2: Dictionary<String, Any> = ["date": NSNumber(value: Int(lReceiverDate.date)!),
                                              "day": NSNumber(value: Int(lReceiverDate.day)!),
                                              "hours": NSNumber(value: Int(lReceiverDate.hours)!),
                                              "minutes": NSNumber(value: Int(lReceiverDate.minutes)!),
                                              "month": NSNumber(value: Int(lReceiverDate.months)!),
                                              "seconds": NSNumber(value: Int(lReceiverDate.seconds)!),
                                              "time": NSNumber(value: Int(lReceiverDate.time)!),
                                              "timezoneOffset": NSNumber(value: 500),
                                              "year": NSNumber(value: Int(lReceiverDate.year)!)
            
        ]
        
        //uniqueStr.child("date").setValue(data2)
        if accountId == userId {
            return
        }
        
        DBProvider.Instance.userRef.child(userId).child("activities").setValue("1")
        let dictt = UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary
        let lUser2 = User(userdict: dictt)
        let otherUniqueStr = DBProvider.Instance.userRef.child(userId).child("Activities").childByAutoId()
        let otherdata: Dictionary<String, Any> = ["activities": otherString,
                                             "activityId": otherUniqueStr.key,
                                             "answerId": answerId,
                                             "id": "",
                                             "profilePicture": lUser2.profile,
                                             "questionId": questionId,
                                             "userId": accountId!,
                                             "userName": userName!
        ]
        
        otherUniqueStr.setValue(otherdata)
        otherUniqueStr.child("date").setValue(data2)
        
    }
    
    func setUserFollowingActivities(activityString: String, questionId: String, answerId: String, otherString: String, userId: String) {
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let userName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
        let uniqueStr = DBProvider.Instance.userRef.child(accountId!).child("FollowActivity").childByAutoId()
        let dict = UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary
        let lUser = User(userdict: dict)
        
        let data: Dictionary<String, Any> = ["activities": activityString,
                                             "activityId": uniqueStr.key,
                                             "answerId": answerId,
                                             "id": accountId!,
                                             "profilePicture": lUser.profile,
                                             "questionId": questionId,
                                             "userId": userId,
                                             "userName": userName!
        ]
        
        uniqueStr.setValue(data)
        let lReceiverDate = Common.getMyDate()
        let data2: Dictionary<String, Any> = ["date": NSNumber(value: Int(lReceiverDate.date)!),
                                              "day": NSNumber(value: Int(lReceiverDate.day)!),
                                              "hours": NSNumber(value: Int(lReceiverDate.hours)!),
                                              "minutes": NSNumber(value: Int(lReceiverDate.minutes)!),
                                              "month": NSNumber(value: Int(lReceiverDate.months)!),
                                              "seconds": NSNumber(value: Int(lReceiverDate.seconds)!),
                                              "time": NSNumber(value: Int(lReceiverDate.time)!),
                                              "timezoneOffset": NSNumber(value: 500),
                                              "year": NSNumber(value: Int(lReceiverDate.year)!)
            
        ]
        
        uniqueStr.child("date").setValue(data2)
        if accountId == userId {
            return
        }
        
        
        let otherUniqueStr = DBProvider.Instance.userRef.child(userId).child("Activities").childByAutoId()
        let otherdata: Dictionary<String, Any> = ["activities": otherString,
                                                  "activityId": otherUniqueStr.key,
                                                  "answerId": answerId,
                                                  "id": "",
                                                  "profilePicture": lUser.profile ,
                                                  "questionId": questionId,
                                                  "userId": accountId!,
                                                  "userName": userName!
        ]
        
        otherUniqueStr.setValue(otherdata)
        otherUniqueStr.child("date").setValue(data2)
        
    }
    
    func setOtherUserFollowingActivities(activityString: String, userId: String, accountId: String) {
        
        //let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let userName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
        let dict = UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary
        let lUser = User(userdict: dict)
        DBProvider.Instance.userRef.child(accountId).child(USER_USERFOLLOWERS_NODE).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //set followers activity
            
//            if let dict = snapshot.value as? NSDictionary {
//                print("hello")
//                var countLoop: Int = 0
//                for item in (dict.allKeys) {
//                    if item as! String == userId {
//                        continue
//                    }
//                    countLoop = countLoop+1
//                    let uniqueStr = DBProvider.Instance.userRef.child(item as! String).child("FollowActivity").childByAutoId()
//                    let data: Dictionary<String, Any> = ["activities": activityString,
//                                                         "activityId": uniqueStr.key,
//                                                         "answerId": "",
//                                                         "id": accountId!,
//                                                         "profilePicture": lUser.profile,
//                                                         "questionId": "",
//                                                         "userId": userId,
//                                                         "userName": userName!
//                    ]
//
//                    uniqueStr.setValue(data)
//
//                    let lReceiverDate = Common.getMyDate()
//                    let data2: Dictionary<String, Any> = ["date": NSNumber(value: Int(lReceiverDate.date)!),
//                                                          "day": NSNumber(value: Int(lReceiverDate.day)!),
//                                                          "hours": NSNumber(value: Int(lReceiverDate.hours)!),
//                                                          "minutes": NSNumber(value: Int(lReceiverDate.minutes)!),
//                                                          "month": NSNumber(value: Int(lReceiverDate.months)!),
//                                                          "seconds": NSNumber(value: Int(lReceiverDate.seconds)!),
//                                                          "time": NSNumber(value: Int(lReceiverDate.time)!),
//                                                          "timezoneOffset": NSNumber(value: 500),
//                                                          "year": NSNumber(value: Int(lReceiverDate.year)!)
//
//                    ]
//
//                    uniqueStr.child("date").setValue(data2)
//
//                }
//
//            }
            
            let uniqueStr = DBProvider.Instance.userRef.child(userId).child("FollowActivity").childByAutoId()
            let data: Dictionary<String, Any> = ["activities": activityString,
                                                 "activityId": uniqueStr.key,
                                                 "answerId": "",
                                                 "id": accountId,
                                                 "profilePicture": lUser.profile,
                                                 "questionId": "",
                                                 "userId": userId,
                                                 "userName": userName!
            ]
            
            uniqueStr.setValue(data)
            
            let lReceiverDate = Common.getMyDate()
            let data2: Dictionary<String, Any> = ["date": NSNumber(value: Int(lReceiverDate.date)!),
                                                  "day": NSNumber(value: Int(lReceiverDate.day)!),
                                                  "hours": NSNumber(value: Int(lReceiverDate.hours)!),
                                                  "minutes": NSNumber(value: Int(lReceiverDate.minutes)!),
                                                  "month": NSNumber(value: Int(lReceiverDate.months)!),
                                                  "seconds": NSNumber(value: Int(lReceiverDate.seconds)!),
                                                  "time": NSNumber(value: Int(lReceiverDate.time)!),
                                                  "timezoneOffset": NSNumber(value: 500),
                                                  "year": NSNumber(value: Int(lReceiverDate.year)!)
                
            ]
            
            uniqueStr.child("date").setValue(data2)
//            let dict = snapshot.value as! NSDictionary
//            for item in (dict.allKeys) {
//                let uniqueStr = DBProvider.Instance.userRef.child(item as! String).child("FollowActivity").childByAutoId()
//                let data: Dictionary<String, Any> = ["activities": activityString,
//                                                     "activityId": uniqueStr.key,
//                                                     "answerId": "",
//                                                     "id": item,
//                                                     "profilePicture": "",
//                                                     "questionId": "",
//                                                     "userId": userId,
//                                                     "userName": userName!
//                ]
//                
//                uniqueStr.setValue(data)
//                
//                let lReceiverDate = Common.getMyDate()
//                let data2: Dictionary<String, Any> = ["date": NSNumber(value: Int(lReceiverDate.date)!),
//                                                      "day": NSNumber(value: Int(lReceiverDate.day)!),
//                                                      "hours": NSNumber(value: Int(lReceiverDate.hours)!),
//                                                      "minutes": NSNumber(value: Int(lReceiverDate.minutes)!),
//                                                      "month": NSNumber(value: Int(lReceiverDate.months)!),
//                                                      "seconds": NSNumber(value: Int(lReceiverDate.seconds)!),
//                                                      "time": NSNumber(value: Int(lReceiverDate.time)!),
//                                                      "timezoneOffset": NSNumber(value: 500),
//                                                      "year": NSNumber(value: Int(lReceiverDate.year)!)
//                    
//                ]
//                
//                uniqueStr.child("date").setValue(data2)
//            }
            
        })
        
    }
    
    func setOtherUserActivities(activityString: String, userId: String) {
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let userName = UserDefaults.standard.string(forKey: USER_UNIQUE_NAME)
        let dict = UserDefaults.standard.value(forKey: USER_DICT) as! NSDictionary
        let lUser = User(userdict: dict)
        DBProvider.Instance.userRef.child(accountId!).child(USER_USERFOLLOWERS_NODE).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict = snapshot.value as? NSDictionary {
                print("hello")
                var countLoop: Int = 0
                for item in (dict.allKeys) {
                    if item as! String == userId {
                        continue
                    }
                    countLoop = countLoop+1
                    let uniqueStr = DBProvider.Instance.userRef.child(item as! String).child("Activities").childByAutoId()
                    let data: Dictionary<String, Any> = ["activities": activityString,
                                                         "activityId": uniqueStr.key,
                                                         "answerId": "",
                                                         "id": accountId!,
                                                         "profilePicture": lUser.profile,
                                                         "questionId": "",
                                                         "userId": userId,
                                                         "userName": userName!
                    ]
                    
                    uniqueStr.setValue(data)
                    
                    let lReceiverDate = Common.getMyDate()
                    let data2: Dictionary<String, Any> = ["date": NSNumber(value: Int(lReceiverDate.date)!),
                                                          "day": NSNumber(value: Int(lReceiverDate.day)!),
                                                          "hours": NSNumber(value: Int(lReceiverDate.hours)!),
                                                          "minutes": NSNumber(value: Int(lReceiverDate.minutes)!),
                                                          "month": NSNumber(value: Int(lReceiverDate.months)!),
                                                          "seconds": NSNumber(value: Int(lReceiverDate.seconds)!),
                                                          "time": NSNumber(value: Int(lReceiverDate.time)!),
                                                          "timezoneOffset": NSNumber(value: 500),
                                                          "year": NSNumber(value: Int(lReceiverDate.year)!)
                        
                    ]
                    
                    uniqueStr.child("date").setValue(data2)
                    
                }
                
            }
//            let uniqueStr = DBProvider.Instance.userRef.child(userId).child("FollowActivity").childByAutoId()
//            let data: Dictionary<String, Any> = ["activities": activityString,
//                                                 "activityId": uniqueStr.key,
//                                                 "answerId": "",
//                                                 "id": accountId,
//                                                 "profilePicture": lUser.profile,
//                                                 "questionId": "",
//                                                 "userId": userId,
//                                                 "userName": userName!
//            ]
//
//            uniqueStr.setValue(data)
//
//            let lReceiverDate = Common.getMyDate()
//            let data2: Dictionary<String, Any> = ["date": NSNumber(value: Int(lReceiverDate.date)!),
//                                                  "day": NSNumber(value: Int(lReceiverDate.day)!),
//                                                  "hours": NSNumber(value: Int(lReceiverDate.hours)!),
//                                                  "minutes": NSNumber(value: Int(lReceiverDate.minutes)!),
//                                                  "month": NSNumber(value: Int(lReceiverDate.months)!),
//                                                  "seconds": NSNumber(value: Int(lReceiverDate.seconds)!),
//                                                  "time": NSNumber(value: Int(lReceiverDate.time)!),
//                                                  "timezoneOffset": NSNumber(value: 500),
//                                                  "year": NSNumber(value: Int(lReceiverDate.year)!)
//
//            ]
//
//            uniqueStr.child("date").setValue(data2)
            
        })
        
    }
    
    func getUserActivities() {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child(USER_ACTIVITIES_NODE).queryLimited(toLast: 25) .observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getUserActivitiesDelegate?.getUserActivities(userActiviyDict: snapshot.value as! NSDictionary)
        }
        
        DBProvider.Instance.userRef.child(accountId!).child(USER_ACTIVITIES_NODE).queryLimited(toLast: 25).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            self.getUserActivitiesDelegate?.getUserActivities(userActiviyDict: snapshot.value as! NSDictionary)
        }
        
    }
    
    func getUserFollowingActivities() {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child(USER_FOLLOWACTIVITY).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getUserFollowingActivitiesDelegate?.getUserFollowingActivities(userFollowingActiviyDict: snapshot.value as! NSDictionary)
        }
        
        DBProvider.Instance.userRef.child(accountId!).child(USER_FOLLOWACTIVITY).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            self.getUserFollowingActivitiesDelegate?.getUserFollowingActivities(userFollowingActiviyDict: snapshot.value as! NSDictionary)
        }
        
    }
    
    func deleteUserActivity(activityId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child(USER_ACTIVITIES_NODE).child(activityId).removeValue()
    }
    
    func deleteUserFollowingActivity(activityId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child(USER_FOLLOWACTIVITY).child(activityId).removeValue()
    }
    
    func deleteUserNetwork(lNetworkId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.userRef.child(accountId!).child("SocialNetworks").child(lNetworkId).removeValue()
    }
    
    func updateSocialInfo(network: SocialNetworks) {
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let dbQuery = DBProvider.Instance.userRef.child(accountId!).child("SocialNetworks").child(network.networkTempData)
        
        
        let data: Dictionary<String, Any> = ["mNetwokMsg": network.networkMessage ?? "",
                                             "mNetworkPath": network.networkPath,
                                             "mNetworkProfileLink": network.networkProfileLink,
                                             "mNetworkProfileLink2": network.networkProfileLink2 ,
                                             "mNetworkProfileLink3": network.networkProfileLink3 ,
                                             "mNetworkStatus": NSNumber(value: Int(network.networkStatus)!),
                                             "mNetworkTempData": network.networkTempData,
                                             "mNetworkTitle": network.networkTitle,
                                             "mNetworkType": network.networkType,
                                             "mAdditionalInfo1": network.additionalInfo1 ?? "",
                                             "mAdditionalInfo2": network.additionalInfo2 ?? ""
                                             
        ]
        dbQuery.setValue(data)
            
    }
    
    func AddHappening(networkId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        
        let data: Dictionary<String, Any> = ["Id": networkId,
                                             "time": Date().millisecondsSince1970]
        
        DBProvider.Instance.userRef.child(accountId!).child("Happening").child(networkId).setValue(data)
        //String(Date().millisecondsSince1970)
        
//         DispatchQueue.main.asyncAfter(deadline: .now() + 20.0, execute: {
//        DBProvider.Instance.userRef.child(accountId!).child("Happening").child(networkId).removeValue()
//         })
    }

}













