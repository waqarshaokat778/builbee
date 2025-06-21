//
//  PojectModal.swift
//  Builbee
//
//  Created by Abdullah on 11/27/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import ObjectMapper


class SearchResultModal : Mappable {

    var agentLsit: [AgentList]?
    var contractors: [ContractorsList]?
    var projects: [ProjectData]?
    var posts: [PostData]?
    var status: Bool?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        agentLsit <- map["agents"]
        contractors <- map["contractors"]
        projects <- map ["projects"]
        posts <- map ["posts"]
        status <- map ["status"]
    }

}

class ProjectList: Mappable {
    
    var id :Int?
    var project_name: String?
    var project_detail: String?
    var location: String?
    var project_images: [String]?
    var added_date: String?
    var views: String?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map ) {
        id <- map["id"]
        project_name <- map["project_name"]
        project_detail <- map ["project_detail"]
        location <- map["location"]
        project_images <- map["project_images"]
        added_date <- map ["added_date"]
        views <- map["views"]
    }
}

//
//class PostOwnerData : Mappable {
//
//    var id :Int?
//    var name: String?
//    var email: String?
//    var phone_number: String?
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        id <- map["id"]
//        name <- map["name"]
//        email <- map ["email"]
//        phone_number <- map ["phone_number"]
//    }
//
//}



class DeleteProjectResponse : Mappable {
    
    var message : String?
    var status : Bool?
    var error: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        error <- map ["error"]
    }
    
}


class GetProjectResponse : Mappable {
    
    var data : [ProjectData]?
    var status : Bool?
    var error: String?
    var total_project: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
        error <- map ["error"]
        total_project <- map ["total_project"]
    }
    
}


class ProjectData : Mappable {
    
    var id :Int?
    var project_name: String?
    var project_detail: String?
    var location: String?
    var project_images: [String]?
    var added_date: String?
    var views: String?
    var user_type: String?
    var status : Bool?
    var error: String?
    var area_of_exp: [AreaOfInterestDataModal]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        project_name <- map["project_name"]
        project_detail <- map ["project_detail"]
        location <- map["location"]
        project_images <- map["project_images"]
        added_date <- map ["added_date"]
        views <- map["views"]
        user_type <- map["user_type"]
        status <- map["status"]
        error <- map ["error"]
        area_of_exp <- map ["area_of_exp"]
        
    }
    
}
