//
//  Appointment List.swift
//  24Hour User
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class AppointmentListVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: VARIABLES
    var arrList = NSArray()

    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        wsGetAppointment()
        tblView.estimatedRowHeight = 140
        tblView.rowHeight = UITableView.automaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    //MARK: FUNCTIONS
    
    
    //MARK: WS_GET_APPOINTMENT
    func wsGetAppointment() {

        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId
        
        Http.instance().json(api_my_appointment, params, true, nil, self.view) { (responce) in
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

extension AppointmentListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        let dictDoctor = dict.object(forKey: "doctor_details") as! NSDictionary
        cell.imgView.sd_setImage(with: URL(string: "\(image_url)\(string(dictDoctor, "image"))"), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        cell.lblName.text = "\(string(dictDoctor, "first_name")) \(string(dictDoctor, "last_name"))"
        cell.lblAddress.text = string(dictDoctor, "location")
        cell.lblTime.text = string(dict, "time")

        let strDate = string(dict, "date")
        if strDate.count != 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date = formatter.date(from: strDate)
            formatter.dateFormat = "dd MMM yyyy"
            cell.lblDate.text = formatter.string(from: date!)
            //let weekday = Calendar.current.component(.weekday, from: date!)
            formatter.dateFormat = "EEEE"
            cell.lblDay.text = formatter.string(from: date!)
        }
       

        return cell
    }
}
