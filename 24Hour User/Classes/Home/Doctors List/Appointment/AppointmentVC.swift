//
//  AppointmentVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FSCalendar

fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
fileprivate var dateFormatter2: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter
}()

class AppointmentVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {
    @IBOutlet weak var view_Disocu: UIView!
    
    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var text_Promo: UITextField!
    @IBOutlet weak var view_Total: UIView!
    //MARK: OUTLETS
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var lbl_TotalAmoun: UILabel!
    @IBOutlet weak var lbl_TAmount: UILabel!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var tfTime: UITextField!
    @IBOutlet weak var cvView: UICollectionView!
    @IBOutlet weak var btnUploadFile: Button!
    @IBOutlet weak var vwCvView: UIView!
    @IBOutlet var vwCalenderPopUp: UIView!
    @IBOutlet weak var vwCalender: FSCalendar!
    //    @IBOutlet weak var vwCalender: Koyomi!
    @IBOutlet var vwDaysPopUp: UIView!
    @IBOutlet weak var cvDays: UICollectionView!
    var isImmediate = false

    var isSlectTime:Int! = -1
    var arrScheduled = [String]()
    var arrBookedTime = [String]()
    var isDayFalse:String! = ""
    
    var arrDates = NSArray()
//    var arr_CurrentDay = NSMutableArray()
    var strOpenClos:String!
    var strAmount:String!
    //MARK: VARIABLES
    var arrList = NSMutableArray()
    var arrDays = ["12:01 PM", "01:02 PM", "02:03 PM", "03:04 PM", "04:05 PM", "05:06 PM", "06:07 PM", "07:08 PM", "08:09 PM", "09:10 PM"]
    var arrTimes = NSMutableArray()

    //MARK: LIFECYCLE
    //get_schedule_status
    override func viewDidLoad() {
        super.viewDidLoad()
        print(strOpenClos)
//        let arr_Day = strOpenClos.components(separatedBy: ",")
//
//        for i in 0..<arr_Day.count {
//            let strOpen = arr_Day[i]
//            if strOpen == "OPEN" {
//                arr_CurrentDay.append(i+1)
//            }
//        }
        arrList.add(UIImage(named: "camera1")!)
        vwCalenderPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        vwCalenderPopUp.frame = self.view.frame
        vwDaysPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        vwDaysPopUp.frame = self.view.frame
        getPrevClassValue()
        vwCalender.delegate = self
        vwCalender.dataSource = self
        lbl_TotalAmoun.text =  "NGN \(strAmount!)"
        
        arrScheduled = setTimeArray()
       print(arrScheduled)
        
        wsGetSchedulingDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        trans_View.isHidden = true
        view_Total.isHidden = true
        view_Disocu.isHidden = true
//        print(arr_CurrentDay)
//        arrDates = self.getUserSelectedDates(arr_CurrentDay, calender: self.vwCalender)

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
    
    @IBAction func cancel(_ sender: Any) {
        trans_View.isHidden = true
    }
    @IBAction func actionHome(_ sender: Any) {
        //self.sideMenuViewController.presentLeftMenuViewController()
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBAction func HavePromocode(_ sender: Any) {
        trans_View.isHidden = false
    }
    @IBAction func ok_Promo(_ sender: Any) {
        if text_Promo.text?.count != 0 {
            wsApplyPromoCode()
        } else {
            Http.alert(appName, "please enter promocode")
        }
    }

    @IBAction func actionRemoveCalender(_ sender: Any) {
        vwCalenderPopUp.removeFromSuperview()
    }
    @IBAction func actionRemoveDays(_ sender: Any) {
        vwDaysPopUp.removeFromSuperview()
    }
    var isFile = false

    @IBAction func actionUploadFile(_ sender: Any) {
        isFile = !isFile
        if isFile {
            btnUploadFile.setTitleColor(UIColor.white, for: .normal)
            btnUploadFile.backgroundColor = PredefinedConstants.appColor()
            vwCvView.isHidden = false
        } else {
            btnUploadFile.setTitleColor(PredefinedConstants.appColor(), for: .normal)
            btnUploadFile.backgroundColor = UIColor.white
            vwCvView.isHidden = true
        }
    }

    @IBAction func actionBook(_ sender: Any) {
        if let strMsg = checkValidations() {
            Http.alert(appName, strMsg)
        } else {
            wsSendRequest()
        }
    }
    
    //MARK: FUNCTIONS
    
    func checkValidations() -> String? {
        
        if tfDate.text?.count == 0 {
            return AlertMsg.selectBookDate
        } else if tfTime.text?.count == 0 {
            return AlertMsg.selectBookTime
        }
        return nil
    }
    
    //MARK: UITEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfDate {
            self.view.addSubview(vwCalenderPopUp)
            return false
        } else if textField == tfTime {
            if tfDate.text?.count == 0 {
                Http.alert(appName, AlertMsg.selectDate)
            } else if isDayFalse != "true" {
                self.view.addSubview(vwDaysPopUp)
            } else {
                Http.alert(appName, AlertMsg.sDoctorNotAviable)
            }
            return false
        }
        return true
    }
    
    
    //MARK: UICOLLECTION VIEW DELEGATE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == cvView) ? arrList.count : arrScheduled.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
            
