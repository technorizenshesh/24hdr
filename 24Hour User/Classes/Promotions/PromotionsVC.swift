//
//  PromotionsVC.swift
//  24Hour User
//
//  Created by mac on 03/06/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class PromotionsVC: UIViewController,UISearchBarDelegate {
    
   
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var search_bar: UISearchBar!
    
    //MARK: VARIABLES
    var arrList = NSArray()
    var filtered : NSArray! = []
    var searchActive : Bool = false
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        wsOfferList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: SearchbarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        search_bar.showsCancelButton = false
        searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        search_bar.showsCancelButton = true
        //        search_Bar.resignFirstResponder()
        //        search_Bar.text = ""
        //        self.table_List.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        search_bar.showsCancelButton = false
        search_bar.text = ""
        search_bar.resignFirstResponder()
        self.tblView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        search_bar.showsCancelButton = false
        search_bar.text = ""
        search_bar.resignFirstResponder()
        self.tblView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            search_bar.showsCancelButton = false
            self.tblView.reloadData()
        }
        else {
            search_bar.showsCancelButton = false
            let searchPredicate = NSPredicate(format: "offer_name CONTAINS[C] %@", searchText)
            
            filtered = (arrList as NSArray).filtered(using: searchPredicate) as NSArray
            searchActive = true;
            self.tblView.reloadData()
            
        }
    }
    //MARK: ACTIONS
    @IBAction func actionHome(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
 
    //MARK: WS_OFFER_LIST
    func wsOfferList() {

        let params = NSMutableDictionary()
        Http.instance().json(api_offerlist, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrList = result
                    self.tblView.reloadData()
                }} else {
                    Http.alert(appName, string(responce, "result"))
            }}
    }
    
    
}//Class End


extension PromotionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return filtered.count
        }
            return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionalCell", for: indexPath) as! PromotionalCell
        var dict:NSDictionary! = [:]
      
        if searchActive == true {
            dict = (filtered.object(at: indexPath.row) as! NSDictionary)
        } else {
            dict = (arrList.object(at: indexPath.row) as! NSDictionary)
        }
        cell.imgView.sd_setImage(with: URL(string: string(dict, "image_path")), placeholderImage: UIImage(named: "no_image.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        cell.lblName.text = "Promotion Name: \(string(dict, "offer_name"))"
        cell.lblDetails.text = "Promotion Description: \(string(dict, "offer_description"))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dict:NSDictionary! = [:]
        
        if searchActive == true {
            dict = (filtered.object(at: indexPath.row) as! NSDictionary)
        } else {
            dict = (arrList.object(at: indexPath.row) as! NSDictionary)
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromotionalDetailsVC") as! PromotionalDetailsVC
        vc.dictDetails = dict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
