//
//  NetWorkCalls.swift
//  Builbee
//
//  Created by Abdullah on 1/1/21.
//  Copyright © 2021 KK. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import ObjectMapper
import AlamofireObjectMapper

class NetWorkCalls {
    
    private static var sharedNetWorkCalls: NetWorkCalls = {
        let networkManager = NetWorkCalls()
        return networkManager
    }()
    
    private init(){
    }
    
    class func shared() -> NetWorkCalls {
        return sharedNetWorkCalls
    }
    
    func getSearchResult(token: String, params: [String: Any],onSuccess success: @escaping (_ response: SearchResultModal? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(APIUrl.generalSearch, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<SearchResultModal>) in
           
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
            
        }
        
    }
    
    
    func ViewCount(url: String, params: [String: Any],onSuccess success: @escaping (_ response: DeleteProjectResponse? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseObject{(response:DataResponse<DeleteProjectResponse>) in
           
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
            
        }
        
    }
    
}
