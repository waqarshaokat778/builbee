//
//  AreaOfInterestAPIs.swift
//  Builbee
//
//  Created by Abdullah on 12/8/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import Alamofire

class AreaOfInterestAPIs {
    
    private static var sharedProjectApis: AreaOfInterestAPIs = {
        let networkManager = AreaOfInterestAPIs()
        return networkManager
    }()
    
    private init(){
    }
    
    class func shared() -> AreaOfInterestAPIs {
        return sharedProjectApis
    }
    
    
    func getSepecificeList(token: String, onSuccess success: @escaping (_ response: AreaOfInterestModal? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
     
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
       Alamofire.request(APIUrl.areaOfInterest, method: .get, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<AreaOfInterestModal>) in
           
            switch response.result {
            
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
            
            }
        }
    }
    
    func get(onSuccess success: @escaping (_ response: AreaOfInterestModal? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
       Alamofire.request(APIUrl.areaOfInterest, method: .post, encoding: URLEncoding.default).responseObject{(response:DataResponse<AreaOfInterestModal>) in
           
            switch response.result {
            
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
            
            }
        }
    }
    
   
    
    func getUserList(token : String, onSuccess success: @escaping (_ response: AreaOfInterestModal? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
     
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(APIUrl.specificAreaOfInterest, method: .get,encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<AreaOfInterestModal>) in
           
            switch response.result {
            
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
            
            }
        }
    }
    

}
