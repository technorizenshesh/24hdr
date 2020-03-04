//
//  HomeVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class HomeVC: UIViewController,CountryListDelegate,UISearchBarDelegate{
    
    //MARK: OUTLETS
  
    @IBOutlet weak var img_Banner: UIImageView!
    @IBOutlet weak var lbl_Country: UILabel!
    @IBOutlet weak var search_bar: UISearchBar!
    @IBOutlet weak var cvView: UICollectionView!
    var filtered : NSArray! = []
    var searchActive : Bool = false
    
    //MARK: VARIABLES
    var arrCategory = NSArray()
    var imgPath = ""
    var arrBannerImage = NSArray()
    var countryList = CountryList()

    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        wsGetCategory()
        countryList.delegate = self
        wsGetBanner()   
//        countryList.delegate = self as! CountryListDelegate

    }
    func selectedCountry(country: Country) {
        print(country.name)
        self.lbl_Country.text = country.name
        print(country.flag)
        print(country.countryCode)
        print(country.phoneExtension)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        if kAppDelegate.userId == "" {
            if let arrayOfTabBarItems = tabBarController!.tabBar.items as AnyObject as? NSArray,let
                tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem,let
                tabBarItem2 = arrayOfTabBarItems[2] as? UITabBarItem,let
                tabBarItem3 = arrayOfTabBarItems[3] as? UITabBarItem,let
                tabBarItem4 = arrayOfTabBarItems[4] as? UITabBarItem {
                tabBarItem.isEnabled = false
                tabBarItem2.isEnabled = false
                tabBarItem3.isEnabled = false
                tabBarItem4.isEnabled = false
            }
        } else {
            if let arrayOfTabBarItems = tabBarController!.tabBar.items as AnyObject as? NSArray,let
                tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem,let
                tabBarItem2 = arrayOfTabBarItems[2] as? UITabBarItem,let
                tabBarItem3 = arrayOfTabBarItems[3] as? UITabBarItem,let
                tabBarItem4 = arrayOfTabBarItems[4] as? UITabBarItem {
                tabBarItem.isEnabled = true
                tabBarItem2.isEnabled = true
                tabBarItem3.isEnabled = true
                tabBarItem4.isEnabled = true
            }
            
        }
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
        self.cvView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        search_bar.showsCancelButton = false
        search_bar.text = ""
        search_bar.resignFirstResponder()
        self.cvView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            search_bar.showsCancelButton = false
            self.cvView.reloadData()
        }
        else {
            search_bar.showsCancelButton = false
            let searchPredicate = NSPredicate(format: "category_name CONTAINS[C] %@", searchText)
            
            filtered = (arrCategory as NSArray).filtered(using: searchPredicate) as NSArray
            searchActive = true;
            self.cvView.reloadData()
            
        }
    }
    
    //MARK: ACTIONS
    
    @IBAction func Click_on_Cat(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func actionHome(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func actionMap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorMapVC") as! DoctorMapVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchEditingChanged(_ sender: Any) {
        
    }
    
    @IBAction func actionDoctorList(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorsVC") as! DoctorsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: FUNCTIONS
    
    
    //MARK: WS_GET_CATEGORY
    func wsGetCategory() {
        
        let params = NSMutableDictionary()
        
        Http.instance().json(api_category_specialist, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrCategory = result
                    self.imgPath = string(responce, "image_path")
                    self.cvView.reloadData()
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    func wsGetBanner() {
        
        let params = NSMutableDictionary()
        
        Http.instance().json(get_banner_image, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrBannerImage = result
                    let dic = self.arrBannerImage.object(at: 0) as! NSDictionary
                    let imag  = string(dic, "image")
                    DispatchQueue.main.async {
                        
                        self.img_Banner.sd_setImage(with: URL(string: "\(self.imgPath)\(string(dic, "image"))"), placeholderImage: UIImage(named: ""), options: SDWebImageOptions(rawValue: 1), completed: nil)

                    }
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End


extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return (arrCategory.count + (arrCategory.count / 4) + 1)
        if searchActive == true {
            return filtered.count
        }
         return arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row % 4 == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell2", for: indexPath) as! HomeCell2
//            return cell
//        } else {
        //- ((indexPath.row/4) + 1)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell1", for: indexPath) as! HomeCell1

            let index = indexPath.row
        
        if searchActive == true {
            
            let dict = filtered.object(at: index) as! NSDictionary
            cell.imgView.sd_setImage(with: URL(string: "\(imgPath)\(string(dict, "image"))"), placeholderImage: UIImage(named: "no_image.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
            cell.lblName.text = string(dict, "category_name")
        } else {
            
            let dict = arrCategory.object(at: index) as! NSDictionary
            cell.imgView.sd_setImage(with: URL(string: "\(imgPath)\(string(dict, "image"))"), placeholderImage: UIImage(named: "no_image.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
            cell.lblName.text = string(dict, "category_name")
        }
        
        
        
            return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row % 4 == 0 {
//            let width = PredefinedConstants.ScreenWidth
//            return CGSize(width: width, height: width * 0.156)
//        } else {
            let width = PredefinedConstants.ScreenWidth/3-10
            return CGSize(width: width, height: width)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row % 4 != 0 {
//            let index = indexPath.row - ((indexPath.row/4) + 1)
        if searchActive == true {
            let index = indexPath.row
            let dict = filtered.object(at: index) as! NSDictionary
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorsVC") as! DoctorsVC
            vc.categoryId = string(dict, "id")
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let index = indexPath.row
            let dict = arrCategory.object(at: index) as! NSDictionary
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorsVC") as! DoctorsVC
            vc.categoryId = string(dict, "id")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        }
    }
    
}
