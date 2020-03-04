//
//  ViewControllerExt.swift
//  WeCare
//
//  Created by mac on 29/09/18.
//  Copyright © 2018 Technorizen. All rights reserved.
//

import UIKit

extension UIViewController {
   
    func getStringSize(string: String, fontSize: CGFloat) -> CGSize {
        let size: CGSize = string.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])
        return size
    }
    
    func datePickerTapped(strFormat:String,mode:UIDatePicker.Mode, completionBlock complete: @escaping (_ dateString: String) -> Void) {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        var dateString:String = ""
        // let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        let datePicker = DatePickerDialog(textColor: .darkGray,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        datePicker.show("DATE",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: currentDate,
                        maximumDate: nil,
                        datePickerMode: mode) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = strFormat
                                if mode == .date {
                                    dateString = formatter.string(from: dt)
                                } else {
                                    dateString = formatter.string(from: dt)
                                }
                                complete(dateString)
                            }
        }
    }
}
