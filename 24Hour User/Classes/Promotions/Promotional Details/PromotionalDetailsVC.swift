//
//  PromotionalDetailsVC.swift
//  24Hour User
//
//  Created by mac on 03/06/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class PromotionalDetailsVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblDesription: UILabel!
    
    
    //MARK: VARIABLES
    var dictDetails = NSDictionary()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        print(dictDetails)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    
    @IBAction func click_Copy(_ sender: Any) {
        UIPasteboard.general.string = string(dictDetails, "promo_code")
       Http.alert("24Hour", "Code has been copied")
        // or use  sender.titleLabel.text

    }
    @IBAction func AddToFav(_ sender: Any) {
        wsMakeFav()
    }
    @IBAction func Share(_ sender: Any) {
        let items = ["24Hour Promotion Code - \(string(dictDetails, "promo_code"))"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    @IBAction func actionHome(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: FUNCTIONS
    func setDetails() {
        imgView.sd_setImage(with: URL(string: string(dictDetails, "image_path")), placeholderImage: UIImage(named: "no_image.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        lblName.text = "Promotion Name: \(string(dictDetails, "offer_name"))"
        lblValidity.text = "Promotion Validity: \(string(dictDetails, "offer_validity"))"
        lblCode.text = "Promotion Code: \(string(dictDetails, "promo_code"))"
        lblDesription.text = "Promotion Description: \(string(dictDetails, "offer_description"))"
    }
    
    //MARK: WS_MAKE_FAV
    func wsMakeFav() {
        //http://24hdr.com/doctors/webservice/add_fav_promotion?user_id=37&promotion_id=5
        let params = NSMutableDictionary()
        
        params["user_id"] = kAppDelegate.userId
        params["promotion_id"] = string(dictDetails, "id")
        
        Http.instance().json(add_fav_promotion, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
             self.navigationController?.popToRootViewController(animated: true)
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End