            cell.imgView.isHidden = true
            cell.btnCamera.isHidden = true
            cell.btnCross.isHidden = true
            
            cell.btnCamera.tag = indexPath.row
            cell.btnCamera.addTarget(self, action: #selector(openCamera(sender:)), for: .touchUpInside)
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(deleteMedia(sender:)), for: .touchUpInside)
            
            if indexPath.row == 0 {
                cell.btnCamera.isHidden = false
                cell.btnCamera.setImage(arrList.object(at: 0) as? UIImage, for: .normal)
                
            } else {
                cell.btnCross.isHidden = false
                if let img = arrList.object(at: indexPath.row) as? UIImage {
                    cell.imgView.isHidden = false
                    cell.imgView.image = img
                }
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
            //arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
            cell.lblTime.layer.cornerRadius = 5
            cell.lblTime.layer.borderWidth = 1
            cell.lblTime.layer.borderColor = Http.hexStringToUIColor("#289CA0").cgColor
            cell.lblTime.clipsToBounds = true
        
            
//            if arrBookedTime.contains(arrScheduled[indexPath.row]) {
//                cell.lblTime.backgroundColor = UIColor.darkGray
//                cell.lblTime.textColor = UIColor.white
//            } else {
                if isSlectTime == indexPath.row {
                    cell.lblTime.backgroundColor = Http.hexStringToUIColor("#289CA0")
                    cell.lblTime.textColor = UIColor.white
                } else {
                    cell.lblTime.backgroundColor = UIColor.white
                    cell.lblTime.textColor = Http.hexStringToUIColor("#289CA0")
                }
//            }
         
            
            cell.lblTime.text = arrScheduled[indexPath.row]
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvDays {
            //arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
            isSlectTime = indexPath.row
            tfTime.text = arrScheduled[indexPath.row]
//            var mdict = NSMutableDictionary()
//
//            for i in 0..<arrTimes.count {
//                mdict = (arrTimes.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
//                if string(mdict, "schedule") == "0" {
//                    if indexPath.row == i {
//                        mdict["select"] = "1"
//                        tfTime.text = string(mdict, "time")
//                        //vwDaysPopUp.removeFromSuperview()
//                    } else {
//                        mdict["select"] = "0"
//                    }
//                    arrTimes.replaceObject(at: i, with: mdict)
//                }
//            }
            cvDays.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = PredefinedConstants.ScreenWidth/2
        if collectionView == cvView {
            return CGSize(width: 150.0, height: 150.0)
        } else {
            let width = (PredefinedConstants.ScreenWidth - 56) / 3
            return CGSize(width: width, height: 50)
        }
        
    }
    
    @objc func openCamera(sender: UIButton) {
        if sender.tag == 0 {
            openFileAttachment()
        }
    }
    
    @objc func deleteMedia(sender: UIButton) {
        self.arrList.removeObject(at: sender.tag)
        self.cvView.reloadData()
    }
    
    //MARK: CHOOSE MEDIA FILE
    func openFileAttachment() {
        self.view.endEditing(true)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: PICKERVIEW DELEGATE
    var profileImg: UIImage? = nil
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage? = nil
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if selectedImage != nil {
            self.arrList.add(selectedImage!)
        }
        self.cvView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    

    //MARK: ForCalendar

    func getUserSelectedDates(_ arrWeekDay: [Int], calender calenderVW: FSCalendar?) -> NSMutableArray {
        let arrUnAvailibilityDates = NSMutableArray()
        let currentDate: Date? = calenderVW?.currentPage
        //get calender
        let gregorianCalendar = Calendar.init(identifier: .gregorian)
        // Start out by getting just the year, month and day components of the current date.
        var components: DateComponents? = nil
        if let aDate = currentDate {
            components = gregorianCalendar.dateComponents([.year, .month, .day, .weekday], from: aDate)
        }
        // Change the Day component to 1 (for the first day of the month), and zero out the time components.
        components?.day = 1
        components?.hour = 0
        components?.minute = 0
        components?.second = 0
        //get first day of current month
        var firstDateOfCurMonth: Date? = nil
        if let aComponents = components {
            firstDateOfCurMonth = gregorianCalendar.date(from: aComponents)
        }
        //create new component to get weekday of first date
        var newcomponents: DateComponents? = nil
        if let aMonth = firstDateOfCurMonth {
            newcomponents = gregorianCalendar.dateComponents([.year, .month, .day, .weekday], from: aMonth)
        }
        let firstDateWeekDay: Int? = newcomponents?.weekday
        //get last month date
        let curMonth: Int? = newcomponents?.month
        newcomponents?.month = (curMonth ?? 0) + 1
        var templastDateOfCurMonth: Date? = nil
        if let aNewcomponents = newcomponents {
            templastDateOfCurMonth = gregorianCalendar.date(from: aNewcomponents)?.addingTimeInterval(-1)
        }
        // One second before the start of next month
        var lastcomponents: DateComponents? = nil
        if let aMonth = templastDateOfCurMonth {
            lastcomponents = gregorianCalendar.dateComponents([.year, .month, .day, .weekday], from: aMonth)
        }
        lastcomponents?.hour = 0
        lastcomponents?.minute = 0
        lastcomponents?.second = 0
        var lastDateOfCurMonth: Date? = nil
        if let aLastcomponents = lastcomponents {
            lastDateOfCurMonth = gregorianCalendar.date(from: aLastcomponents)
        }
        var dayDifference = DateComponents()
        dayDifference.calendar = gregorianCalendar
        
        if arrWeekDay.count == 0 {
            
        } else if arrWeekDay.count == 1 {
            let wantedWeekDay = Int(arrWeekDay[0])
            var firstWeekDateOfCurMonth: Date? = nil
            if wantedWeekDay == firstDateWeekDay {
                firstWeekDateOfCurMonth = firstDateOfCurMonth
            } else {
                var day: Int = wantedWeekDay - firstDateWeekDay!
                if day < 0 {
                    day += 7
                }
                day += 1
                components?.day = day
                firstWeekDateOfCurMonth = gregorianCalendar.date(from: components!)
            }
            var weekOffset: Int = 0
            var nextDate: Date? = firstWeekDateOfCurMonth
            repeat {
                let strDT: String = getSmallFormatedDate(convertCalendarDate(toNormalDate: nextDate))!
                arrUnAvailibilityDates.add(strDT)
                weekOffset += 1
                dayDifference.weekOfYear = weekOffset
                var date: Date? = nil
                if let aMonth = firstWeekDateOfCurMonth {
                    date = gregorianCalendar.date(byAdding: dayDifference, to: aMonth)
                }
                nextDate = date
            } while nextDate?.compare(lastDateOfCurMonth!) == .orderedAscending || nextDate?.compare(lastDateOfCurMonth!) == .orderedSame
        }
        else {
            for i in 0..<arrWeekDay.count {
                let wantedWeekDay = Int(arrWeekDay[i])
                var firstWeekDateOfCurMonth: Date? = nil
                if wantedWeekDay == firstDateWeekDay {
                    firstWeekDateOfCurMonth = firstDateOfCurMonth
                } else {
                    var day: Int = wantedWeekDay - firstDateWeekDay!
                    if day < 0 {
                        day += 7
                    }
                    day += 1
                    components?.day = day
                    firstWeekDateOfCurMonth = gregorianCalendar.date(from: components!)
                }
                
                
                var weekOffset: Int = 0
                var nextDate: Date? = firstWeekDateOfCurMonth
                repeat {
                    let strDT = getSmallFormatedDate(convertCalendarDate(toNormalDate: nextDate))
                    arrUnAvailibilityDates.add(strDT!)
                    weekOffset += 1
                    dayDifference.weekOfYear = weekOffset
                    var date: Date? = nil
                    if let aMonth = firstWeekDateOfCurMonth {
                        date = gregorianCalendar.date(byAdding: dayDifference, to: aMonth)
                    }
                    nextDate = date
                } while nextDate?.compare(lastDateOfCurMonth!) == .orderedAscending || nextDate?.compare(lastDateOfCurMonth!) == .orderedSame
            }
        }
        return arrUnAvailibilityDates
    }
    
    
    func getSmallFormatedDate(_ localDate: Date?) -> String? {
        let dateFormatter = DateFormatter()
        let timeZone = NSTimeZone(name: "UTC")
        if let aZone = timeZone {
            dateFormatter.timeZone = aZone as TimeZone
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString: String? = nil
        if let aDate = localDate {
            dateString = dateFormatter.string(from: aDate)
        }
        return dateString
    }
    
    func convertCalendarDate(toNormalDate selectedDate: Date?) -> Date? {
        let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
        let destinationTimeZone = NSTimeZone.system as NSTimeZone
        var sourceGMTOffset: Int? = nil
        if let aDate = selectedDate {
            sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: aDate)
        }
        var destinationGMTOffset: Int? = nil
        if let aDate = selectedDate {
            destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: aDate)
        }
        let interval1 = TimeInterval((destinationGMTOffset ?? 0) - (sourceGMTOffset ?? 0))
        var localDate: Date? = nil
        if let aDate = selectedDate {
            localDate = Date(timeInterval: interval1, since: aDate)
        }
        return localDate
    }
    
//    var arrImages = NSMutableArray()
//    var dictDoctor = NSDictionary()
//    var immediate = ""
//    var strDate = ""
//    var strTime = ""
    
//    func getPrevClassValue() {
//
//        let arr = self.navigationController?.viewControllers
//
//        if arr != nil {
//            for vc in arr! {
//                if isImmediate {
//                    if vc is DoctorDetails {
//                        let vcc = vc as! DoctorDetails
//                        dictDoctor = vcc.dictDetails
//                        immediate = "yes"
//                    }
//                } else {
//                    if vc is AppointmentVC {
//                        let vcc = vc as! AppointmentVC
//                        dictDoctor = vcc.dictDoctor
//                        strDate = vcc.tfDate.text!
//                        strTime = vcc.tfTime.text!
//                        arrImages = vcc.arrList
//                        immediate = "no"
//                    }
//                }
//            }
//        }
//    }
    
    func wsSendRequest() {
        
        let params = NSMutableDictionary()
        params["user_id"] = kAppDelegate.userId
        params["doctor_id"] = string(dictDoctor, "id")
        params["date"] = tfDate.text!
        params["time"] = tfTime.text!
        
        if isImmediate {
            params["immediate"] = "yes"
        } else {
            params["immediate"] = "no"
        }
        
        let images = NSMutableArray()
        
        for i in 0..<arrList.count {
            if let img = arrList.object(at: i) as? UIImage {
                let dict = NSMutableDictionary()
                dict["name"] = "img"
                dict["image"] = img
                images.add(dict)
            }
        }
        
        Http.instance().json(api_seduling, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                Http.alert("", AlertMsg.bookedAppoimt, [self, "Ok"])
            } else {
                Http.alert(appName, string(responce, "result"))
            }
        }
    }
    
