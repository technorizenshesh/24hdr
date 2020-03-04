//
//  myBookingVC.swift
//  24Hour User
//
//  Created by mac on 09/07/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage
import FSCalendar

fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
fileprivate var dateFormatter2: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter
}()

class myBookingVC: UIViewController,UITableViewDataSource,UITableViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var text_ViewReason: UITextView!
    @IBOutlet weak var text_SlectDate: UITextField!
    @IBOutlet weak var text_SlectTime: UITextField!
    @IBOutlet var view_Reshedule: UIView!
    @IBOutlet var view_CollectDate: UIView!
    @IBOutlet var view_Claendar: UIView!
    //MARK: OUTLETS
    @IBOutlet weak var collection_Time: UICollectionView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: VARIABLES
    var arrList = NSArray()
    var strApoiID:String! = ""
    var textField: UITextField?
    var isSlectTime:Int! = -1
    var arrScheduled = [String]()
    var arrBookedTime = [String]()
    var isDayFalse:String! = ""
    var arrDates = NSArray()
    var strDocID:String! = ""

    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        wsGetAppointment()
        tblView.estimatedRowHeight = 140
        tblView.rowHeight = UITableView.automaticDimension
        view_Reshedule.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view_Reshedule.frame = self.view.frame
        
        view_CollectDate.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view_CollectDate.frame = self.view.frame
        
        view_Claendar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view_Claendar.frame = self.view.frame
        
        arrScheduled = setTimeArray()
        text_ViewReason.text = "Please enter reason"
        text_ViewReason.textColor = UIColor.lightGray

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if text_ViewReason.textColor == UIColor.lightGray {
            text_ViewReason.text = nil
            text_ViewReason.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if text_ViewReason.text.isEmpty {
            text_ViewReason.text = "Please enter reason"
            text_ViewReason.textColor = UIColor.lightGray
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        view_Reshedule.removeFromSuperview()
        view_Claendar.removeFromSuperview()
        view_CollectDate.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == text_SlectDate {
            wsGetSchedulingDate()
            return false
        } else if textField == text_SlectTime {
            if text_SlectDate.text?.count == 0 {
                Http.alert(appName, AlertMsg.selectDate)
            } else if isDayFalse != "true" {
                self.view.addSubview(view_CollectDate)
            } else {
                Http.alert(appName, AlertMsg.sDoctorNotAviable)
            }
            return false
        }
        return true
    }
    //MARK:GetTimeSlot
    func setTimeArray() -> [String] {
        var array: [String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm a"
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "hh:mm"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dt = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dt)
        let Curdate = dt.toString(dateFormat: "dd-MM-yyyy")
        let Nxtdate = tomorrow!.toString(dateFormat: "dd-MM-yyyy")
        let startDate = "\(Curdate) 06:00"
        let endDate = "\(Nxtdate) 11:00"
        
        let date1 = formatter.date(from: startDate)
        let date2 = formatter.date(from: endDate)
        let interval = 20
        let interval2 = 40
        
        let string = formatter3.string(from: date1!)
        let dateF = date1!.addingTimeInterval(TimeInterval(interval*60))
        let stringF = formatter2.string(from: dateF)
        array.append("\(string)-\(stringF)")
        var i = 1
        while true {
            let date = date1?.addingTimeInterval(TimeInterval(i*interval*60))
            let date23 = date?.addingTimeInterval(TimeInterval(interval*60))
            
            let string = formatter3.string(from: date!)
            let stringAM = formatter2.string(from: date23!)
            
            if date! >= date2! {
                break;
            }
            
            i += 1
            array.append("\(string)-\(stringAM)")
        }
        
        return array
    }
    //MARK: ACTIONS
    @IBAction func Cancel(_ sender: Any) {
        self.view_Reshedule.removeFromSuperview()

    }
    @IBAction func actionHome(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    @IBAction func BookAppointment(_ sender: Any) {
        if let strMsg = checkValidations() {
            Http.alert(appName, strMsg)
        } else {
            self.view_Reshedule.removeFromSuperview()
            wsResheduleAppointment()
        }

    }
    
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Enter delete appointment reason";
        }
    }
    
    func openAlertView() {
        let alert = UIAlertController(title: appName, message:"Reason of delete appointment" , preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            if self.textField?.text?.count != 0 {
                self.wsDeletAppointment()
            } else {
                Http.alert(appName, "Please enter reason")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: FUNCTIONS
    func checkValidations() -> String? {
        
        if text_SlectDate.text?.count == 0 {
            return AlertMsg.selectBookDate
        } else if text_SlectTime.text?.count == 0 {
            return AlertMsg.selectBookTime
        } 
        return nil
    }

    //MARK:API
    func wsGetSchedulingDate() {
        
        let params = NSMutableDictionary()
        params["doctor_id"] = strDocID
        let images = NSMutableArray()
        Http.instance().json(get_schedule_status, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrDates = result.map({($0 as! NSDictionary).value(forKey: "close_date")}) as NSArray
                    self.view.addSubview(self.view_Claendar)

                    print(self.arrDates)
                }
            } else {
                self.arrDates  = []
            }
        }
    }
    func wsGetScheduling(_ strDate: String) {
        
        let params = NSMutableDictionary()
        params["doctor_id"] = strDocID
        params["close_date"] = strDate
        let images = NSMutableArray()
        
        Http.instance().json(get_schedule_close, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                
                if let result = responce.object(forKey: "result") as? NSDictionary {
                    let strClos = result.object(forKey: "close_time") as! String
                    let book = strClos.components(separatedBy: ",")
                    self.isDayFalse = (result.object(forKey: "full_day_status") as! String)
                    let output = self.arrScheduled.filter{ !book.contains($0) }
                    print( output)
                    self.arrScheduled = []
                    self.arrScheduled = output
                    self.collection_Time.reloadData()
                }
            } else {
                self.arrScheduled  = []
            }
        }
    }
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
    //MARK: WS_DLETE
    func wsDeletAppointment() {
        
        let params = NSMutableDictionary()
        params["id"] = strApoiID
        params["reason"] = textField?.text!

        Http.instance().json(delete_schedule, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                    self.wsGetAppointment()
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    //MARK: WS_RESHEDUL
    func wsResheduleAppointment() {
        
        let params = NSMutableDictionary()
        params["date"] = text_SlectDate.text!
        params["time"] = text_SlectTime.text!
        params["Reason"] = text_ViewReason.text!
        params["id"] = strApoiID

        Http.instance().json(re_seduling, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                self.wsGetAppointment()
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell123", for: indexPath) as! AppointmentCell
        let dict = arrList.object(at: indexPath.row) as! NSDictionary
        let dictDoctor = dict.object(forKey: "doctor_details") as! NSDictionary
        cell.imgView.sd_setImage(with: URL(string: "\(image_url)\(string(dictDoctor, "image"))"), placeholderImage: UIImage(named: "default_profile.png"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        cell.lblName.text = "\(string(dictDoctor, "first_name")) \(string(dictDoctor, "last_name"))"
//        cell.lblAddress.text = string(dictDoctor, "location")
        cell.lblTime.text = string(dict, "time")
        
        let strDate = string(dict, "date")

        if strDate.count != 0 {
            cell.lblDate.text = strDate
            cell.lblTime.text = string(dict, "time")

//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd/MM/yyyy"
//            let date = formatter.date(from: strDate)
//            formatter.dateFormat = "dd MMM yyyy"
//            cell.lblDate.text = formatter.string(from: date!)
//            //let weekday = Calendar.current.component(.weekday, from: date!)
//            formatter.dateFormat = "EEEE"
//            cell.lblDay.text = formatter.string(from: date!)
        }
        
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(clci_Delet), for: .touchUpInside)
        
        cell.btn_Reschedule.tag = indexPath.row
        cell.btn_Reschedule.addTarget(self, action: #selector(clci_Fave), for: .touchUpInside)

        return cell
    }
    @objc func clci_Delet(bj:UIButton)  {
        let dict = arrList.object(at: bj.tag) as! NSDictionary
        strApoiID = string(dict, "id")
        openAlertView()
    }
    @objc func clci_Fave(bj:UIButton)  {
        let dict = arrList.object(at: bj.tag) as! NSDictionary
        let dictDoctor = dict.object(forKey: "doctor_details") as! NSDictionary
        strDocID = string(dictDoctor, "id")
        strApoiID = string(dict, "id")
        let strDate = string(dict, "date")
        let strtime = string(dict, "time")
        text_SlectTime.text = strtime
        text_SlectDate.text = strDate
        text_ViewReason.text = "Please enter reason"
        self.view.addSubview(view_Reshedule)

//        self.datePickerTapped(strFormat: "dd/MM/YYYY", mode: .date) { (strdatee) in
//            self.wsResheduleAppointment(strDate: "", strTime: "")
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    //MARK: UICOLLECTION VIEW DELEGATE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrScheduled.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
            //arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
            cell.lblTime.layer.cornerRadius = 5
            cell.lblTime.layer.borderWidth = 1
            cell.lblTime.layer.borderColor = Http.hexStringToUIColor("#289CA0").cgColor
            cell.lblTime.clipsToBounds = true

            if isSlectTime == indexPath.row {
                cell.lblTime.backgroundColor = Http.hexStringToUIColor("#289CA0")
                cell.lblTime.textColor = UIColor.white
            } else {
                cell.lblTime.backgroundColor = UIColor.white
                cell.lblTime.textColor = Http.hexStringToUIColor("#289CA0")
            }
            cell.lblTime.text = arrScheduled[indexPath.row]
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            //arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
            isSlectTime = indexPath.row
            text_SlectTime.text = arrScheduled[indexPath.row]
            collection_Time.reloadData()
            view_CollectDate.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (PredefinedConstants.ScreenWidth - 56) / 3
            return CGSize(width: width, height: 50)
    }
}
extension myBookingVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate2 = formatter.string(from: date)
        text_SlectDate.text = strDate2
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate = formatter.string(from: date)
        text_SlectTime.text = ""
        wsGetScheduling(strDate)
        view_Claendar.removeFromSuperview()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        //        arrDates = self.getUserSelectedDates(arr_CurrentDay, calender: self.vwCalender)
    }
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // arrDates = self.getUserSelectedDates(arr_CurrentDay, calender: self.vwCalender)
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if (arrDates.contains(dateFormatter2.string(from: date))) {
            return UIColor.lightGray
        } else {
            return UIColor.black
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if arrDates.contains(dateFormatter2.string(from: date)) {
            return false
        }
        else {
            return true
        }
    }
    
}
