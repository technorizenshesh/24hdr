
//  DoctorDetails.swift
//  24Hour User
//  Created by mac on 04/05/19.
//  Copyright © 2019 mac. All rights reserved.

import UIKit
import MapKit
import SDWebImage


class docCell:UITableViewCell {

    @IBOutlet weak var lbl_Review: UILabel!
    @IBOutlet weak var starTotal: FloatRatingView!
    @IBOutlet weak var lbl_Username: UILabel!
    @IBOutlet weak var img_User: ImageView!
    
}
class faciliCell:UICollectionViewCell {
    @IBOutlet weak var lbl_Facil: UILabel!
    @IBOutlet weak var lbl_ClinHos: UILabel!
    @IBOutlet weak var lbl_Special: UILabel!
    @IBOutlet weak var lbl_TotalDoc: UILabel!
    @IBOutlet weak var lbl_clin: UILabel!
    @IBOutlet weak var img_Doc: ImageView!
    @IBOutlet weak var lbl_facDesc: UILabel!
}
class DoctorDetails: UIViewController, MKMapViewDelegate,UITextViewDelegate {
    @IBOutlet weak var trans_View: UIView!
    
    @IBOutlet weak var view_RateSuggest: UIView!
    @IBOutlet weak var rateByUser: FloatRatingView!
    @IBOutlet weak var text_Comment: UITextView!
    @IBOutlet weak var table_height: NSLayoutConstraint!
    @IBOutlet weak var table_Review: UITableView!
    @IBOutlet weak var lbl_likeCount: UILabel!
    @IBOutlet weak var btn_Like: UIButton!
    @IBOutlet weak var btn_Fav: UIButton!
    //MARK: OUTLETS
    @IBOutlet weak var collec_AffiHospi: UICollectionView!
    @IBOutlet weak var collect_Facilty: UICollectionView!
    @IBOutlet weak var imgView: ImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblMAle: UILabel!
    
    //    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lbl_Avial: UILabel!
    @IBOutlet weak var lbl_Specilist: UILabel!
    
    @IBOutlet weak var height_Collection: NSLayoutConstraint!
    //MARK: VARIABLES
    var dictDetails = NSDictionary()
    var favStatus = "no"
    var likestaus = "no"
    var arrFacilit:[String] = []
    var arrEducation:NSArray = []
    var arrExperience:NSArray = []
    var arrAllReview:NSArray = []

