//
//  ProfileVC.swift
//  24Hour User
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage
import DropDown
import CoreLocation


class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var btnProfile: Button!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    
    
    //MARK: VARIABLES
    var dropDown = DropDown()
    var dtPkr = UIDatePicker()
    var lat = 0.0
    var lon = 0.0
    var strIsBack:String! = ""
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(getAddress(notification:)), name: NSNotification.Name("address"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        if strIsBack == "" {
            self.sideMenuViewController.presentLeftMenuViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if let strMsg = checkValidation() {
            Http.alert("", strMsg)
        } else {
            wsUpdateProfile()
        }
    }
    
    @IBAction func imgProfile(_ sender: Any) {
        openFileAttachment()
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
    
    func setDetails() {
        lblName.text = "\(string(kAppDelegate.userInfo, "first_name")) \(string(kAppDelegate.userInfo, "last_name"))"
        btnProfile.sd_setImage(with: URL(string: string(kAppDelegate.userInfo, "image")), for: .normal, placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        lat = Double(truncating: number(kAppDelegate.userInfo, "lat"))
        lon = Double(truncating: number(kAppDelegate.userInfo, "lon"))
        tfFirstName.text = string(kAppDelegate.userInfo, "first_name")
        tfLastName.text = string(kAppDelegate.userInfo, "last_name")
//        tfGender.text = string(kAppDelegate.userInfo, "gender")
        tfDOB.text = string(kAppDelegate.userInfo, "dob")
        tfNumber.text = string(kAppDelegate.userInfo, "mobile")
        tfLocation.text = string(kAppDelegate.userInfo, "location")
        tvDescription.text = string(kAppDelegate.userInfo, "discription")
        let description = string(kAppDelegate.userInfo, "discription")
        if description == "" {
            tvDescription.text = "Description (max 250 words)"
            tvDescription.textColor = UIColor.darkGray
        } else {
            tvDescription.text = description
            tvDescription.textColor = UIColor.black
        }
        
        dropDown.dataSource = ["Male", "Female", "Other"]
        dropDown.anchorView = tfGender
        dropDown.selectionAction = {[unowned self] (index, item) in
            self.tfGender.text = item
        }
        
        dtPkr.maximumDate = Date()
        dtPkr.datePickerMode = .date
        tfDOB.inputView = dtPkr
    }
    
    func checkValidation() -> String? {
        if tfFirstName.text?.count == 0 {
            return AlertMsg.blankFirstName
        } else if tfLastName.text?.count == 0 {
            return AlertMsg.blankLastName
        } else if tvDescription.text! == "Description (max 250 words)"{
            return AlertMsg.blankDescription
        }  else if tfDOB.text?.count == 0 {
            return AlertMsg.blankDob
        } else if tfNumber.text?.count == 0 {
            return AlertMsg.blankNumber
        } else if tfNumber.text!.count < 6 {
            return AlertMsg.numberLen
        } else if tfLocation.text?.count == 0 {
            return AlertMsg.blankAddress
        }
        return nil
    }
    
    func openFileAttachment() {
        self.view.endEditing(true)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: PICKERVIEW DELEGATE
    var profileImg: UIImage? = nil
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        if selectedImage != nil {
            profileImg = selectedImage
            btnProfile.setImage(selectedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: WS_UPDATE_PROFILE
    func wsUpdateProfile() {
        self.view.endEditing(true)
        
        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId
        params["user_type"] = kAppDelegate.userType
        params["speciality"] = string(kAppDelegate.userInfo, "speciality")
        params["email"] = string(kAppDelegate.userInfo, "email")
        params["mobile"] = tfNumber.text!
        params["first_name"] = tfFirstName.text!
        params["last_name"] = tfLastName.text!
        params["location"] = tfLocation.text!
        params["lat"] = "\(lat)"
        params["lon"] = "\(lon)"
        params["dob"] = tfDOB.text!
        params["discription"] = tvDescription.text!

        let images = NSMutableArray()
        if profileImg != nil {
            let dict = NSMutableDictionary()
            dict["name"] = "image"
            dict["image"] = profileImg!
            images.add(dict)
        }
        
        Http.instance().json(api_update_profile, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSDictionary {
                    kAppDelegate.saveUser(result)
                    Http.alert(appName, AlertMsg.profileUpdate)
                    self.lblName.text = "\(string(kAppDelegate.userInfo, "first_name")) \(string(kAppDelegate.userInfo, "last_name"))"
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End

extension ProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == tvDescription {
            if tvDescription.textColor == UIColor.darkGray {
                tvDescription.textColor = UIColor.black
                tvDescription.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvDescription.text.isEmpty {
            tvDescription.text = "Description (max 250 words)"
            tvDescription.textColor = UIColor.darkGray
        }
    }
}


extension ProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfGender {
            dropDown.show()
            return false
        } else if textField == tfLocation {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickAddressVC") as! PickAddressVC
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        checkDob(tf: textField)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        checkDob(tf: textField)
        return true
    }
    
    func checkDob(tf: UITextField)  {
        if tf == tfDOB {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            tfDOB.text = formatter.string(from: dtPkr.date)
        }
    }
    
}
