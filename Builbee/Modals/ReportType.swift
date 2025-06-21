//
//  ReportType.swift
//  Builbee
//
//  Created by Abdullah on 1/5/21.
//  Copyright © 2021 KK. All rights reserved.
//

import Foundation
import ObjectMapper

class ReportTypeModal : Mappable {
    
    var project_report_types : [ReportTypeList]?
    var post_report_types : [ReportTypeList]?
    var user_report_types : [ReportTypeList]?
    var status : Bool?
    var error: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        project_report_types <- map["project_report_types"]
        post_report_types <- map["post_report_types"]
        user_report_types <- map["user_report_types"]
        status <- map["status"]
        error <- map ["error"]
    }
    
}

class ReportTypeList : Mappable {
    
    var id : Int?
    var name : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}