    var arrAffilHosp = NSArray()
    var imgPath = ""
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        text_Comment.text = "Enter Review"
        text_Comment.textColor = UIColor.lightGray

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            text_Comment.text = nil
            text_Comment.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            text_Comment.text = "Enter Review"
            text_Comment.textColor = UIColor.lightGray
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        trans_View.isHidden = true
    }
    //MARK: ACTIONS
    
    @IBAction func Cancel(_ sender: Any) {
          trans_View.isHidden = true
    }
    @IBAction func Submit(_ sender: Any) {
        if text_Comment.text != "Enter Review" {
            trans_View.isHidden = true
            wsMakeReview()
        } else {
            Http.alert(appName, "Please enter review")
        }
    }
    @IBAction func share(_ sender: Any) {
        
        
        let image = "Hii i have visited doctor profile Please have a look doctors profile on 24HDR Click :- http://24hdr.com/doctors/doctors_details.php/\(string(dictDetails, "id"))"
        
        let activityItems = [image]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityController, animated: true, completion: { () -> Void in
            
        })
        
    }
    @IBAction func comment(_ sender: Any) {
        if kAppDelegate.userId == "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.isBack = "back"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
              trans_View.isHidden = false
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
//            vc.strDocId = "\(string(dictDetails, "id"))"
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func likeOnDoct(_ sender: Any) {
        if kAppDelegate.userId == "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.isBack = "back"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            wsMakeLike()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionChat(_ sender: Any) {
        
        if kAppDelegate.userId == "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.isBack = "back"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConversationsVC") as! ConversationsVC
            vc.otherUserId = string(dictDetails, "id")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func actionFav(_ sender: Any) {
        wsMakeFav()
    }
    
    @IBAction func actionImmediate(_ sender: Any) {
        if kAppDelegate.userId == "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.isBack = "back"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionBook(_ sender: Any) {
        if kAppDelegate.userId == "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.isBack = "back"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentVC") as! AppointmentVC
            vc.strAmount = "\(number(dictDetails, "appointment_fee"))"
            vc.strOpenClos = "\(string(dictDetails, "status_day"))"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionPay(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentVC") as! AppointmentVC
        vc.strAmount = "\(number(dictDetails, "appointment_fee"))"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionRating(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: FUNCTIONS
    func setDetails() {
        
        print("dictDetails-\(dictDetails)-")
        
        imgView.sd_setImage(with: URL(string: "\(image_url)\(string(dictDetails, "image"))"), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        lblName.text = "\(string(dictDetails, "first_name")) \(string(dictDetails, "last_name"))"
        lblDistance.text = "\(string(dictDetails, "distance")) km"
        lblMAle.text = "\(string(dictDetails, "gender"))"
        lblMAle.text = "\(string(dictDetails, "gender"))"
        
        wsGetDoctors()
        wsGetLikeStatus()
        wsGeAllReview()
        
    }
    
    func addTwoImage(inImage:UIImage) -> UIImage? {
        ///Creating UIView for Custom Marker
        let DynamicView=UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        DynamicView.backgroundColor = UIColor.clear
        
        //Creating Marker Pin imageview for Custom Marker
        var imageViewForPinMarker : UIImageView
        imageViewForPinMarker  = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        imageViewForPinMarker.image = UIImage(named: "loca")
        imageViewForPinMarker.contentMode = .scaleAspectFit
        
        //Creating User Profile imageview
        var imageViewForUserProfile : UIImageView
        imageViewForUserProfile  = UIImageView(frame: CGRect(x: 6, y: 4, width: 28, height: 28))
        imageViewForUserProfile.clipsToBounds = true
        imageViewForUserProfile.layer.cornerRadius = 14
        imageViewForUserProfile.image = inImage
        
        //Adding userprofile imageview inside Marker Pin Imageview
        imageViewForPinMarker.addSubview(imageViewForUserProfile)
        
        //Adding Marker Pin Imageview isdie view for Custom Marker
        DynamicView.addSubview(imageViewForPinMarker)
        
        //Converting dynamic uiview to get the image/marker icon.
        UIGraphicsBeginImageContextWithOptions(DynamicView.frame.size, false, UIScreen.main.scale)
        DynamicView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageConverted: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return imageConverted
    }
    
    
    //MARK: WS_MAKE_FAV
    func wsMakeFav() {
        
        let params = NSMutableDictionary()
        
        params["user_id"] = kAppDelegate.userId
        params["doctor_id"] = string(dictDetails, "id")
        params["status"] = (favStatus == "unlike") ? "like" : "unlike"
        
        Http.instance().json(add_book_mark, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                self.favStatus = string(params, "status")
                if self.favStatus == "like" {
                     self.btn_Fav.setImage(UIImage(named: "bookCheck"), for: .normal)
                } else {
                     self.btn_Fav.setImage(UIImage(named: "bookmarkUncheck"), for: .normal)
               }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    func wsMakeLike() {
        
        let params = NSMutableDictionary()
        
        params["patient_id"] = kAppDelegate.userId
        params["doctor_id"] = string(dictDetails, "id")
        params["status"] = (likestaus == "unlike") ? "like" : "unlike"
        
        Http.instance().json(like_doctor, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                self.likestaus = string(params, "status")
                if self.likestaus == "like" {
                    self.btn_Like.setImage(UIImage(named: "likefill"), for: .normal)
                } else {
                    self.btn_Like.setImage(UIImage(named: "unlikeunfill"), for: .normal)
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    func wsMakeReview() {
     
        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId
        params["doctor_id"] = string(dictDetails, "id")
        params["rating"] = "\(rateByUser.rating)"
        params["comment"] = text_Comment.text!

        Http.instance().json(add_comment_Review, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
               self.wsGeAllReview()
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    func wsGetLikeStatus() {
        
        let params = NSMutableDictionary()
        
        params["user_id"] = kAppDelegate.userId
        params["doctor_id"] = string(dictDetails, "id")
        
        Http.instance().json(get_like_unlike_status, params, true, nil, self.view) { (responce) in
            
            print(responce)
            
            if number(responce, "status").boolValue {
                let result = responce["result"] as! NSDictionary
                if string(result, "bookmark") == "like" {
                    self.btn_Fav.setImage(UIImage(named: "bookCheck"), for: .normal)
                    self.favStatus = "no"
                } else {
                    self.btn_Fav.setImage(UIImage(named: "bookmarkUncheck"), for: .normal)
                    self.favStatus = "yes"
                }
                
                if string(result, "like_status") == "like" {
                    self.btn_Like.setImage(UIImage(named: "likefill"), for: .normal)
                    self.likestaus = "unlike"
                } else {
                    self.btn_Like.setImage(UIImage(named: "unlikeunfill"), for: .normal)
                    self.likestaus = "like"
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    //MARK: MAPVIEW DELEGATE
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties *AFTER*
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        print("cpa.imageName-\(cpa.imageName!)-")
        let imageURL = cpa.imageName
        if imageURL != "" {
            let img = imageURL!
            let urlwithPercentEscapes = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let urlLogo = URL(string: urlwithPercentEscapes!)
            print("urlLogo-\(urlLogo)-")
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: urlLogo!, options: .continueInBackground, progress: nil, completed: { (image, data, error, bool) in
                if let imag = image {
                    anView!.image = self.addTwoImage(inImage: imag)
                } else {
                    anView!.image = self.addTwoImage(inImage: UIImage(named: "default_profile.png")!)
                }
            })
        } else {
            anView!.image = UIImage(named: "loca")
        }
        
        return anView
    }
    
}//Class End


extension DoctorDetails: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return (arrCategory.count + (arrCategory.count / 4) + 1)
        if collectionView == collect_Facilty {
            return arrFacilit.count
        }
        return arrAffilHosp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! faciliCell
        
        let index = indexPath.row
        
        if collectionView == collect_Facilty {
            cell.lbl_Facil.text = arrFacilit[indexPath.row]
            if index == 0 {
                if arrExperience.count != 0 {
                    let dic = arrExperience[0] as! NSDictionary
                    cell.lbl_facDesc.text = "\((dic["from_date"] as!  String)) \((dic["to_date"] as!  String)) \((dic["hospital_name"] as!  String))"
                }
            }
            if index == 1 {
                if arrEducation.count != 0 {
                    let dic = arrEducation[0] as! NSDictionary
                    cell.lbl_facDesc.text = "\((dic["passout_date"] as!  String)) \((dic["education_name"] as!  String))"
                }
            }
            
        } else {
            
            let dict = arrAffilHosp.object(at: index) as! NSDictionary
            cell.img_Doc.sd_setImage(with: URL(string: "\(string(dict, "image"))"), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
            cell.lbl_clin.text = string(dict, "hospital_name")
            cell.lbl_ClinHos.text = string(dict, "hospital_name")
            cell.lbl_TotalDoc.text = "\(string(dict, "doctor_count")) Doctors"
            cell.lbl_Special.text = "\(string(dict, "specialist_count")) Specialists"
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collec_AffiHospi.frame.width, height: collec_AffiHospi.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if indexPath.row % 4 != 0 {
        //            let index = indexPath.row - ((indexPath.row/4) + 1)
        //        if searchActive == true {
        //            let index = indexPath.row
        //            let dict = filtered.object(at: index) as! NSDictionary
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorsVC") as! DoctorsVC
        //            vc.categoryId = string(dict, "id")
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        } else {
        //            let index = indexPath.row
        //            let dict = arrCategory.object(at: index) as! NSDictionary
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorsVC") as! DoctorsVC
        //            vc.categoryId = string(dict, "id")
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        
        //        }
    }
    
    //MARK: WS_GET_DOCTORS
    func wsGetDoctors() {
        //http://24hdr.com/doctors/webservice/affiliate_doctors?id=31
        let params = NSMutableDictionary()
        params["user_id"] = string(dictDetails, "id")
        
        Http.instance().json(api_get_profiles, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                
                self.arrFacilit = ["PROFESSIONAL EXPERIENCE","EDUCATION"]

                DispatchQueue.main.async {

                if let result = responce.object(forKey: "result") as? NSDictionary {
                    if let sdsd = result.object(forKey: "hospital_details") as? NSArray {
                        self.arrAffilHosp = sdsd
                    } else {
                        self.height_Collection.constant = 0
                    }
                    if let sdsddf = result.object(forKey: "experiance") as? NSArray {
                        self.arrExperience = sdsddf
                            self.collect_Facilty.reloadData()
                    }
                    if let sdsdsdsd = result.object(forKey: "education") as? NSArray {
                        self.arrEducation = sdsdsdsd
                            self.collect_Facilty.reloadData()
                    }
                    self.collec_AffiHospi.reloadData()
                }
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    func wsGeAllReview() {
        let params = NSMutableDictionary()
        params["doctor_id"] = string(dictDetails, "id")
        Http.instance().json(get_comment, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
               
                print(responce)
                self.view_RateSuggest.isHidden = true
                self.arrAllReview = responce.object(forKey: "result") as! NSArray
                self.table_height.constant = CGFloat(90*self.arrAllReview.count)
                self.table_Review.reloadData()
            } else {
                self.view_RateSuggest.isHidden = false
                //Http.alert(appName, string(responce, "result"))
            }
        }
    }
}
extension DoctorDetails: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllReview.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! docCell
        
        let dict = arrAllReview.object(at: indexPath.row) as! NSDictionary
        cell.img_User.sd_setImage(with: URL(string: "\(image_url)\(string(dict, "image"))"), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        
        let userDic = dict["user_details"] as! NSDictionary
        cell.lbl_Username.text = "\(string(userDic, "first_name")) \(string(dict, "last_name"))"
        cell.lbl_Review.text = string(dict, "comment")
        cell.starTotal.rating = Float(string(dict, "ratting")) as! Float
        
        return cell
    }
 
}
