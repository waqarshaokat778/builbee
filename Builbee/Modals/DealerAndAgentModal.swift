//
//  DealerAndAgentModal.swift
//  Builbee
//
//  Created by Abdullah on 11/26/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


class DealerAndAgentModal : Mappable {
    
    var agents : [AgentList]?
    var contractors : [ContractorsList]?
    var status : Bool?
    var error: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        agents <- map["agents"]
        contractors <- map["contractors"]
        status <- map["status"]
        error <- map ["error"]
    }
    
}

class AgentList : Mappable{
    
    var id : Int?
    var name : String?
    var email : String?
    var phone_number : String?
    var location : String?
    var longitude : String?
    var latitude : String?
    var profile_img_url : String?
    var user_type : String?
    var facebook  : String?
    var twitter : String?
    var instagram : String?
    var linkedin : String?
    var bio : String?
    var distance : String?
    var agent : DataList?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map ["id"]
        name <- map["name"]
        email <- map ["email"]
        phone_number <- map ["phone_number"]
        location <- map ["location"]
        longitude <- map["longitude"]
        latitude <- map ["latitude"]
        profile_img_url <- map ["profile_img_url"]
        user_type <- map ["user_type"]
        facebook <- map ["facebook"]
        twitter <- map ["twitter"]
        instagram <- map ["instagram"]
        linkedin <- map ["linkedin"]
        bio <- map ["bio"]
        distance <- map["distance"]
        agent <- map ["agent"]
        
        
    }
    
}

class ContractorsList : Mappable{
    
    var id : Int?
    var name : String?
    var email : String?
    var phone_number : String?
    var location : String?
    var longitude : String?
    var latitude : String?
    var profile_img_url : String?
    var user_type : String?
    
    var facebook  : String?
    var twitter : String?
    var instagram : String?
    var linkedin : String?
    var bio : String?
    
    var distance : String?
    var contractor : DataList?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map ["id"]
        name <- map["name"]
        email <- map ["email"]
        phone_number <- map ["phone_number"]
        location <- map ["location"]
        longitude <- map["longitude"]
        latitude <- map ["latitude"]
        profile_img_url <- map ["profile_img_url"]
        user_type <- map ["user_type"]
        
        facebook <- map ["facebook"]
        twitter <- map ["twitter"]
        instagram <- map ["instagram"]
        linkedin <- map ["linkedin"]
        bio <- map ["bio"]
        
        distance <- map["distance"]
        contractor <- map ["contractor"]
        
    }
    
}

class DataList : Mappable{
    
    var user_id : String?
    var company_name : String?
    var lisence_number : String?
    var experience : String?
    var website : String?
    
    var availability_start : String?
    var availability_end : String?
    var availability : Bool?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        user_id <- map ["user_id"]
        company_name <- map["company_name"]
        lisence_number <- map ["lisence_number"]
        experience <- map ["experience"]
        website <- map ["website"]
        
        availability_start <- map ["availability_start"]
        availability_end <- map ["availability_end"]
        availability <- map ["availability"]
    }
    
}
