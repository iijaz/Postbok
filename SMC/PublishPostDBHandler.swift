//
//  PublishPostDBHandler.swift
//  SMC
//
//  Created by JuicePhactree on 8/30/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//
import Foundation
import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol GetAllPublishPostMediaDelegate:class {
    func getAllPublishMedia(mediaDict:NSDictionary)
}

class PublishPostDBHandler {
    private static let _instance = PublishPostDBHandler()
    private init() {}
    
    weak var getAllPublishMediaDelegate: GetAllPublishPostMediaDelegate?
    
    static var Instance: PublishPostDBHandler {
        return _instance;
    }
    
    func getUserPublishedMedia(userId: String) {
        
        DBProvider.Instance.publishPostRef.child(userId).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getAllPublishMediaDelegate?.getAllPublishMedia(mediaDict: snapshot.value as! NSDictionary)
        }
        
        DBProvider.Instance.publishPostRef.child(userId).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            self.getAllPublishMediaDelegate?.getAllPublishMedia(mediaDict: snapshot.value as! NSDictionary)
        }

    }
    
    func deleteSelectedPublishedMedia(publishId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        //DBProvider.Instance.questionsRef.child(videoId).removeValue()
        DBProvider.Instance.publishPostRef.child(accountId!).child(publishId).removeValue()
        
        
    }
    
    func adPublishedMedia(publishDict: PublishPost) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let data: Dictionary<String, Any> = [PUBLISH_MEDIAPATH: publishDict.mediaPath,
                                             PUBLISH_POSTEDON: publishDict.postedOn,
                                             PUBLISH_POST_KEY: publishDict.postId,
                                             PUBLISH_POSTTEXT: publishDict.postText,
                                             PUBLISH_SCHEDULING: publishDict.scheduledOn,
                                             PUBLISH_TWITTER: publishDict.twitter,
                                             PUBLISH_PINTEREST: publishDict.pinterest,
                                             PUBLISH_INSTAGRAM: publishDict.instagram,
                                             PUBLISH_LINKEDIN: publishDict.linkedin,
                                             PUBLISH_MEDIATYPE: publishDict.mediaType,
                                             PUBLISH_TIMESTAMP: NSNumber(value: Int(publishDict.timeStamp)!)
        ]
        DBProvider.Instance.publishPostRef.child(accountId!).child(publishDict.postId).setValue(data)
    }
    
    func uploadPublishImage(dataToUpload: Data, uniqueId: String, publishId: String) {
        let newChild = uniqueId+".jpg"
        let newRef = DBProvider.Instance.publishImageref.child(newChild)
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)!
        
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            DispatchQueue.main.async {
                DBProvider.Instance.publishPostRef.child(accountId).child(publishId).updateChildValues([PUBLISH_MEDIAPATH : (metadata.downloadURL()?.absoluteString)!])
            }
            
        }
    }
    
    func uploadPublishThumb(uniqueId: String, publishId: String, thumbData: Data) {
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)!
        let thumbChild = uniqueId+".jpg"
        let thumbRef = DBProvider.Instance.publishThumbref.child(thumbChild)
        
        thumbRef.putData(thumbData, metadata: nil) { (metadata, error) in
            guard let metadata1 = metadata else {
                print("network error no upload")
                return
            }

                
            DispatchQueue.main.async {
                DBProvider.Instance.publishPostRef.child(accountId).child(publishId).updateChildValues([PUBLISH_MEDIAPATH : (metadata1.downloadURL()?.absoluteString)!])
                
            }
        }
    }
}

