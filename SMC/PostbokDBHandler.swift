//
//  PostbokDBHandler.swift
//  SMC
//
//  Created by JuicePhactree on 8/17/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import Foundation
import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol GetAllPostMediaDelegate:class {
    func getAllMedia(mediaDict:NSDictionary)
}

class PostbokDBhandler {
    private static let _instance = PostbokDBhandler()
    private init() {}
    
    weak var getAllPostbokMediaDelegate: GetAllPostMediaDelegate?
    
    static var Instance: PostbokDBhandler {
        return _instance;
    }
    
    func getUserPostbokMedia(userId: String) {
        
        DBProvider.Instance.postbokRef.child(userId).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getAllPostbokMediaDelegate?.getAllMedia(mediaDict: snapshot.value as! NSDictionary)
        }
        
        DBProvider.Instance.postbokRef.child(userId).observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            self.getAllPostbokMediaDelegate?.getAllMedia(mediaDict: snapshot.value as! NSDictionary)
        }
    }
    
    func adPostbokMedia(postbokDict: Postbok) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        let data: Dictionary<String, Any> = [POSTBOK_MEDIAPATH: postbokDict.mediaPath,
                                             POSTBOK_MEDIATYPE: postbokDict.mediaType,
                                             POSTBOK_POSTID: postbokDict.postId,
                                             POSTBOK_POSTTEXT: postbokDict.postText,
                                             POSTBOK_THUMBIMAGE: postbokDict.thumbImage
        ]
        
        DBProvider.Instance.postbokRef.child(accountId!).child(postbokDict.postId).setValue(data)

    }
    
    
    func deleteSelectedPostedMedia(postedId: String) {
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)
        DBProvider.Instance.postbokRef.child(accountId!).child(postedId).removeValue()
        
        
    }
    
    func uploadPostbokImage(dataToUpload: Data, uniqueId: String, postbokId: String) {
        let newChild = uniqueId+".jpg"
        let newRef = DBProvider.Instance.postbokImageref.child(newChild)
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)!
        
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            DispatchQueue.main.async {
            DBProvider.Instance.postbokRef.child(accountId).child(postbokId).updateChildValues([POSTBOK_MEDIAPATH : (metadata.downloadURL()?.absoluteString)!])
            }
            
        }
    }
    
    func uploadPostbokVideo(dataToUpload: Data, uniqueId: String, postbokId: String, thumbData: Data) {
        
        let accountId = UserDefaults.standard.string(forKey: USER_ACCOUNT_ID)!
        let newChild = uniqueId+".mp4"
        let thumbChild = uniqueId+".jpg"
        let newRef = DBProvider.Instance.postbokVideoref.child(newChild)
        let thumbRef = DBProvider.Instance.postbokThumbref.child(thumbChild)
        
        thumbRef.putData(thumbData, metadata: nil) { (metadata, error) in
            guard let metadata1 = metadata else {
                print("network error no upload")
                return
            }
        
        newRef.putData(dataToUpload, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("network error no upload")
                return
            }
            
            DispatchQueue.main.async {
                DBProvider.Instance.postbokRef.child(accountId).child(postbokId).updateChildValues([POSTBOK_MEDIAPATH : (metadata.downloadURL()?.absoluteString)!])
                DBProvider.Instance.postbokRef.child(accountId).child(postbokId).updateChildValues([POSTBOK_THUMBIMAGE : (metadata1.downloadURL()?.absoluteString)!])
                
                }
            }
        }
    }
    
}