    override func alertZero() {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    //MARK:API
    func wsGetSchedulingDate() {
        
        let params = NSMutableDictionary()
        params["doctor_id"] = string(dictDoctor, "id")
        let images = NSMutableArray()
        Http.instance().json(get_schedule_status, params, true, nil, self.view, images) { (responce) in
            if number(responce, "status").boolValue {
                if let result = responce.object(forKey: "result") as? NSArray {
                    self.arrDates = result.map({($0 as! NSDictionary).value(forKey: "close_date")}) as NSArray
                    print(self.arrDates)
                    
//                    if let book = responce.object(forKey: "booked") as? [String] {
//                        self.arrBookedTime = book
//                    }
                }
            } else {
                self.arrDates  = []
            }
        }
    }
    func wsGetScheduling(_ strDate: String) {

        let params = NSMutableDictionary()
        params["doctor_id"] = string(dictDoctor, "id")
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
                    self.cvDays.reloadData()
                }
            } else {
                self.arrScheduled  = []
//                Http.alert(appName, string(responce, "result"))
            }

//            self.createArray()
        }
    }
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

    func wsApplyPromoCode() {
        //http://24hdr.com/doctors/webservice/apply_coupon?promo_code=24dr&amount=500
        let params = NSMutableDictionary()
        params["promo_code"] = text_Promo.text!
        params["amount"] = strAmount!
      
        Http.instance().json(apply_coupon, params, true, nil, self.view) { (responce) in
            if number(responce, "status").boolValue {
                    self.lbl_TAmount.text = string(responce, "after_discount")
                    self.lbl_Discount.text = string(responce, "discount")
                    self.view_Disocu.isHidden = false
                    self.view_Total.isHidden = false
                    self.trans_View.isHidden = true
            }
        }
    }
    
    
    func createArray() {
//        arrTimes.removeAllObjects()
//        for strTime1 in arrDays {
//            var isAdded = false
//
//            for strTime2 in arrScheduled {
//                if strTime1 == strTime2 {
//                    isAdded = true
//                }
//            }
//
//            if !isAdded {
//                arrTimes.add(["time": strTime1, "schedule": "0", "select": "0"])
//            } else {
//                arrTimes.add(["time": strTime1, "schedule": "1", "select": "0"])
//            }
//        }
//        self.cvDays.reloadData()
    }
    
    var dictDoctor = NSDictionary()
    
    func getPrevClassValue() {
        let arr = self.navigationController?.viewControllers
        
        if arr != nil {
            for vc in arr! {
                if vc is DoctorDetails {
                    let vcc = vc as! DoctorDetails
                    self.dictDoctor = vcc.dictDetails
                }
            }
        }
    }
    
    
}//Class End





class ImagesCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg: View!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    
    @IBAction func actionCamera(_ sender: Any) {
    }
    
    @IBAction func actionCross(_ sender: Any) {
    }
}


class TimeCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTime: UILabel!
 //   @IBOutlet weak var vwBG: UIView!
    
}
extension AppointmentVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate2 = formatter.string(from: date)
        tfDate.text = strDate2
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate = formatter.string(from: date)
        tfTime.text = ""
        wsGetScheduling(strDate)
        vwCalenderPopUp.removeFromSuperview()
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
    
    func convertNextDate(dateString : String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        let myDate = dateFormatter.date(from: dateString)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        let somedateString = dateFormatter.string(from: tomorrow!)
        print("your next Date is \(somedateString)")
    }

    
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
