//
//  Constants.swift
//  Builbee
//
//  Created by Abdullah on 11/20/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation


internal struct AlertConstants {
    
    static let Error = "Error!"
    static let Alert = "Alert!"
    static let DeviceType = "ios"
    static let Ok = "ok"
    static let EmailNotValid = "Email is not valid"
    static let PhoneNotValid = "Phone number is not valid"
    static let EmailEmpty = "Email is empty"
    static let PhoneEmpty = "Phone number is empty"
    static let FirstNameEmpty = "First name is empty"
    static let LastNameEmpty = "Last name is empty"
    static let NameEmpty = "Last name is empty"
    static let Empty = " is empty"
    static let PasswordsMisMatch = "Make sure your passwords match"
    static let LoginSuccess = "Login successful"
    static let SignUpSuccess = "Signup successful"
    static let PasswordInvalid = "Password is not valid"
    static let PasswordEmpty = "Password is empty"
    static let PasswordNotMatch = "Password not match"
    static let Success = "Success"
    static let InternetNotReachable = "Your phone does not appear to be connected to the internet. Please connect and try again"
    static let UserNameEmpty = "Username is empty"
    static let TermsAndCondition = "Terms and conditions have not been accepted"
    static let AllFieldNotFilled = "Make sure all fields are filled"
    static let SomeThingWrong = "Some thing want wrong"
    static let SelectFromDropDown = "Please select value from Dropdown"
    
}

internal struct APIUrl {
    static let baseUrl = "http://builbee.twaintec.com"
    static let login = baseUrl + "/api/login"
    static let signUp = baseUrl + "/api/signup"
    static let logout = baseUrl + "/api/logout"
    static let updateProfile = baseUrl + "/api/updateuser"
    static let resetPassword = baseUrl + "/api/resetpassword"
    static let areaOfInterest = baseUrl + "/api/all_area_of_experience"
    static let specificAreaOfInterest = baseUrl + "/api/all_area_of_experience"
    
    static let getNearPeople = baseUrl + "/api/people"
    static let project = baseUrl + "/api/project"
    static let updateProject = baseUrl + "/api/updateproject"
    static let post = baseUrl + "/api/post"
    static let allPost = baseUrl + "/api/all_post"
    
    static let reportUser = baseUrl + "/api/reportuser"
    static let reportPost = baseUrl + "/api/reportpost"
    static let reportProject = baseUrl + "/api/reportproject"
    
    static let generalSearch = baseUrl + "/api/search"
    static let viewCounter = baseUrl + "/api/hitContractor"
    static let viewCounterForPost = baseUrl + "/api/hitpost"
    static let reportTypes = baseUrl + "/api/report_types"
}

enum Storyboards {
    case Main
    var id: String {
        return String(describing: self)
    }
}
