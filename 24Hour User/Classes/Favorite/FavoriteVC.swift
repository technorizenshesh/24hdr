//
//  FavoriteVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class FavoriteVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!

    
    //MARK: VARIABLES
    var arrList = NSMutableArray()
    
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        wsGetFavourite()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    //MARK: FUNCTIONS

    //MARK: WS_GET_FAVOURITE
    func wsGetFavourite() {
        
        let params = NSMutableDictionary()
      
        params["patient_id"] = kAppDelegate.userId
        
        Http.instance().json(api_favorites_list, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrList = result.mutableCopy() as! NSMutableArray
                    self.tblView.reloadData()
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End

extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as! FavouriteCell
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        cell.imgView.sd_setImage(with: URL(string: string(dict, "image_path")), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        cell.lblName.text = "\(string(dict, "first_name")) \(string(dict, "last_name"))"
        cell.lblAddress.text = string(dict, "location")
        //cell.lblSesignation.text = string(dict, "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorDetails") as! DoctorDetails
        vc.dictDetails = arrList.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
