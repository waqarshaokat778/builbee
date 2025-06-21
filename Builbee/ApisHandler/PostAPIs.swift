//
//  PostAPIs.swift
//  Builbee
//
//  Created by Abdullah on 12/10/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import Alamofire

class PostAPIs {
    
    private static var sharedPostAPIs: PostAPIs = {
        let networkManager = PostAPIs()
        return networkManager
    }()
    
    private init(){
    }
    
    class func shared() -> PostAPIs {
        return sharedPostAPIs
    }
    
    func get(url: String, token: String, onSuccess success: @escaping (_ response: GetCustomerPostResponse? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<GetCustomerPostResponse>) in
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

