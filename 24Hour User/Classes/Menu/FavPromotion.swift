//
//  FavPromotion.swift
//  24Hour User
//
//  Created by mac on 20/08/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class FavPromotion: UIViewController  {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!

    //MARK: VARIABLES
    var arrList = NSArray()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        wsOfferList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }

    //MARK: WS_OFFER_LIST
    
    func wsOfferList() {
        //http://24hdr.com/doctors/webservice/get_bookmark?user_id=31+
        //http://24hdr.com/doctors/webservice/get_promotion_fav?user_id=37
      
        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId

        Http.instance().json(get_bookmark, params, true, nil, self.view) { (responce) in
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
    func delete_cart_item(strId:String) {
        //http://24hdr.com/doctors/webservice/delete_cart_item?promo_fav_id=171
        
        let params = NSMutableDictionary()
        params["promo_fav_id"] = strId
        
        Http.instance().json(delete_cart_item25, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                self.wsOfferList()
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End


extension FavPromotion: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionalCell", for: indexPath) as! PromotionalCell
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        
        cell.imgView.sd_setImage(with: URL(string: "http://24hdr.com/doctors/uploads/images/\(string(dict, "offer_image"))"), placeholderImage: UIImage(named: "no_image.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
      
        cell.lblName.text = "Promotion Name: \(string(dict, "offer_name"))"
        cell.lblDetails.text = "Promotion Description: \(string(dict, "offer_description"))"
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(deletItme), for: .touchUpInside)
        return cell
    }
    @objc func deletItme(isd:UIButton)  {
        let dict = arrList.object(at: isd.tag) as! NSDictionary
        delete_cart_item(strId: dict["promotion_id"]! as! String)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromotionalDetailsVC") as! PromotionalDetailsVC
//        vc.dictDetails = arrList.object(at: indexPath.row) as! NSDictionary
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

