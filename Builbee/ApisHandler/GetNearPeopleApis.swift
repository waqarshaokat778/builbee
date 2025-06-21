//
//  GetNearPeople.swift
//  Builbee
//
//  Created by Abdullah on 11/26/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import ObjectMapper
import AlamofireObjectMapper

class GetNearPeopleApis {
    
    private static var sharedGetNearPeopleApis: GetNearPeopleApis = {
        let networkManager = GetNearPeopleApis()
        return networkManager
    }()
    
    private init(){
        
    }
    
    class func shared() -> GetNearPeopleApis {
        return sharedGetNearPeopleApis
    }
    
    func get(params: [String: Any], token: String, onSuccess success: @escaping (_ response: DealerAndAgentModal? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
            print(token,params)
        
        Alamofire.request(APIUrl.getNearPeople, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<DealerAndAgentModal>) in
            print(response)
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
    
    }

}


