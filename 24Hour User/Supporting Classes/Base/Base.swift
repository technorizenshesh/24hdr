//
//  Base.swift
//  Solviepro Hire
//
//  Created by mac on 28/05/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class Base: NSObject {
}

let appName = "24hour Doctor"

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate



let base_url = "http://24hdr.com/doctors/webservice/"

//let image_url = "http://24hdr.com/docters/uploads/images/"
let image_url = "http://24hdr.com/doctors/uploads/images/"

let change_password = "\(base_url)change_password"

let api_login = "\(base_url)login"

let api_signup = "\(base_url)signup"

let api_forgot_password = "\(base_url)forgot_password"

let api_update_profile = "\(base_url)update_profile"

let api_category_specialist = "\(base_url)category_specialist"

let api_specialist_docter = "\(base_url)specialist_docter_new"

let api_doctor_list = "\(base_url)doctor_list"

let affiliate_doctors = "\(base_url)affiliate_doctors"

let api_favorites_doctor = "\(base_url)favorites_doctor"

let api_favorites_list = "\(base_url)favorites_list"

let api_get_seduling = "\(base_url)get_seduling"

let api_seduling = "\(base_url)seduling"

let api_insert_chat = "\(base_url)insert_chat"

let api_get_chat = "\(base_url)get_chat"

let api_get_conversation = "\(base_url)get_conversation"

let api_get_profiles = "\(base_url)get_profiles"

let api_my_appointment = "\(base_url)my_appointment"

let api_offerlist = "\(base_url)offerlist"

let apply_coupon = "\(base_url)apply_coupon"

let get_comment = "\(base_url)get_comment"

let add_comment = "\(base_url)add_comment"

let add_fav_promotion = "\(base_url)add_fav_promotion"

let get_bookmark = "\(base_url)get_promotion_fav"

let delete_cart_item25 = "\(base_url)delete_cart_item"

let get_schedule_close = "\(base_url)get_schedule_close?"

let get_banner_image = "\(base_url)get_banner_image?"

let add_book_mark = "\(base_url)add_book_mark"

let like_doctor = "\(base_url)like_doctor"

let get_like_unlike_status = "\(base_url)get_like_unlike_status"

let add_comment_Review = "\(base_url)add_comment"

let get_schedule_status = "\(base_url)get_schedule_status?"

let delete_schedule = "\(base_url)delete_schedule?"

let re_seduling = "\(base_url)re_seduling?"


//



/********************************AlertMessage*******************************/

class AlertMsg: NSObject {
    
    static let oldpass = "Please enter old password."
    static let newPas = "Please enter new password."
    static let Confirm = "Please enter confirm password."

    static let blankEmail = "Please enter email address."
    static let invalidEmail = "Please enter valid email address."
    static let blankPass = "Please enter password."
    static let passLen = "Password must be at least 6 characters long."
    static let blankConfPass = "Please enter confirm password."
    static let passMissMatch = "The password and confirmation password do not match."

    static let blankFirstName = "Please enter first name."
    static let blankLastName = "Please enter last name."
    static let blankNumber = "Please enter mobile number."
    static let numberLen = "Number must be at least 6 characters long."
    static let blankAddress = "Please select your loation."
    static let blankQuestion = "Please select secure question."
    static let blankAnswer = "Please enter secure answer."
    static let blankDescription = "Please enter description."
    static let selectGender = "Please select gender."
    static let blankDob = "Please enter date of birth."
    static let selectDate = "Please select date."
    static let sDoctorNotAviable = "Doctor not available on this date"

    static let blankCardNumber = "Please enter card number."
    static let blankExpiry = "Please enter expiry date."
    static let blankCvv = "Please enter CVV."
    static let selectBookDate = "Please select booking appointment date."
    static let selectBookTime = "Please select booking appointment time."
    static let bookedAppoimt = "Your appointment has booked successfully."
    static let blankMsg = "Please type a message."

    


    
    static let strAlert = "Alert"
    static let logoutMsg = "Are you want to logout?"
    static let forgotMsg = "Please check your email for your new password it may be in your spam folder."
    static let profileUpdate = "Profile updated successfully."

}

