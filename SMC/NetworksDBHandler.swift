//
//  NetworksDBHandler.swift
//  SMC
//
//  Created by JuicePhactree on 11/16/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import Foundation
import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol GetAllSocialNetworksDelegate:class {
    func getAllNetworks(networkDic:NSDictionary)
}

class NetworksDBHandler {
    private static let _instance = NetworksDBHandler()
    private init() {}
    
    weak var getAllSocialNetworksDelegate: GetAllSocialNetworksDelegate?
    
    static var Instance: NetworksDBHandler {
        return _instance;
    }
    
    func getSocialNetworks() {
//        DBProvider.Instance.networksRef.queryOrdered(byChild: "mNetworkTempData").observeSingleEvent(of: .value, with: { (snapshot) in
//            self.getAllSocialNetworksDelegate?.getAllNetworks(networkDic: snapshot.value as! NSDictionary)
//        })
        
        DBProvider.Instance.networksRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            self.getAllSocialNetworksDelegate?.getAllNetworks(networkDic: snapshot.value as! NSDictionary)
        }
        
        
    }
    
    
}
