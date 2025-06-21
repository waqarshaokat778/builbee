//
//  SignUpViewController.swift
//  Builbee
//
//  Created by Khawar Khan on 12/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import RYFloatingInput
import iOSDropDown
import NVActivityIndicatorView

protocol getLoacitonDelegate {
    func getLoaction(address: String, lat: String, lng: String)
}

protocol selectedAreaOfInterestDelegate {
    func selectedListAreaOfInterest(list: [Int])
}

class SignUpViewController: BaseClass, getLoacitonDelegate, selectedAreaOfInterestDelegate, datePickerDelegate {
    
    func selectedListAreaOfInterest(list: [Int]) {
        areaOfInterestList = list
        selectedAreaCount.isHidden = true
        trailingAreOfInterest.constant = 12
        if list.count > 0 {
            selectedAreaCount.isHidden = false
            trailingAreOfInterest.constant = 44
            selectedAreaCount.text = "\(list.count)"
        }
        
    }    
    
    func getLoaction(address: String, lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
        addresslbl.text = address
    }
    
    @IBOutlet weak var fullNameField: RYFloatingInput!
    @IBOutlet weak var emailField: RYFloatingInput!
    @IBOutlet weak var phoneNumberField: RYFloatingInput!
    @IBOutlet weak var addressField: UIView!
    @IBOutlet weak var userTypeDropDown: DropDown!
    @IBOutlet weak var userTyperOuterVu: UIView!
    @IBOutlet weak var passwordField: RYFloatingInput!
    @IBOutlet weak var confirmPasswordField: RYFloatingInput!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var companyNameField: RYFloatingInput!
    @IBOutlet weak var licenseNumberField: RYFloatingInput!
    
    @IBOutlet weak var experienceField: RYFloatingInput!
    @IBOutlet weak var websiteField: RYFloatingInput!
    @IBOutlet weak var contantContainer: UIView!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var areaOfInterest: UIView!
    @IBOutlet weak var selectedAreaCount: UILabel!
    @IBOutlet weak var availbility: UIView!
    @IBOutlet weak var availabilityField: DropDown!
    @IBOutlet weak var availableContainer: UIView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var startDateContainer: UIView!
    @IBOutlet weak var startDateField: UILabel!
    @IBOutlet weak var endDateContainer: UIView!
    @IBOutlet weak var endDateField: UILabel!

    @IBOutlet weak var trailingAreOfInterest: NSLayoutConstraint!
    
