//
//  Models.swift
//  Builbee
//
//  Created by Khawar Khan on 23/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


class SignUpCustomer : Mappable {
    
    var data : customerData?
    var status : Bool?
    var message : String?
    var error : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
        error <- map["error"]
        
    }}

class customerData : Mappable{
    
    var user_id : String?
    var token : String?
    var name : String?
    var email : String?
    var location : String?
    var phone_number : String?
    var longitude : String?
    var latitude : String?
    var profile_img_url : String?
    var user_type : String?
    var device_token : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map ["user_id"]
        token <- map["token"]
        name <- map ["name"]
        email <- map ["email"]
        location <- map ["location"]
        phone_number <- map["phone_number"]
        longitude <- map ["longitude"]
        latitude <- map ["latitude"]
        profile_img_url <- map ["profile_img_url"]
        user_type <- map["user_type"]
        device_token <- map ["device_token"]
        
    }}


class SignInUser : Mappable {
    
    var data : userData?
    var status : Bool?
    var message : String?
    var messagesd : String?
    var error: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
        error <- map["error"]
    }}

class userData : Mappable{
    var user_id : Int?
    var token : String?
    var name : String?
    var email : String?
    var location : String?
    var phone_number : String?
    var longitude : String?
    var latitude : String?
    var profile_img_url : String?
    var user_type : String?
    var device_token : String?
    var company_name : String?
    var lisence_number : String?
    var experience : String?
    var website : String?
    var availability_start : String?
    var availability_end : String?
    var availability : String?
    
    var facebook  : String?
    var twitter : String?
    var instagram : String?
    var linkedin : String?
    var bio : String?
    var area_of_exp: [AreaOfInterestDataModal]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        user_id <- map ["user_id"]
        token <- map["token"]
        name <- map ["name"]
        email <- map ["email"]
        location <- map ["location"]
        phone_number <- map["phone_number"]
        longitude <- map ["longitude"]
        latitude <- map ["latitude"]
        profile_img_url <- map ["profile_img_url"]
        user_type <- map["user_type"]
        device_token <- map ["device_token"]
        company_name <- map ["company_name"]
        lisence_number <- map ["lisence_number"]
        experience <- map["experience"]
        website <- map ["website"]
        availability_start <- map ["availability_start"]
        availability_end <- map ["availability_end"]
        availability <- map ["availability"]

        facebook <- map ["facebook"]
        twitter <- map ["twitter"]
        instagram <- map ["instagram"]
        linkedin <- map ["linkedin"]
        bio <- map ["bio"]
        area_of_exp <- map ["area_of_exp"]
        
    }
}

//Logout User


class LogoutUser : Mappable{
    
    var status : Bool?
    var message : String?
    var error : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        error <- map["error"]
    }
}


// sending code on email api response
class SendCodeResetPassword: Mappable{
    
    var status : Bool?
    var message : String?
    var error : String?
    var token: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        error <- map["error"]
        token <- map["token"]
    }
}
// new password api response
class SetNewPasswordModal: Mappable{
    
    var status : Bool?
    var message : String?
    var error : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        error <- map["error"]
    }
}


class UpdateProfileResponse : Mappable {
    
    var data : profileDataResponse?
    var status : Bool?
    var message : String?
//    var error: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
//        error <- map["error"]
    }}

class profileDataResponse : Mappable{
    var user_id : Int?
//    var token : String?
    var name : String?
    var email : String?
    var location : String?
    var phone_number : String?
    var longitude : String?
    var latitude : String?
    var profile_img_url : String?
    var user_type : String?
    var device_token : String?
    var company_name : String?
    var lisence_number : String?
    var experience : String?
    var website : String?
    var availability_start : String?
    var availability_end : String?
    
    var facebook  : String?
    var twitter : String?
    var instagram : String?
    var linkedin : String?
    var bio : String?
    var availability : Bool?
    var area_of_exp: [AreaOfInterestDataModal]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map ["user_id"]
//        token <- map["token"]
        name <- map ["name"]
        email <- map ["email"]
        location <- map ["location"]
        phone_number <- map["phone_number"]
        longitude <- map ["longitude"]
        latitude <- map ["latitude"]
        profile_img_url <- map ["profile_img_url"]
        user_type <- map["user_type"]
        device_token <- map ["device_token"]
        company_name <- map ["company_name"]
        lisence_number <- map ["lisence_number"]
        experience <- map["experience"]
        website <- map ["website"]
        availability_start <- map ["availability_start"]
        availability_end <- map ["availability_end"]
        
        facebook <- map ["facebook"]
        twitter <- map ["twitter"]
        instagram <- map ["instagram"]
        linkedin <- map ["linkedin"]
        bio <- map ["bio"]
        availability <- map ["availability"]
        area_of_exp <- map ["area_of_exp"]
    }
}


