//
//  DoctorsVC.swift
//  24Hour User
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class DoctorsVC: UIViewController {
    
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

    //MARK: WS_GET_DOCTORS
    func wsGetDoctors() {
        //http://24hdr.com/doctors/webservice/specialist_docter?user_type=doctor&speciality=3&patient_id=37&lat=22.69087028503418&lon=75.86912536621094
        let params = NSMutableDictionary()
      //  params["user_type"] = "doctor"
        params["speciality"] = categoryId
       // params["patient_id"] = kAppDelegate.userId
        params["lat"] = "\(kAppDelegate.locationManager.location?.coordinate.latitude ?? 0.0)"
        params["lon"] = "\(kAppDelegate.locationManager.location?.coordinate.longitude ?? 0.0)"

    Http.instance().json(api_specialist_docter, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrList = result
                    self.tblView.estimatedRowHeight = 200
                    self.tblView.rowHeight = UITableView.automaticDimension
                    self.tblView.reloadData()
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
}

extension DoctorsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorsCell", for: indexPath) as! DoctorsCell
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        cell.imgView.sd_setImage(with: URL(string: "\(image_url)\(string(dict, "image"))"), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        cell.lblName.text = "\(string(dict, "first_name")) \(string(dict, "last_name"))"
        cell.lblPost.text = string(dict, "location")
        cell.lblAddress.text = "\(string(dict, "distance")) km"
        cell.lbl_Speicality.text = string(dict, "specialist")

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorDetails") as! DoctorDetails
        vc.dictDetails = arrList.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
