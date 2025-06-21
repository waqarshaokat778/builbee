//
//  ProfilesHandlerApis.swift
//  Builbee
//
//  Created by Abdullah on 11/20/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import ObjectMapper
import AlamofireObjectMapper

class ProfilesHandlerApis {
    
    private static var sharedProfilesHandlerApis: ProfilesHandlerApis = {
        let networkManager = ProfilesHandlerApis()
        return networkManager
    }()
    
    private init(){
    }
    
    class func shared() -> ProfilesHandlerApis {
        return sharedProfilesHandlerApis
    }
    
    func logIn(params: [String: Any],onSuccess success: @escaping (_ response: SignInUser? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        Alamofire.request(APIUrl.login, method: .post, parameters: params, encoding: URLEncoding.default).responseObject{(response:DataResponse<SignInUser>) in
           
            switch response.result {
            case .success(let value):
                if value.status ?? false {
                    self.setDataIntoUserDefault(value: value)
                }
                success(value)
            case .failure(let error):
                failure(error)
            }
            
        }
        
    }
    
    func signUp(params: [String: Any],onSuccess success: @escaping (_ response: SignUpCustomer? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        Alamofire.request(APIUrl.signUp, method: .post, parameters: params, encoding: URLEncoding.default).responseObject{(response:DataResponse<SignUpCustomer>) in
            switch response.result {
            case .success(let value):
//                print(value.data?.user_id,value.data, value)
//                let dict = ["token": value.data?.token ?? "", "latitude": value.data?.latitude ?? "", "longitude": value.data?.longitude ?? "","user_type": value.data?.user_type, "profile_img_url": ""]
//                UserDefaults.standard.set(dict, forKey: "ProfileModal")
                success(value)
                
            case .failure(let error):
                failure(error)
            }
        }
        
    }
    
    func logout(token: String,onSuccess success: @escaping (_ response: LogoutUser? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(APIUrl.logout, method: .get, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<LogoutUser>) in
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
        
    }
    
    
    func sendCodeForRestPassword(params: [String:Any] ,onSuccess success: @escaping (_ response: SendCodeResetPassword? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        Alamofire.request(APIUrl.resetPassword, method: .get, parameters: params, encoding: URLEncoding.default).responseObject{(response:DataResponse<SendCodeResetPassword>) in
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
        
    }
   
    func setNewPassword(params: [String:Any] ,onSuccess success: @escaping (_ response: SetNewPasswordModal? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        Alamofire.request(APIUrl.resetPassword, method: .get, parameters: params, encoding: URLEncoding.default).responseObject{(response:DataResponse<SetNewPasswordModal>) in
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
        
    }
        
    func updateProfile(parameters: [String: Any], token: String, onSuccess success: @escaping (_ response: UpdateProfileResponse? ) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(APIUrl.updateProfile, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseObject{(response:DataResponse<UpdateProfileResponse>) in
            
            switch response.result {
            case .success(let value):
                if value.status ?? false {
                    self.updateUserDefault(value: value)
                }
                success(value)
            case .failure(let error):
                failure(error)
            }
            
        }
        
    }
    
    func setDataIntoUserDefault(value : SignInUser) {
        
        var dict: [String: Any] = ["id": String(value.data?.user_id ?? -1),
                     "email": value.data?.email ?? "",
                     "name": value.data?.name ?? "",
                     "token": value.data?.token ?? "",
                     "latitude": value.data?.latitude ?? "",
                     "longitude": value.data?.longitude ?? "",
                     "user_type": value.data?.user_type ?? "unknow",
                     "profile_img_url": value.data?.profile_img_url as Any,
                     "location": value.data?.location as Any,
                     "phone_number": value.data?.phone_number as Any]
        
        if value.data?.user_type != "customer" {
            dict["company_name"] = value.data?.company_name
            dict["lisence_number"] = value.data?.lisence_number
            dict["experience"] = value.data?.experience
            dict["website"] = value.data?.website
            dict["availability_start"] = value.data?.availability_start ?? ""
            dict["availability_end"] = value.data?.availability_end ?? ""
            
            
            dict["facebook"] = value.data?.facebook  ?? ""
            dict["twitter"] = value.data?.twitter  ?? ""
            dict["instagram"] = value.data?.instagram  ?? ""
            dict["linkedin"] = value.data?.linkedin  ?? ""
            dict["bio"] = value.data?.bio  ?? ""
            dict["availability"] = value.data?.availability ?? false
            
//            let controller = BaseClass()
//            let experience = (value.data?.area_of_exp)!
//
//            let saveIntoUserdefaults: () = controller.saveUserObject(experience)
            dict[Constants.areaOfExperience] = value.data?.area_of_exp?.count ?? 0
//            print( value.data?.area_of_exp ?? "","\n\n", encodedData)
        }
        UserDefaults.standard.set(dict, forKey: "ProfileModal")
    }
    
    func updateUserDefault(value: UpdateProfileResponse) {
        var userDefaultForUserProfile  = UserDefaults.standard.dictionary(forKey: "ProfileModal")
        userDefaultForUserProfile?["id"] = String(value.data?.user_id ?? -1)
        userDefaultForUserProfile?["email"] = value.data?.email ?? ""
        userDefaultForUserProfile?["name"] =  value.data?.name ?? ""
        userDefaultForUserProfile?["latitude"] = value.data?.latitude ?? ""
        userDefaultForUserProfile?["longitude"] = value.data?.longitude ?? ""
        userDefaultForUserProfile?["user_type"] = value.data?.user_type
        userDefaultForUserProfile?["profile_img_url"] = value.data?.profile_img_url
        userDefaultForUserProfile?["location"] = value.data?.location
        userDefaultForUserProfile?["phone_number"] = value.data?.phone_number
        
        if value.data?.user_type != "customer" {
            userDefaultForUserProfile?["company_name"] = value.data?.company_name
            userDefaultForUserProfile?["lisence_number"] = value.data?.lisence_number
            userDefaultForUserProfile?["experience"] = value.data?.experience
            userDefaultForUserProfile?["website"] = value.data?.website
            userDefaultForUserProfile?["availability_start"] = value.data?.availability_start  ?? ""
            userDefaultForUserProfile?["availability_end"] = value.data?.availability_end  ?? ""
            
            userDefaultForUserProfile?["facebook"] = value.data?.facebook  ?? ""
            userDefaultForUserProfile?["twitter"] = value.data?.twitter  ?? ""
            userDefaultForUserProfile?["instagram"] = value.data?.instagram  ?? ""
            userDefaultForUserProfile?["linkedin"] = value.data?.linkedin  ?? ""
            userDefaultForUserProfile?["bio"] = value.data?.bio  ?? ""
            userDefaultForUserProfile?["availability"] = value.data?.availability  ?? false
           
//            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value.data?.area_of_exp ?? "")
            userDefaultForUserProfile?["area_of_exp"] = value.data?.area_of_exp?.count ?? 0
        }
        UserDefaults.standard.set(userDefaultForUserProfile, forKey: "ProfileModal")
    }
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
}

