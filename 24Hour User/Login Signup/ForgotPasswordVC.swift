//
//  ForgotPasswordVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tfEmail: UITextField!
    
    //MARK: VARIABLES
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        if let strMsg = checkValidation() {
            Http.alert("", strMsg)
        } else {
            wsForgotPassword()
        }
    }
    
    //MARK: FUNCTIONS
    func checkValidation() -> String? {
        if tfEmail.text?.count == 0 {
            return AlertMsg.blankEmail
        } else if !(tfEmail.text!.isEmail) {
            return AlertMsg.invalidEmail
        }
        return nil
    }
    
    
    //MARK: WS_FORGOT_PASSWORD
    func wsForgotPassword() {
        
        let params = NSMutableDictionary()
        params["email"] = tfEmail.text!
        
        Http.instance().json(api_forgot_password, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                Http.alert(appName, AlertMsg.forgotMsg, [self, "Ok"])
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    override func alertZero() {
        _=self.navigationController?.popViewController(animated: true)
    }
    
}//Class End
