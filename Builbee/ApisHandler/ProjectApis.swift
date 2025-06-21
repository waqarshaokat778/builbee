//
//  ProjectApis.swift
//  Builbee
//
//  Created by Abdullah on 11/27/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import Alamofire

class ProjectApis {
    
    private static var sharedProjectApis: ProjectApis = {
        let networkManager = ProjectApis()
        return networkManager
    }()
    
    private init(){
        
    }
    
    class func shared() -> ProjectApis {
        return sharedProjectApis
    }
    
    func delete(url : String, token: String, onSuccess success: @escaping (_ response: DeleteProjectResponse? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("url for delete: ", url)
        Alamofire.request(url, method: .delete, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<DeleteProjectResponse>) in
            print("Response result : ",response)
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
    
    }
 
    func get(apiURL: String, params: [String: Any], token: String, onSuccess success: @escaping (_ response: GetProjectResponse? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(apiURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<GetProjectResponse>) in
            print(response)
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
    
    }
    
    
    func create(params: [String: Any], token: String, onSuccess success: @escaping (_ response: DeleteProjectResponse? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(APIUrl.project, method: .delete, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<DeleteProjectResponse>) in
            print(response)
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
    
    }
    
    func update(params: [String: Any], token: String, onSuccess success: @escaping (_ response: DeleteProjectResponse? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(APIUrl.project, method: .delete, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<DeleteProjectResponse>) in
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
