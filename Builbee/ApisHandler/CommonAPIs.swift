//
//  CommonAPIs.swift
//  Builbee
//
//  Created by Abdullah on 12/10/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import Alamofire

class CommonAPIs {
    
    private static var sharedCommonAPIs: CommonAPIs = {
        let networkManager = CommonAPIs()
        return networkManager
    }()
    
    private init(){
    }
    
    class func shared() -> CommonAPIs {
        return sharedCommonAPIs
    }
    
    //api use for post create project create and update the project and post
    
    func uploadImage(apiUrl: String, parameters: [String: Any], token: String,imagesData: [UIImage], imageKey: String, onSuccess success: @escaping (_ response: DeleteProjectResponse ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for imageData in imagesData {
                let imgData = imageData.jpegData(compressionQuality: 0.4)!
                multipartFormData.append(imgData, withName: imageKey, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                print(multipartFormData)
            }
            print(multipartFormData,parameters)
            
            for (key, value) in parameters {
                print(key,value, type(of: value))
              
                if key == "area_of_exp_id[]" || key == "img_to_delete[]" {
                    
                    let paramsData:Data = NSKeyedArchiver.archivedData(withRootObject: value)
                    multipartFormData.append(paramsData, withName: key)

                } else {
                    print((value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any)
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            }
            
            print(parameters)
            
        }, to: apiUrl, headers: headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            
            case .success(let upload, _, _):
                
                upload.responseObject{(response:DataResponse<DeleteProjectResponse>)  in
                    
                    switch response.result {
                    case .success(let value):
                        success(value)
                    case .failure(let error):
                        failure(error)
                    }
                }
            case .failure(let error):
                print("successfully error",error)
                failure(error)
            }

        })
        
    }
    
    
}
