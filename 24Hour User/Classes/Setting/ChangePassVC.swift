//
//  ChangePassVC.swift
//  24Hour User
//
//  Created by mac on 16/07/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ChangePassVC: UIViewController {

    @IBOutlet weak var text_confirm: UITextField!
    @IBOutlet weak var text_Old: UITextField!
    @IBOutlet weak var text_new: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        
        if let strMsg = checkValidation() {
            Http.alert12("", strMsg, view: self)
        } else {
            wsLogin()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: FUNCTIONS
    func checkValidation() -> String? {
        if text_Old.text?.count == 0 {
            return AlertMsg.oldpass
        } else if (text_new.text?.count == 0) {
            return AlertMsg.newPas
        } else if (text_confirm.text?.count == 0) {
            return AlertMsg.Confirm
        }
        else if text_confirm.text! != text_new.text!{
            return "Please enter same passsword."
        }
        return nil
    }
    //MARK: WS_LOGIN
    func wsLogin() {
        
        //http://24hdr.com/doctors/webservice/change_password?user_id=49&old_password=123456&password=12345
        let params = NSMutableDictionary()
        
        params["old_password"] = text_Old.text!
        params["user_id"] = kAppDelegate.userId
        params["password"] = text_new.text!

        Http.instance().json(change_password, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                    self.dismiss(animated: true, completion: nil)
            } else {
                Http.alert12(appName, string(responce, "result"), view: self)
            }
        }}
}
