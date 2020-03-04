//
//  PickAddressVC.swift
//  Aqua Claire
//
//  Created by mac on 16/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MapKit


class PickAddressVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UITextFieldDelegate, MKLocalSearchCompleterDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vwDropUp: UIView!
    @IBOutlet weak var tfDropUp: UITextField!
    @IBOutlet var vwAddress: UIView!
    @IBOutlet weak var tblAddress: UITableView!
    
    //MARK: VARIABLES
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var destinationCordinate = CLLocation(latitude: 0.0, longitude: 0.0)
    var timer = Timer()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
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
    
    @IBAction func actionDone(_ sender: Any) {
        let mDict = NSMutableDictionary()
        mDict["address"] = tfDropUp.text ?? ""
        mDict["coordinate"] = destinationCordinate
        NotificationCenter.default.post(name: NSNotification.Name("address"), object: mDict)
        goBack()
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let length = textField.text!.count + string.count - range.length
        if length > 0 {
            addAddressVwFrame()
        } else {
            vwAddress.removeFromSuperview()
        }
        return true
    }
    
}//Class End
