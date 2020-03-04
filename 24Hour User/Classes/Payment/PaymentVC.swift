//
//  PaymentVC.swift
//  24Hour User
//
//  Created by mac on 21/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfCardNumber: UITextField!
    @IBOutlet weak var tfExpiry: UITextField!
    @IBOutlet weak var tfCvc: UITextField!
    @IBOutlet weak var btnPay: UIButton!
    
    //MARK: VARIABLES
    var isImmediate = false
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getPrevClassValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPay(_ sender: Any) {
        if let strMsg = checkValidation() {
            Http.alert(appName, strMsg)
        } else {
            wsSendRequest()
        }
    }
    
    
    //MARK: FUNCTIONS
    func checkValidation() -> String? {
        if tfEmail.text?.count == 0 {
            return AlertMsg.blankEmail
        } else if !(tfEmail.text!.isEmail) {
            return AlertMsg.invalidEmail
        } else if tfCardNumber.text?.count == 0 {
            return AlertMsg.blankCardNumber
        } else if tfExpiry.text?.count == 0 {
            return AlertMsg.blankExpiry
        } else if tfCvc.text?.count == 0 {
            return AlertMsg.blankCvv
        }
        return nil
    }
    
    //MARK: WS_SEND_REQUEST
    func wsSendRequest() {

        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId
        params["doctor_id"] = string(dictDoctor, "id")
        params["date"] = strDate
        params["time"] = strTime
        params["immediate"] = immediate

        let images = NSMutableArray()

        for i in 0..<arrImages.count {
            if let img = arrImages.object(at: i) as? UIImage {
                let dict = NSMutableDictionary()
                dict["name"] = "img"
                dict["image"] = img
                images.add(dict)
            }
        }
        
        Http.instance().json(api_seduling, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                Http.alert("", AlertMsg.bookedAppoimt, [self, "Ok"])
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    override func alertZero() {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    
    var arrImages = NSMutableArray()
    var dictDoctor = NSDictionary()
    var immediate = ""
    var strDate = ""
    var strTime = ""
    
    func getPrevClassValue() {
        
        let arr = self.navigationController?.viewControllers
        
        if arr != nil {
            for vc in arr! {
                if isImmediate {
                    if vc is DoctorDetails {
                        let vcc = vc as! DoctorDetails
                        dictDoctor = vcc.dictDetails
                        immediate = "yes"
                    }
                } else {
                    if vc is AppointmentVC {
                        let vcc = vc as! AppointmentVC
                        dictDoctor = vcc.dictDoctor
                        strDate = vcc.tfDate.text!
                        strTime = vcc.tfTime.text!
                        arrImages = vcc.arrList
                        immediate = "no"
                    }
                }
            }
        }
    }
    
    
}//Class End
