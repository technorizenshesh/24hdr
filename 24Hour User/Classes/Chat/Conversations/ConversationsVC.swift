//
//  ConversationsVC.swift
//  Batto
//
//  Created by mac on 27/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

class ConversationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tfMsg: UITextField!

    //MARK: VARIABLES
    var dictDetail = NSDictionary()
    var arrList = NSMutableArray()
    var otherUserId = ""
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        wsGetOthersProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wsGetConversation()
        //kAppDelegate.obConversation = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //kAppDelegate.obConversation = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSend(_ sender: Any) {
        if tfMsg.text?.count == 0 {
            Http.alert(appName, AlertMsg.blankMsg)
        } else {
            wsInsertChat()
        }
    }
    
    //MARK: FUNCTIONS
    
    
    //MARK: TABLEVIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arrList.object(at: (arrList.count - 1 - indexPath.row)) as! NSDictionary
        let dictSenderUser = dict.object(forKey: "sender_detail") as! NSDictionary

        if string(dict, "sender_id") == kAppDelegate.userId {
            
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellRight1", for: indexPath) as! ConversationsCell
                cell.lblMsg.text = string(dict, "chat_message")
                cell.lblTime.text = string(dict, "date")
                cell.imgUser.sd_setImage(with: URL(string: string(dictSenderUser, "sender_image")), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
                //cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
                return cell
            
        } else {
            
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellLeft1", for: indexPath) as! ConversationsCell
                cell.lblMsg.text = string(dict, "chat_message")
                cell.lblTime.text = string(dict, "date")
                cell.imgUser.sd_setImage(with: URL(string: string(dictSenderUser, "sender_image")), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
                //cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
                return cell
                
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    //MARK: WS_GET_OTHER_USER_PROFILE
    func wsGetOthersProfile() {
        
        let params = NSMutableDictionary()
        params["user_id"] = otherUserId
        
        Http.instance().json(api_get_profiles, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSDictionary {
                    self.dictDetail = result
                    self.lblTitle.text = "\(string(result, "first_name")) \(string(result, "last_name"))"
                }
            }
        }
    }
    
    
    //MARK: WS_GET_CONVERSATION
    func wsGetConversation() {
        
        let params = NSMutableDictionary()
        params["sender_id"] = otherUserId
        params["receiver_id"] = kAppDelegate.userId

        Http.instance().json(api_get_chat, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrList = result.mutableCopy() as! NSMutableArray
                    self.tblView.reloadData()
                    self.tblView.scrollToBottom(animated: true)
                }
            } else {
                self.arrList.removeAllObjects()
                self.tblView.reloadData()
                //Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    //MARK: WS_REFRESH_CONVERSATION
    func wsRefreshConversation() {
        
        let params = NSMutableDictionary()
        params["sender_id"] = otherUserId
        params["receiver_id"] = kAppDelegate.userId
        
        Http.instance().json(api_get_chat, params, false, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrList = result.mutableCopy() as! NSMutableArray
                    self.tblView.reloadData()
                }
            } else {
                self.arrList.removeAllObjects()
                self.tblView.reloadData()
                //Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    
    //MARK: WS_INSERT_CHAT
    func wsInsertChat() {
        
        let params = NSMutableDictionary()
        params["sender_id"] = kAppDelegate.userId
        params["receiver_id"] = otherUserId
        params["chat_message"] = tfMsg.text!
        
        
        Http.instance().json(api_insert_chat, params, true, nil, self.view) { (responce) in
            
            if string(responce, "result") == "successful" {
                self.tfMsg.text = ""
                self.wsGetConversation()
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    
    
}//Class End
