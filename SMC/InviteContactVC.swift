//
//  InviteContactVC.swift
//  SMC
//
//  Created by JuicePhactree on 9/23/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit
import ContactsUI
import PhoneNumberKit
import MessageUI

class InviteContactVC: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sendText: UIButton!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var tableViewTopSpacing: NSLayoutConstraint!
    
    var fetchedContacts = [NSDictionary]()
     var selectedContacts = [NSDictionary]()
    let phoneNumberKit = PhoneNumberKit()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestToAccessContacts()

        // Do any additional setup after loading the view.
    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestToAccessContacts () {
        
        DispatchQueue.global().async {
            
            let contactStore = CNContactStore()
            var results: [CNContact] = []
            do {
                try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor])) {
                    (contactCursor, cursor) -> Void in
                    results.append(contactCursor)
                    for ContctNumVar: CNLabeledValue in contactCursor.phoneNumbers {
                        let fullPhoneNumberValue  = ContctNumVar.value
                        let mobileNumber = fullPhoneNumberValue.value(forKey: "digits") as! String
                        do {
                            let phoneNumber = try self.phoneNumberKit.parse("\(mobileNumber)")
                            if String(contactCursor.givenName) != nil {
//                                pageContact.name = contactCursor.givenName
//                                pageContact.number = String(phoneNumber.nationalNumber)
                                let pNumber = String(phoneNumber.nationalNumber)
                                let pName = contactCursor.givenName
                                let dictt = ["phone":pNumber,"name":pName] as NSDictionary
                                self.fetchedContacts.append(dictt)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                        }catch {
                            print("Arslan: READINGCONTACTS 66: Generic parser error")
                        }
                    }
                    print("ji")
                    
                }
            }
            catch{
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
       // resultSearchControlller.isActive = false
        if (MFMessageComposeViewController.canSendText())
        {
            var userPhoneNumbers = [String]()
            
            var invitedUsers =  UserDefaults.standard.integer(forKey: NUMBER_OF_INVITED_USERS)
            invitedUsers = invitedUsers + selectedContacts.count
            UserDefaults.standard.set(invitedUsers, forKey:NUMBER_OF_INVITED_USERS )
            if invitedUsers > 10 {
                UserDefaults.standard.setValue(PRO_ACCOUNT, forKey: POSTBOK_ACCOUNT_TYPE)
            }
            for tempContact in selectedContacts {
                userPhoneNumbers.append(tempContact["phone"] as! String)
            }
            let controller = MFMessageComposeViewController()
            controller.body = "Testing!"
            //let phoneNumberString = "123456789,987654321,2233445566"
            let recipientsArray = userPhoneNumbers
            controller.recipients = recipientsArray
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else
        {
            
            goBtn.isHidden = false
            bottomView.isHidden = true
            print("Error")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult)
    {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        bottomView.isHidden = true;
        goBtn.isHidden = false;
        controller.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func GoBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func inviteContacts(_ sender: UIButton) {
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


extension InviteContactVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if resultSearchControlller.searchBar.text != "" {
//            return filteredContacts.count
//        }
        return fetchedContacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")!
        
        
//        var lContact = Contact()
//        if resultSearchControlller.searchBar.text != "" {
//            lContact = filteredContacts[indexPath.row]
//        }
//        else {
//            lContact = contactsdb[indexPath.row]
//        }
        
        var lContact = fetchedContacts[indexPath.row]
        
        
  //      if contactsdb[indexPath.row].name != "" || contactsdb[indexPath.row].number == ""{
            
        let contactName = lContact["name"] as! String
        //Get the label for the cell
        let nameLabel = cell.viewWithTag(2) as! UILabel
        let phoneNumber = cell.viewWithTag(3) as! UILabel
        let nameCircule = cell.viewWithTag(1) as! UILabel
        
        //nameCircule.layer.backgroundColor  = UIColor.red.cgColor
        nameCircule.layer.cornerRadius = 25.0
        nameCircule.layer.borderWidth = 1.0
        nameCircule.layer.borderColor = UIColor.lightGray.cgColor
        
        nameLabel.text = contactName
        phoneNumber.text = lContact["phone"] as? String
        if contactName == "" {
            nameCircule.text = "?"
        }
        else {
            let index = contactName.index(contactName.startIndex, offsetBy: 1)
            nameCircule.text  = contactName.substring(to: index)
        }
        
            
       // }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempContact = fetchedContacts[indexPath.row]
        
//        if resultSearchControlller.searchBar.text != "" {
//            tempContact = filteredContacts[indexPath.row]
//        }
//        else {
//            tempContact = contactsdb[indexPath.row]
//        }
        
        selectedContacts.append(tempContact)
        if(selectedContacts.count > 0) {
            bottomView.isHidden = false
        }
        else {
            bottomView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        var lContact = fetchedContacts[indexPath.row]
        
//        if resultSearchControlller.searchBar.text != "" {
//            lContact = filteredContacts[indexPath.row]
//        }
//        else {
//            lContact = contactsdb[indexPath.row]
//        }
        
        for (index, tempContact) in selectedContacts.enumerated() {
            let phone1 = tempContact["phone"] as! String
            let phone2 = lContact["phone"] as! String
            if(phone1 == phone2){
                selectedContacts.remove(at: index)
            }
        }
        if(selectedContacts.count > 0) {
            bottomView.isHidden = false
        }
        else {
            bottomView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
