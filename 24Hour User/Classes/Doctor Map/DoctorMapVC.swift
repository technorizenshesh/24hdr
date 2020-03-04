//
//  DoctorMapVC.swift
//  24Hour User
//
//  Created by mac on 15/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage
import DropDown


class DoctorMapVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UITextFieldDelegate, MKLocalSearchCompleterDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vwDropUp: UIView!
    @IBOutlet weak var tfDropUp: UITextField!
    @IBOutlet var vwAddress: UIView!
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var vwFilter: UIView!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var tfDistance: UITextField!
    
    //MARK: VARIABLES
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var destinationCordinate = CLLocation(latitude: 0.0, longitude: 0.0)
    var timer = Timer()
    var arrList = NSArray()
    var isFilter = false
    var categoryId = ""
    var distance = ""
    var dropCategory = DropDown()
    var dropDistance = DropDown()

    
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        vwFilter.isHidden = true
        searchCompleter.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        wsGetDoctors()
    }
    
    func configureDropDown() {
        dropCategory.anchorView = tfCategory
        dropCategory.dataSource = ["Eye", "Teeth", "Brain"]
        dropCategory.selectionAction = {[unowned self] (index, item) in
            print("item-\(item)-")
        }
        dropDistance.anchorView = tfCategory
        dropDistance.dataSource = ["1 KM", "2 KM", "5 KM", "10 KM", "15 KM"]
        dropDistance.selectionAction = {[unowned self] (index, item) in
            print("item-\(item)-")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateLocation)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        isFilter = !isFilter
        if isFilter {
            vwFilter.isHidden = false
        } else {
            hideFilter()
        }
    }
    
    @IBAction func actionRemoveFilter(_ sender: Any) {
        hideFilter()
    }
    
    @IBAction func actionResetFilter(_ sender: Any) {
        hideFilter()
        categoryId = ""
        distance = ""
    }
    
    @IBAction func actionDoneFilter(_ sender: Any) {
        hideFilter()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        let mDict = NSMutableDictionary()
        //mDict["address"] = tfDropUp.text ?? ""
        //mDict["coordinate"] = destinationCordinate
        //NotificationCenter.default.post(name: NSNotification.Name("address"), object: mDict)
        //goBack()
    }
    
    @IBAction func dropUpEditingChanged(_ sender: Any) {
        updateSearchResults(tf: tfDropUp)
    }
    
    @IBAction func actionClearPickUp(_ sender: Any) {
        tfDropUp.text = ""
    }
    
    @IBAction func actionGetCurrent(_ sender: Any) {
        updateLocation()
    }
    
    
    //MARK: FUNCTIONS
    func hideFilter() {
        isFilter = false
        vwFilter.isHidden = true
    }
    
    
    @objc func updateLocation() {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        if mapView.userLocation.coordinate.latitude > 0.0 {
            getAdressName(coords: mapView.userLocation.location!)
            timer.invalidate()
            self.destinationCordinate = self.mapView.userLocation.location!
        }
    }
    
    func addAddressVwFrame() {
        self.view.addSubview(vwAddress)
        vwAddress.frame.size.width = self.view.frame.width - 20
        vwAddress.center.x = self.view.center.x
        let originY = vwDropUp.frame.origin.y + vwDropUp.frame.size.height + 10
        vwAddress.frame.size.height = self.view.frame.height - originY
        vwAddress.frame.origin.y = originY
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateSearchResults(tf: UITextField) {
        searchCompleter.queryFragment = tf.text!
    }
    
    func getAdressName(coords: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                print("Hay un error")
            } else {
                
                let place = placemark! as [CLPlacemark]
                
                if place.count > 0 {
                    let place = placemark![0]
                    
                    var adressString : String = ""
                    
                    if place.subLocality != nil {
                        adressString = adressString + place.subLocality! + ", "
                    }
                    if place.thoroughfare != nil {
                        adressString = adressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + place.subThoroughfare! + ", "
                    }
                    if place.locality != nil {
                        adressString = adressString + place.locality! + " "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + place.postalCode! + ", "
                    }
                    if place.country != nil {
                        adressString = adressString + place.country!
                    }
                    self.tfDropUp.text = adressString
                }
            }
        }
    }
    
    func addMapPin() {
        for i in 0..<arrList.count {
            let dict = arrList.object(at: i) as! NSDictionary
            
            let annotation = CustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(truncating: number(dict, "lat")), longitude: Double(truncating: number(dict, "lon")))
            annotation.title = "\(string(dict, "first_name")) \(string(dict, "last_name"))"
            annotation.subtitle = string(dict, "location")
            annotation.imageName = string(dict, "image_path")
            mapView.addAnnotation(annotation)
            mapView.reloadInputViews()
        }
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
    
    //MARK: COMPLETER DELEGATE
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tblAddress.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
    
    //MARK: MAPVIEW DELEGATE
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        destinationCordinate = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        getAdressName(coords: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        /*guard (annotation is MKUserLocation) else {
            let anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "id")
            anView.image = UIImage(named: "address")
            return anView
            //return nil
        }*/
        
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
    
    //MARK: TABLEVIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = "\(searchResult.title) \(searchResult.subtitle)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: item)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if response != nil {
                self.destinationCordinate = (response?.mapItems[0].placemark.location)!
                //self.tfDropUp.text = (response?.mapItems[0].placemark.title)!
                self.tfDropUp.text = "\(item.title) \(item.subtitle)"
                self.mapView.setCenter(self.destinationCordinate.coordinate, animated: true)
            }
        }
        
        vwAddress.removeFromSuperview()
    }
    
    //MARK: TEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfCategory {
            return false
        } else if textField == tfDistance {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let length = textField.text!.count + string.count - range.length
        if length > 0 {
            addAddressVwFrame()
        } else {
            vwAddress.removeFromSuperview()
        }
        return true
    }
    
    
    //MARK: WS_GET_DOCTORS
    func wsGetDoctors() {

        let params = NSMutableDictionary()
        params["patient_id"] = kAppDelegate.userId
        
        Http.instance().json(api_doctor_list, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrList = result
                    self.addMapPin()
                }
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
}//Class End





class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
