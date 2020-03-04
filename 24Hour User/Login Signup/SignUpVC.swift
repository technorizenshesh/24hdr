//
//  SignUpVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation

class SignUpVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var tfQuestion: UITextField!
    @IBOutlet weak var tfAnswer: UITextField!
    
    //MARK: VARIABLES
    var arrQuestions = ["What was your childhood nickname?", "What was your favorite sport?", "What is your pet's name?", "What is your favorite color?"]
    var dropDown = DropDown()
    var lat = 0.0
    var lon = 0.0
    var isBack:String! = ""

    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tfQuestion.delegate = self
        dropDown.dataSource = arrQuestions
        dropDown.anchorView = tfQuestion
        dropDown.selectionAction = {[unowned self] (index, item) in
            self.tfQuestion.text = item
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getAddress(notification:)), name: NSNotification.Name("address"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        if let strMsg = checkValidation() {
            Http.alert("", strMsg)
        } else {
            wsSignUp()
        }
    }
    
    @IBAction func tfLogin(_ sender: Any) {
    }
    
    //MARK: FUNCTIONS
    @objc func getAddress(notification: NSNotification) {
        if let dict = notification.object as? NSDictionary {
            tfLocation.text = string(dict, "address")
            if let coords = dict.object(forKey: "coordinate") as? CLLocation {
                lat = coords.coordinate.latitude
                lon = coords.coordinate.longitude
            }
        }
    }
    
    func checkValidation() -> String? {
        if tfEmail.text?.count == 0 {
            return AlertMsg.blankEmail
        } else if !(tfEmail.text!.isEmail) {
            return AlertMsg.invalidEmail
        } else if tfNumber.text?.count == 0 {
            return AlertMsg.blankNumber
        } else if tfNumber.text!.count < 6 {
            return AlertMsg.numberLen
        } else if tfPassword.text?.count == 0 {
            return AlertMsg.blankPass
        } else if tfPassword.text!.count < 6 {
            return AlertMsg.numberLen
        }  else if tfConfirmPassword.text?.count == 0 {
            return AlertMsg.blankConfPass
        }  else if tfPassword.text! != tfConfirmPassword.text! {
            return AlertMsg.passMissMatch
        } else if tfFirstName.text?.count == 0 {
            return AlertMsg.blankFirstName
        } else if tfLastName.text?.count == 0 {
            return AlertMsg.blankLastName
        } else if tfLocation.text?.count == 0 {
            return AlertMsg.blankAddress
        } else if tfQuestion.text?.count == 0 {
            return AlertMsg.blankQuestion
        } else if tfAnswer.text?.count == 0 {
            return AlertMsg.blankAnswer
        }
        return nil
    }
    
    //MARK: WS_SIGNUP
    func wsSignUp() {
        
        let params = NSMutableDictionary()
        params["user_type"] = kAppDelegate.userType
        //params["speciality"] = ""
        params["email"] = tfEmail.text!
        params["password"] = tfPassword.text!
        params["mobile"] = tfNumber.text!
        params["first_name"] = tfFirstName.text!
        params["last_name"] = tfLastName.text!
        params["location"] = tfLocation.text!
        params["security_que"] = tfQuestion.text!
        params["security_ans"] = tfAnswer.text!
        params["lat"] = "\(lat)"
        params["lon"] = "\(lon)"
        params["ios_register_id"] = kAppDelegate.token
        params["register_id"] = ""
        

        Http.instance().json(api_signup, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSDictionary {
                    kAppDelegate.saveUser(result)
                    if self.isBack == "back" {
                        self.navigationController?.popViewControllers(viewsToPop: 2)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootView") as! RootView
                        kAppDelegate.window?.rootViewController = vc
                    }
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    
}//Class End

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == tfLocation {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickAddressVC") as! PickAddressVC
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        } else if textField == tfQuestion {
            dropDown.show()
            return false
        }
        return true
    }
}
extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
}
