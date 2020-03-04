//
//  SettingVC.swift
//  24Hour User
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: VARIABLES
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    @IBAction func profilr(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.strIsBack = "Back"
        self.present(vc, animated: true, completion: nil)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//        vc.strIsBack = "Back"
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func Address(_ sender: Any) {
    }
    @IBAction func cahngepass(_ sender: Any) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassVC") as! ChangePassVC
        sideMenuViewController.present(vc, animated: true, completion: nil)
    }
    @IBAction func privacy(_ sender: Any) {
    }
    @IBAction func about24hr(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutAndPrivacyVC") as! AboutAndPrivacyVC
        sideMenuViewController.present(vc, animated: true, completion: nil)
    }
    
    //MARK: FUNCTIONS
    
}//Class End
