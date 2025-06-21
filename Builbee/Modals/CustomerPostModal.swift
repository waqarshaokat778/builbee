//
//  CustomerPostModal.swift
//  Builbee
//
//  Created by Abdullah on 12/10/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import ObjectMapper

class GetCustomerPostResponse : Mappable {
    
    var data : [PostData]?
    var status : Bool?
    var error: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
        error <- map ["error"]
    }
    
}


class PostData : Mappable {
    
    var id :Int?
    var title: String?
    var body: String?
    var location: String?
    var views: String?
    var post_images: [String]?
    var added_date: String?
    var created_by: PostOwnerData?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        body <- map ["body"]
        location <- map ["location"]
        views <- map ["views"]
        post_images <- map["post_images"]
        added_date <- map ["added_date"]
        created_by <- map ["created_by"]
    }
    
}


class PostOwnerData : Mappable {
    
    var id :Int?
    var name: String?
    var email: String?
    var phone_number: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map ["email"]
        phone_number <- map ["phone_number"]
    }
    
}