    var lat: String = ""
    var lng: String = ""
    var email: String = ""
    var userName: String = ""
    var isStart: Bool = true
    var isSendDate = false
    var areaOfInterestList: [Int] = []
    var loadingIndicator : NVActivityIndicatorView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
        setupUserTypedropdown()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedAreaCount.isHidden = true
        trailingAreOfInterest.constant = 12
    }
    
    func getData(_ date: String, _ isStart: Bool) {
        
        if (isStart) {
            self.startDateField.text = date
        } else {
            self.endDateField.text = date
        }
    }
    
    @IBAction func registerBtnTpd(_ sender: Any) {
        guard let fullName = fullNameField.text(),
              !fullName.isEmpty,
              
              let email = emailField.text(),
              !email.isEmpty,
              
              let phoneNumber = phoneNumberField.text(),
//              !phoneNumber.isEmpty,
              
              let address = addresslbl.text,
              !address.isEmpty,
              
              let password = passwordField.text(),
              !password.isEmpty,
              
              let confirmPassword = confirmPasswordField.text(),
              !confirmPassword.isEmpty,
              let userType = userTypeDropDown.text?.lowercased(),
              
              userType != "select user type"  else {
                self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled )
            return
        }
        
        guard  password == confirmPassword else {
            self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.PasswordNotMatch)
            return
        }
        
        guard userType == "customer" || userType == "agent" || userType == "contractor" else {
            self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.SelectFromDropDown)
            return
        }
        
        self.loadingIndicator?.startAnimating()
        
        var parameters = [
            "name": fullName,
            "email": email,
            "password": password,
            "location": address,
            "phone_number": phoneNumber,
            "longitude": lng,
            "latitude": lat,
            "user_type": userType,
            "device_token": (randomString(length: 8))
            ] as [String : Any]
        
        if userType != "customer" {
            guard let companyName = companyNameField.text(), !companyName.isEmpty, let website = websiteField.text(), !website.isEmpty, let experience = experienceField.text(), !experience.isEmpty, let licenseNumber = licenseNumberField.text(), !licenseNumber.isEmpty else {
                self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled )
                return
            }
            parameters["company_name"] = companyName
            parameters["lisence_number"] = licenseNumber
            parameters["experience"] =  experience
            parameters["website"] =  website
            parameters["area_of_exp_id"] = areaOfInterestList
        }
        if isSendDate  {
            parameters["availability_start"] = startDateField.text
            parameters["availability_end"] = endDateField.text
        }
        print("sending paramters",parameters)
        SignUp(parameters: parameters)
    }
    
    @IBAction func loginBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "areaOfInterestSegue" {
            let vc = segue.destination as? AreaOfInterestListVC
            vc?.delegate = self
            vc?.selectedUser = areaOfInterestList
            print(areaOfInterestList)
        } else if segue.identifier == "DatePiclerFromSignUp" {
            let vc = segue.destination as? DatePickerVC
            vc?.delegate = self
            vc?.isStart = self.isStart
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetAddressVC") as! GetAddressVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func startDatetap(_ sender: UITapGestureRecognizer? = nil) {
        print("date start")
        self.isStart = true
        self.performSegue(withIdentifier: "DatePiclerFromSignUp", sender: nil)
    }
    
    @objc func endDatetap(_ sender: UITapGestureRecognizer? = nil) {
        print("end start")
        self.isStart = false
        self.performSegue(withIdentifier: "DatePiclerFromSignUp", sender: nil)
    }
    
    func SignUp(parameters: [String: Any]){
        ProfilesHandlerApis.shared().signUp(params: parameters, onSuccess: { (result) in
            self.loadingIndicator?.stopAnimating()
            if result?.status ?? false {
                print("successful signUp", result?.data ?? "")
                self.showAlertWith(title: AlertConstants.Alert, message: result?.message ?? "Please varify your email. For Varify please check your email account") {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                print("ERROR: ",result?.error as Any)
                self.showAlertWith(title: AlertConstants.Error, message: result?.error ??  AlertConstants.SomeThingWrong)
            }
        }, onFailure: { (error) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error!.localizedDescription )
            
        }) { (errorMessage) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func setupUserTypedropdown(){
        
        // The the Closure returns Selected Index and String
        dropDownproperties(dropDown: userTypeDropDown, placeHolder: "Select User Type", listArray:  ["Customer","Contractor","Agent"])
        
        userTypeDropDown.didSelect{(selectedText , index ,id) in
            if index != 0 {
                self.companyNameField.isHidden = false
                self.websiteField.isHidden = false
                self.licenseNumberField.isHidden = false
                self.experienceField.isHidden = false
                self.areaOfInterest.isHidden = false
                self.availbility.isHidden = false
                self.availableContainer.isHidden = true
                self.heightConstant.constant = 1720
                
            } else {
                self.companyNameField.isHidden = true
                self.websiteField.isHidden = true
                self.licenseNumberField.isHidden = true
                self.experienceField.isHidden = true
                self.areaOfInterest.isHidden = true
                self.availbility.isHidden = true
                self.availableContainer.isHidden = true
                self.heightConstant.constant = 1130
            }
        }
        
        dropDownproperties(dropDown: availabilityField, placeHolder: "Your Availability", listArray: ["Available", "Busy In Other Project"])
        availabilityField.didSelect { (selectedText , index ,id) in
            if index == 1 {
                self.availableContainer.isHidden = false
                self.isSendDate = true
                self.heightConstant.constant = 1800
                
            } else {
                self.isSendDate = false
                self.availableContainer.isHidden = true
                self.heightConstant.constant = 1700
            }
        }
    }
    
    func dropDownproperties(dropDown: DropDown, placeHolder: String, listArray: [String]) {
        dropDown.text = placeHolder
        dropDown.optionArray = listArray
        dropDown.arrowColor = UIColor().colorForHax("#FDC11B")
        dropDown.isSearchEnable = false
        dropDown.selectedRowColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        dropDown.rowHeight = 50
        dropDown.listHeight = 200
    }
    
    func setupFields() {
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        
        registerBtn.layer.cornerRadius = 10
        registerBtn.layer.borderWidth = 5
        registerBtn.layer.borderColor = UIColor().colorForHax("#FDC11B").cgColor
       
        self.setUpTextFields(fullNameField, "nameicon", "Full Name")
        
        emailField.layer.cornerRadius = 8
        emailField.layer.masksToBounds = false
        emailField.layer.shadowColor = UIColor.lightGray.cgColor
        emailField.layer.shadowOpacity = 0.3
        emailField.layer.shadowRadius = 8
        
        let email_regex_pattern = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        emailField.setup(setting:
            RYFloatingInputSetting.Builder.instance()
                .placeholer("Email ")
                .iconImage(UIImage(named: "emailicon")!)
                .inputType(.regex(pattern: email_regex_pattern), onViolated: (message: "Invalid Email Format", callback: nil))
                .build()
        )
        
        self.setUpTextFields(phoneNumberField, "icons8-two_smartphones_filled", "Phone Number")
        self.setUpFieldUI(addressField)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addressField.isUserInteractionEnabled = true
        addressField.addGestureRecognizer(tap)
        
        let startDatetapGesture = UITapGestureRecognizer(target: self, action: #selector(self.startDatetap(_:)))
        startDateContainer.isUserInteractionEnabled = true
        startDateContainer.addGestureRecognizer(startDatetapGesture)
        
        let endDatetapGesture = UITapGestureRecognizer(target: self, action: #selector(self.endDatetap(_:)))
        endDateContainer.isUserInteractionEnabled = true
        endDateContainer.addGestureRecognizer(endDatetapGesture)
                
//        let addressFieldSetting = RYFloatingInputSetting.Builder.instance()
//            .theme(.standard).iconImage(UIImage(named: "icons8-marker")!)
//            .placeholer("Address")
//            .secure(false)
//            .build()
//        addressField.setup(setting: addressFieldSetting)
        
        self.setUpFieldUI(areaOfInterest)
        self.setUpTextFields(companyNameField, "icons8-company", "Company Name")
        
        self.setUpTextFields(licenseNumberField, "icons8-licence_filled", "License Number")
        self.setUpTextFields(experienceField, "icons8-diamond-care-50", "Experience (Years)")
        self.setUpTextFields(websiteField, "website", "Website")
        self.setUpTextFields(passwordField, "icons8-password", "Password")
        self.setUpTextFields(confirmPasswordField, "icons8-password", "Confirm Password")
        self.setUpFieldUI(userTyperOuterVu)
        self.setUpFieldUI(availbility)
        self.setUpFieldUI(availableContainer)
        
        companyNameField.isHidden = true
        websiteField.isHidden = true
        licenseNumberField.isHidden = true
        experienceField.isHidden = true
        areaOfInterest.isHidden = true
        self.availbility.isHidden = true
        availableContainer.isHidden = true
        
        let areaOfInterestTap = UITapGestureRecognizer(target: self, action: #selector(self.showAreaOfExperience(_:)))
        areaOfInterest.isUserInteractionEnabled = true
        self.areaOfInterest.addGestureRecognizer(areaOfInterestTap)
        
        self.heightConstant.constant = 1130
    
    }
    
    @objc func showAreaOfExperience(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "areaOfInterestSegue", sender: self)
    }
    
    
    func setUpTextFields(_ txtFld: RYFloatingInput, _ imageName: String, _ placeholder: String, _ shadowEnable: Bool = true ) {
        
        if shadowEnable {
            txtFld.layer.cornerRadius = 8
            txtFld.layer.masksToBounds = false
            txtFld.layer.shadowColor = UIColor.lightGray.cgColor
            txtFld.layer.shadowOpacity = 0.3
            txtFld.layer.shadowRadius = 8
        }
        
        let fullnameSetting = RYFloatingInputSetting.Builder.instance()
            .theme(.standard).iconImage(UIImage(named: imageName)!)
            .placeholer(placeholder)
            .secure(false)
            .build()
        txtFld.setup(setting: fullnameSetting)
    }
    
    func setUpFieldUI(_ view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
    }
    
}
