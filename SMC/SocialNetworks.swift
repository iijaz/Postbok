//
//  SocialNetworks.swift
//  SMC
//
//  Created by JuicePhactree on 11/15/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import Foundation

class SocialNetworks {
    
    private var _networkMessage:String?
    private var _networkPath:String!
    private var _networkProfileLink: String!
    private var _networkProfileLink2: String?
    private var _networkProfileLink3: String?
    private var _networkStatus: String!
    private var _networkTempData: String!
    private var _networkTitle: String!
    private var _networkType: String!
    private var _additionalInfo1: String?
    private var _additionalInfo2: String?
    
    private var _isSelected: Bool!
    
    init() {
    }
    
    init(networkDict: NSDictionary) {
        _networkMessage = networkDict["mNetwokMsg"] as? String
        _networkPath = networkDict["mNetworkPath"] as! String
        _networkProfileLink = networkDict["mNetworkProfileLink"] as! String
        _networkProfileLink2 = networkDict["mNetworkProfileLink2"] as? String
        _networkProfileLink3 = networkDict["mNetworkProfileLink3"] as? String
        _networkStatus = String(describing: networkDict["mNetworkStatus"] as! NSNumber)
        _networkTempData = networkDict["mNetworkTempData"] as! String
        _networkTitle = networkDict["mNetworkTitle"] as! String
        _networkType = networkDict["mNetworkType"] as! String
        _additionalInfo1 = networkDict["mAdditionalInfo1"] as? String
        _additionalInfo2 = networkDict["mAdditionalInfo2"] as? String
        _isSelected = false
        
    }
    
    var networkMessage : String?{
        get {
            return _networkMessage
        }
        set(newValue) {
            self._networkMessage = newValue
        }
    }
    
    var networkPath : String{
        get {
            return _networkPath
        }
        set(newValue) {
            self._networkPath = newValue
        }
    }
    
    var networkProfileLink : String{
        get {
            return _networkProfileLink
        }
        set(newValue) {
            self._networkProfileLink = newValue
        }
    }
    
    var networkProfileLink2 : String{
        get {
            return _networkProfileLink2 ?? ""
        }
        set(newValue) {
            self._networkProfileLink2 = newValue
        }
    }
    
    var networkProfileLink3 : String{
        get {
            return _networkProfileLink3 ?? ""
        }
        set(newValue) {
            self._networkProfileLink3 = newValue
        }
    }
    
    var networkStatus : String{
        get {
            return _networkStatus
        }
        set(newValue) {
            self._networkStatus = newValue
        }
    }
    var networkTempData : String{
        get {
            return _networkTempData
        }
        set(newValue) {
            self._networkTempData = newValue
        }
    }
    
    var networkTitle : String{
        get {
            return _networkTitle
        }
        set(newValue) {
            self._networkTitle = newValue
        }
    }
    var networkType : String{
        get {
            return _networkType
        }
        set(newValue) {
            self._networkType = newValue
        }
    }
    
    var isSelected : Bool{
        get {
            return _isSelected
        }
        set(newValue) {
            self._isSelected = newValue
        }
    }
    
    var additionalInfo1 : String? {
        get {
            return _additionalInfo1
        }
        set(newValue) {
            self._additionalInfo1 = newValue
        }
    }
    
    var additionalInfo2 : String? {
        get {
            return _additionalInfo2
        }
        set(newValue) {
            self._additionalInfo2 = newValue
        }
    }

}
