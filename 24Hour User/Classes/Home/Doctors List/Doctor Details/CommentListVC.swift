//
//  CommentListVC.swift
//  24Hour User
//
//  Created by mac on 12/07/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class CommentListVC: UIViewController {
    var arr_Comment:NSArray! = []
    var strDocId:String! = ""
    
    @IBOutlet weak var text_Comment: UITextField!
    
    @IBOutlet weak var tableComment: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        wsGetDoctors()
        tableComment.estimatedRowHeight = 109
        tableComment.rowHeight = UITableView.automaticDimension
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func comment(_ sender: Any) {
        if text_Comment.text?.count != 0 {
            wsAddComment()
        } else {
            Http.alert(appName, "Please enter comment")
        }
    }
    
    //MARK: WS_GET_DOCTORS
    func wsGetDoctors() {
        //http://24hdr.com/doctors/webservice/get_comment?doctor_id=31
        let params = NSMutableDictionary()
        params["doctor_id"] = strDocId
        Http.instance().json(get_comment, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arr_Comment = result
                    self.tableComment.reloadData()
                    self.tableComment.scrollToBottom(animated: true)
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    func wsAddComment() {
        //http://24hdr.com/doctors/webservice/add_comment?user_id=56&doctor_id=31&comment=nice
        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId
        params["doctor_id"] = strDocId
        params["comment"] = text_Comment.text!
        
        Http.instance().json(add_comment, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                    self.text_Comment.text = ""
                    self.wsGetDoctors()
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
}
extension CommentListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Comment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell
       
        let dict = arr_Comment.object(at: indexPath.row) as! NSDictionary
        cell.img_Commentuser.sd_setImage(with: URL(string: "\(image_url)\(string(dict, "image"))"), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)

        let userDic = dict["user_details"] as! NSDictionary
        cell.lbl_username.text = "\(string(userDic, "first_name")) \(string(dict, "last_name"))"
        cell.lbl_Description.text = string(dict, "comment")
        cell.lbl_daysAgo.text = string(dict, "time_ago")

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
