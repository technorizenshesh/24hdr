//
//  ChatVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: VARIABLES
    var arrList = NSArray()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wsGetConversation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionMenu(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    //MARK: FUNCTIONS
    
    //MARK: UITABLEVIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        
        cell.imgView.sd_setImage(with: URL(string: string(dict, "image")), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        cell.lblName.text = "\(string(dict, "first_name")) \(string(dict, "last_name"))"
        cell.lblLastSeen.text = string(dict, "time_ago")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        //otherUserId
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConversationsVC") as! ConversationsVC
        vc.otherUserId = string(dict, "id")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: WS_GET_CONVERSATION
    func wsGetConversation() {
        
        let params = NSMutableDictionary()
        params["sender_id"] = kAppDelegate.userId

        Http.instance().json(api_get_conversation, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrList = result
                    self.tblView.reloadData()
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End
