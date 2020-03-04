//
//  LandingVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {
    
    //MARK: OUTLETS
    
    //MARK: VARIABLES
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionEnglish(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootView") as! RootView
        kAppDelegate.window?.rootViewController = vc
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionArabic(_ sender: Any) {
    }
    //MARK: FUNCTIONS
    
}//Class End
