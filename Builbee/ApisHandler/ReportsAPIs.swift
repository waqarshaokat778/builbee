//
//  ReportsAPIs.swift
//  Builbee
//
//  Created by Abdullah on 12/28/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import Alamofire

class ReportsAPIs {
   
    private static var sharedReportsAPIs: ReportsAPIs = {
        let networkManager = ReportsAPIs()
        return networkManager
    }()
    
    private init(){
    }
    
    class func shared() -> ReportsAPIs {
        return sharedReportsAPIs
    }
    
    func get(url: String, params: [String: Any], token: String, onSuccess success: @escaping (_ response: DeleteProjectResponse? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
            print(token,params)
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<DeleteProjectResponse>) in
            print(response)
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
    
    }
    
    func getTypes( token: String, onSuccess success: @escaping (_ response: ReportTypeModal? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(APIUrl.reportTypes, method: .get, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<ReportTypeModal>) in
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
