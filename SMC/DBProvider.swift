//
//  DBProvider.swift
//  Page
//
//  Created by JuicePhactree on 7/21/17.
//  Copyright © 2017 JuicePhactree. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import Firebase

class DBProvider {
    
    private static let _instance = DBProvider()
    
    private init() {
    }
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var userRef: DatabaseReference {
        let ref = dbRef.child(USERS)
        ref.keepSynced(true)
        return ref
    }
    var answersRef: DatabaseReference {
        let ref = dbRef.child(ANSWERS)
        ref.keepSynced(true)
        return ref
    }
    var categoriesRef: DatabaseReference {
        
        let ref = dbRef.child(CATEGORIES)
        ref.keepSynced(true)
        return ref
    }
    var keyRef: DatabaseReference {
        let ref = dbRef.child(KEY)
        ref.keepSynced(true)
        return ref
    }
    var questionsRef: DatabaseReference {
        let ref = dbRef.child(QUESTIONS)
        ref.keepSynced(true)
        return ref
    }
    var codeviseChattingRef: DatabaseReference {
        let ref = dbRef.child(CODEVISECHATTING)
        ref.keepSynced(true)
        return ref
    }
    
    var networksRef: DatabaseReference {
        let ref = dbRef.child(NETWORKS)
       // ref.keepSynced(true)
        return ref
    }
    
    var postbokRef: DatabaseReference {
        let ref = dbRef.child(POSTBOKS)
         ref.keepSynced(true)
        return ref
    }
    
    var publishPostRef: DatabaseReference {
        let ref = dbRef.child(PUBLISHPOSTS)
        ref.keepSynced(true)
        return ref
    }
    
    
    
    //this is storage reference gs://page-6f37b.appspot.com
 
  
    
    var storageRef: StorageReference {
        //return Storage.storage().reference(forURL: "gs://social-media-card-5c396.appspot.com")
        return Storage.storage().reference(forURL: "gs://social-media-card.appspot.com")
        
    }
    
    var profileImageRef:StorageReference {
        return storageRef.child(PROFILE_STORAGE)
    }
    var questionThumbRef:StorageReference {
        return storageRef.child(QUESTION_THUMBNAIL_STORAGE)
    }
    var questionImageRef:StorageReference {
        return storageRef.child(QUESTION_IMAGE_STORAGE)
    }
    var answerThumbRef:StorageReference {
        return storageRef.child(ANSWER_THUMBNAIL_STORAGE)
    }
    
    var questionVideoRef:StorageReference {
        return storageRef.child(QUESTION_VIDEO)
    }
    
    var answerVideoRef:StorageReference {
        return storageRef.child(ANSWER_VIDEO)
    }
    
    var postbokVideoref:StorageReference {
        return storageRef.child(POSTBOK_VIDEO_STORAGE)
    }
    
    var postbokImageref:StorageReference {
        return storageRef.child(POSTBOK_IMAGE_STORAGE)
    }
    var postbokThumbref:StorageReference {
        return storageRef.child(POSTBOK_THUMBNAIL_STORAGE)
    }
    var publishImageref:StorageReference {
        return storageRef.child(PUBLISH_IMAGE_STORAGE)
    }
    var publishThumbref:StorageReference {
        return storageRef.child(PUBLISH_THUMBNAIL_STORAGE)
    }
    
}
