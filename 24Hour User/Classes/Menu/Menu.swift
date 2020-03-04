
//  Menu.swift
//  BigPaya
//  Created by mac on 02/05/18.
//  Copyright © 2018 mac. All rights reserved.

import UIKit
import SDWebImage

class Menu: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var btn_Login: UIButton!
    
    //MARK: VARIABLES
    var arrMenu = NSMutableArray()
    var walletAmount = ""
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        tblView.tableFooterView = UIView()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
         createMenu()
        
        if kAppDelegate.userId == "" {
            btn_Login.isHidden = false
            lblUserName.isHidden = true
            imgProfile.image = UIImage.init(named: "default_profile.png")
        } else {
            btn_Login.isHidden = true
            lblUserName.isHidden = false
            lblUserName.text = "\(string(kAppDelegate.userInfo, "first_name")) \(string(kAppDelegate.userInfo, "last_name"))"
            imgProfile.sd_setImage(with: URL.init(string: string(kAppDelegate.userInfo, "image")), placeholderImage: UIImage.init(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: FUNCTIONS
    @IBAction func click_On_Login(_ sender: Any) {
    self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "LoginVC"), animated: true)
        self.sideMenuViewController.hideViewController()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        self.navigationController?.pushViewController(vc, animated: true)

    }
    func createMenu() {
        arrMenu = []
        if kAppDelegate.userId == "" {
            arrMenu.add(getMutable(["title": "Home", "image": "menu_home", "status": "0"]))
            arrMenu.add(getMutable(["title": "Share", "image": "share", "status": "0"]))

        } else {
            arrMenu.add(getMutable(["title": "Home", "image": "menu_home", "status": "0"]))
            
            arrMenu.add(getMutable(["title": "Appointment", "image": "menu_appointment", "status": "0"]))
            arrMenu.add(getMutable(["title": "Add Payment", "image": "menu_add_pay", "status": "0"]))
            arrMenu.add(getMutable(["title": "Profile", "image": "menu_profile", "status": "0"]))
            arrMenu.add(getMutable(["title": "Settings", "image": "menu_setting", "status": "0"]))
            arrMenu.add(getMutable(["title": "Promotion Favorite", "image": "megaphone", "status": "0"]))
            arrMenu.add(getMutable(["title": "Logout", "image": "menu_logout", "status": "0"]))
            arrMenu.add(getMutable(["title": "Share", "image": "share", "status": "0"]))
        }
        

        tblView.reloadData()
    }
    
    func getMutable(_ dt:Dictionary<String, Any>) -> NSMutableDictionary {
        return NSMutableDictionary(dictionary: dt)
    }
    
    //MARK: TABLEVIEW DELEGATE AND DATASOURCE.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        let dict = arrMenu.object(at: indexPath.row) as! NSMutableDictionary
        cell.lblTitle.text = string(dict, "title")
        cell.imgTitle.image = UIImage(named: string(dict, "image"))
        
        if string(dict, "status") == "1" {
            cell.backgroundColor = PredefinedConstants.appColor().withAlphaComponent(0.8)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0..<arrMenu.count {
            let dictMenu =  arrMenu.object(at: i) as! NSMutableDictionary
            dictMenu.setValue("0", forKey: "status")
            arrMenu.replaceObject(at: i, with: dictMenu)
        }
        
        let dict = arrMenu.object(at: indexPath.row) as! NSMutableDictionary
        dict.setValue("1", forKey: "status")
        arrMenu.replaceObject(at: indexPath.row, with: dict)
        tblView.reloadData()
        
        //Push View Controller
        
        let strTitle = dict.object(forKey: "title") as! String
        //AvailabilityNav
        if strTitle == "Home" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC"), animated: true)
            self.sideMenuViewController.hideViewController()
        } else if strTitle == "Favorite" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "FavoriteNav"), animated: true)
            self.sideMenuViewController.hideViewController()
        } else if strTitle == "Promotion Favorite" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "promotionFav"), animated: true)
            self.sideMenuViewController.hideViewController()
        } else if strTitle == "Appointment" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "AppointmenListNav"), animated: true)
            self.sideMenuViewController.hideViewController()
        } else if strTitle == "Add Payment" {
            //self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "NavNotification"), animated: true)
            self.sideMenuViewController.hideViewController()
        } else if strTitle == "Share" {
            let items = ["24Hour Promotion Code Appstore link"]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
//            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "ChatNav"), animated: true)
//            self.sideMenuViewController.hideViewController()
            
        } else if strTitle == "Profile" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC"), animated: true)
            self.sideMenuViewController.hideViewController()
        } else if strTitle == "Settings" {
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "SettingVC"), animated: true)
            self.sideMenuViewController.hideViewController()
        } else if strTitle == "Logout" {
            self.sideMenuViewController.hideViewController()
            Http.alert(AlertMsg.strAlert, AlertMsg.logoutMsg, [self, "Yes", "No"])
        }
    }
    
    override func alertZero() {
        kAppDelegate.logOut()
    }
    
    

}//Class End.

