//
//  LoginVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    var isBack:String! = ""
    
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
        if isBack == "back" {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.sideMenuViewController.presentLeftMenuViewController()
        }
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        if let strMsg = checkValidation() {
            Http.alert("", strMsg)
        } else {
            wsLogin()
        }
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionGoogle(_ sender: Any) {
        googleLogin()
    }
    
    @IBAction func actionFb(_ sender: Any) {
        
//        fbLogin()
        
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.isBack = isBack
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: FUNCTIONS
    func checkValidation() -> String? {
        if tfEmail.text?.count == 0 {
            return AlertMsg.blankEmail
        } else if !(tfEmail.text!.isEmail) {
            return AlertMsg.invalidEmail
        } else if tfPassword.text?.count == 0 {
            return AlertMsg.blankPass
        }
        return nil
    }
    
    //MARK: WS_LOGIN
    func wsLogin() {
        
        let params = NSMutableDictionary()
        //TabBarVC
        params["email"] = tfEmail.text!
        params["password"] = tfPassword.text!
        params["type"] = kAppDelegate.userType
        params["ios_register_id"] = kAppDelegate.token
        params["register_id"] = ""

        Http.instance().json(api_login, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSDictionary {
                    kAppDelegate.saveUser(result)
                    if self.isBack == "back" {
                        self.navigationController?.popViewController(animated: true)
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
    
    
    /***************************** Facebook  ******************************/
    
    func fbLogin () {
      
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil) {
                if ((FBSDKAccessToken.current()) != nil) {
                    self.view.showHUD("Loading...")
                    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                        if (error == nil) {
                            if let dt = result as? NSDictionary {
                                
                                let md = NSMutableDictionary()
                                
                                md["first_name"] = dt["first_name"]
                                md["last_name"] = dt["last_name"]
                                md["email"] = dt["email"]
                                md["social_id"] = dt["id"]
                                md["ios_register_id"] = kAppDelegate.token
                                md["register_id"] = ""
                                
                                //                                md["lat"] = "\(kAppDelegate.currentLocation.latitude)"
                                //                                md["lon"] = "\(kAppDelegate.currentLocation.longitude)"
                                
                                var url:String? = nil
                                
                                if let picture = dt["picture"] as? NSDictionary {
                                    if let data = picture["data"] as? NSDictionary {
                                        if let uurl = data["url"] as? String {
                                            url = uurl
                                        }
                                    }
                                }
                                
                                if url == nil {
                                    self.socialLogin(md)
                                } else {
                                    //md["social_dp"] = url!
                                    self.socialLogin(md)
                                }
                                print(md)//Print FB User Details
                            } else {
                                self.stopActivityI()
                            }
                        } else {
                            self.stopActivityI()
                        }
                    })
                } else {
                    self.stopActivityI()
                }
            }
        }
    }
    
    //MARK: WS_LOGIN
    func socialLogin (_ md:NSMutableDictionary) {
        
        self.view.hideHUD()
        
        
//        if self.isBack == "back" {
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootView") as! RootView
//            kAppDelegate.window?.rootViewController = vc
//        }
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootView") as! RootView
        //        kAppDelegate.window?.rootViewController = vc
        
        /* Http.instance().json(api_social_login, md, true, nil, self.view) { (responce) in
         if number(responce, "status").boolValue {
         if let result = responce.object(forKey: "result") as? NSDictionary {
         let encodeData = NSKeyedArchiver.archivedData(withRootObject: result)
         UserDefaults.standard.set(encodeData, forKey: keyUserInfo)
         kAppDelegate.userInfo = result.mutableCopy() as! NSMutableDictionary
         kAppDelegate.userId = string(result, "id")
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootView") as! RootView
         self.navigationController?.pushViewController(vc, animated: true)
         }
         } else {
         Http.alert(appName, string(responce, "result"))
         }
         }*/
        
    }
    
    func googleLogin () {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            self.view.showHUD("Loading...")
            
            let userId = user.userID
            //let idToken = user.authentication.idToken
            //let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            let md = NSMutableDictionary()
            md["first_name"] = givenName!
            md["last_name"] = familyName!
            md["email"] = email
            md["social_id"] = userId
            md["ios_register_id"] = kAppDelegate.token
            md["register_id"] = ""
            
            var url:String? = nil
            
            if user.profile.hasImage {
                let uurl = user.profile.imageURL(withDimension: 120)
                url = uurl?.absoluteString
            }
            
            if url == nil {
                self.socialLogin(md)
            } else {
                //md["social_dp"] = url!
                self.socialLogin(md)
            }
            print(md)//Print Google User Detail from Google Api
        } else {
            print("1 sign error-\(error.localizedDescription)")
            stopActivityI()
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if error != nil {
            self.view.hideHUD()
        }
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        self.view.hideHUD()
    }
    
    func stopActivityI () {
        self.view.hideHUD()
    }
    
}//Class End
