//
//  AreaOfInterestModal.swift
//  Builbee
//
//  Created by Abdullah on 12/8/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import ObjectMapper

class AreaOfInterestModal : Mappable{
    
    var data : [AreaOfInterestDataModal]?
    var status : Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map ["status"]
    }
    
}

class AreaOfInterestDataModal : Mappable{
    
    var id : Int?
    var name : String?
    var selectedArea: Bool
    var selected: Bool?
    
    required init?(map: Map) {
        self.selectedArea = false
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map ["name"]
        selectedArea <- map ["selectedArea"]
        selected <- map ["selected"]
    }
    
}


