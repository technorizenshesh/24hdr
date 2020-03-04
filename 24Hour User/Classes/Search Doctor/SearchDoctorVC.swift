//
//  SearchDoctorVC.swift
//  24Hour User
//
//  Created by mac on 15/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class SearchDoctorVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!
    
    
    //MARK: VARIABLES
    var categoryId = ""
    var arrList = NSArray()
    
    
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        wsGetDoctors()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: FUNCTIONS
    
    
    //MARK: WS_GET_DOCTORS
    func wsGetDoctors() {
        
        let params = NSMutableDictionary()
        params["user_type"] = "doctor"
        params["speciality"] = categoryId
        
        Http.instance().json(api_specialist_docter, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrList = result
                    self.tblView.reloadData()
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End

extension SearchDoctorVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorsCell", for: indexPath) as! DoctorsCell
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        cell.imgView.sd_setImage(with: URL(string: string(dict, "image")), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        cell.lblName.text = "\(string(dict, "first_name")) \(string(dict, "last_name"))"
        cell.lblAddress.text = string(dict, "location")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorDetails") as! DoctorDetails
        vc.dictDetails = arrList.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
