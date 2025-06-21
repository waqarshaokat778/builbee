//
//  UpdateProfileVC.swift
//  Builbee
//
//  Created by Abdullah on 12/7/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import iOSDropDown
import RYFloatingInput
import AnimatedField
import AlamofireImage

class UpdateProfileVC: BaseClass, UIImagePickerControllerDelegate & UINavigationControllerDelegate, getLoacitonDelegate, selectedAreaOfInterestDelegate, datePickerDelegate {
    
    
    func selectedListAreaOfInterest(list: [Int]) {
        
        areaOfInterestList = list
        areaOfInterestCount.isHidden = true
        trialingConstraint.constant = 14
        
        if list.count > 0 {
            areaOfInterestCount.isHidden = false
            trialingConstraint.constant = 40
            areaOfInterestCount.text = "\(list.count)"
        }
    }
    
    func getLoaction(address: String, lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
        addresstext = address
        locationField.text = address
    }
    
    
    @IBOutlet weak var infoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageContainer: UIView! {
        didSet {
            imageContainer.layer.borderWidth = 1
            imageContainer.layer.cornerRadius = imageContainer.frame.width / 2
            imageContainer.layer.borderColor =  UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameContainer: UIView!
    @IBOutlet weak var emailContainer: UIView!
    
    @IBOutlet weak var phoneNumberContainer: UIView!
    @IBOutlet weak var areaOfInterestContainer: UIView!
    @IBOutlet weak var companyNameContainer: UIView!
    @IBOutlet weak var licenseContainer: UIView!
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var experienceContainer: UIView!
    @IBOutlet weak var websiteContainer: UIView!
    
    @IBOutlet weak var shortInfoContainer: UIStackView!
    @IBOutlet weak var linkedinContainer: UIView!
    @IBOutlet weak var socialLinksContainer: UIStackView!
    @IBOutlet weak var facebookContainer: UIView!
    @IBOutlet weak var instagramContainer: UIView!
    @IBOutlet weak var twitterContainer: UIView!
    
    @IBOutlet weak var userNameField: AnimatedField!
    @IBOutlet weak var emailField: AnimatedField!
    
    @IBOutlet weak var phoneNumber: AnimatedField!
    @IBOutlet weak var areaOfInterestCount: UILabel!
    @IBOutlet weak var companyNameField: AnimatedField!
    @IBOutlet weak var licenseNumberField: AnimatedField!
    @IBOutlet weak var locationField: AnimatedField!
    @IBOutlet weak var yearOfExperience: AnimatedField!
    @IBOutlet weak var linkOfWebsiteField: AnimatedField!
    
    @IBOutlet weak var linkedinField: AnimatedField!
    @IBOutlet weak var faceboobkField: AnimatedField!
    @IBOutlet weak var instaField: AnimatedField!
    @IBOutlet weak var twitterField: AnimatedField!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
   
    @IBOutlet weak var availableContainer: UIView!
    @IBOutlet weak var startDateContainer: UIView!
    @IBOutlet weak var startDateField: AnimatedField!
    @IBOutlet weak var endDateContainer: UIView!
    @IBOutlet weak var endDateField: AnimatedField!
    
    @IBOutlet weak var bioContainer: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var trialingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var availbility: UIView!
    @IBOutlet weak var availabilityField: DropDown!
    
    
    var lat = ""
    var lng = ""
    var isStart: Bool = true
    var addresstext = ""
    var isAvailable = true
    var areaOfInterestList: [Int] = []
    var imagePicker = UIImagePickerController()
    var areaOfInterestInDefault: [AreaOfInterestDataModal]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        areaOfInterestCount.isHidden = true
        trialingConstraint.constant = 14
        callingSetUpFields()
    }
    
    @IBAction func navigateBAck(_ sender: Any) {
        showLeftViewAnimated(sender)
    }
    
    @objc func updateProfileImage(tapGestureRecognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func updateProfile(_ sender: Any) {
       
        guard let name = userNameField.text, !name.isEmpty, let email = emailField.text, !email.isEmpty, let phoneNo = phoneNumber.text,   let address = locationField.text, !address.isEmpty else {
                self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled )
                return
        }
        
        
        self.loaderIndicator?.startAnimating()
        
        var parameters = [
            "name": name,
            "email": email,
            "location": address,
            "phone_number": phoneNo,
            "longitude": lng,
            "latitude": lat
            ] as [String : Any]
        
        if !isCustomerLogin() {
            guard let companyName = companyNameField.text, !companyName.isEmpty, let website = linkOfWebsiteField.text, !website.isEmpty, let experience = yearOfExperience.text, !experience.isEmpty, let licenseNumber = licenseNumberField.text, !licenseNumber.isEmpty, let bio = bioTextView.text, !bio.isEmpty else {
                self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled )
                return
            }
            
            let linkedin = linkOfWebsiteField.text, fb = faceboobkField.text, instra = instaField.text, twitter = twitterField.text
            
            parameters["area_of_exp_id[]"] = areaOfInterestList
            parameters["company_name"] = companyName
            parameters["lisence_number"] = licenseNumber
            parameters["experience"] =  experience
            parameters["website"] =  website
            parameters["bio"] = bio
            parameters["linkedin"] = linkedin
            parameters["facebook"] =  fb
            parameters["instagram"] =  instra
            parameters["twitter"] = twitter
            
            
            if !isAvailable {
                parameters["availability_start"] =  startDateField.text
                parameters["availability_end"] =  endDateField.text
            }
       }
        
        let imgData = userImage.image?.jpegData(compressionQuality: 0.2)!
        let imgString = imgData?.base64EncodedString(options: .init(rawValue: 0))
        if imgString != nil {
            parameters["profile_img_url"] = "data:image/\(imgData!.fileExtension);base64" + imgString!
            print("data:image/\(imgData!.fileExtension);base64," + imgString!)
        }
        
        updateProfile(params: parameters)
    }
    
    @objc func addressFieldTap(_ sender: UITapGestureRecognizer? = nil) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetAddressVC") as! GetAddressVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetAddressVC") as! GetAddressVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func areaOfInterestFieldTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "areaOfInterestSegueFromProfile", sender: self)
    }
    
    @objc func startDatetap(_ sender: UITapGestureRecognizer? = nil) {
        print("date start")
        self.isStart = true
        self.performSegue(withIdentifier: "DatePiclerFromProfile", sender: nil)
    }
    
    @objc func endDatetap(_ sender: UITapGestureRecognizer? = nil) {
        print("end start")
        self.isStart = false
        self.performSegue(withIdentifier: "DatePiclerFromProfile", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "areaOfInterestSegueFromProfile" {
            let vc = segue.destination as? AreaOfInterestListVC
            vc?.delegate = self
            vc?.selectedUser = areaOfInterestList
        } else if segue.identifier == "DatePiclerFromProfile" {
            let vc = segue.destination as? DatePickerVC
            vc?.delegate = self
            vc?.isStart = self.isStart
        }
        
    }
    
    func getData(_ date: String, _ isStart: Bool) {
        
        if (isStart) {
            self.startDateField.text = date
        } else {
            self.endDateField.text = date
        }
        
    }
    
    func updateProfile(params : [String: Any]) {
        
        self.loaderIndicator?.startAnimating()

        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let token  = dict?["token"] as! String
        
        ProfilesHandlerApis.shared().updateProfile(parameters: params, token: token) { (respones) in
            self.loaderIndicator?.stopAnimating()
        
        } onFailure: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
        } onError: { (errorMessage) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage?.description ?? AlertConstants.SomeThingWrong )
        }
        
    }
    
    func callingSetUpFields() {
        
        self.setupFieldView(container: userNameContainer, field: userNameField, placeholder: "User Name")
        self.setupFieldView(container: emailContainer, field: emailField, placeholder: "Email")
       
        self.setupFieldView(container: phoneNumberContainer, field: phoneNumber, placeholder: "Phone Number")
        
        self.setupFieldView(container: startDateContainer, field: startDateField, placeholder: "Available From", isApplyShadow: false)
        startDateField.isUserInteractionEnabled = false
            
        self.setupFieldView(container: endDateContainer, field: endDateField, placeholder: "Available To", isApplyShadow: false)
        endDateField.isUserInteractionEnabled = false
    
        self.setupFieldView(container: companyNameContainer, field: companyNameField, placeholder: "Company Name")
        self.setupFieldView(container: licenseContainer, field: licenseNumberField, placeholder: "License Number")
        self.setupFieldView(container: locationContainer, field: locationField, placeholder: "Location")
        locationField.isUserInteractionEnabled = false
        self.setupFieldView(container: experienceContainer, field: yearOfExperience, placeholder: "Year of Experience")
        self.setupFieldView(container: websiteContainer, field: linkOfWebsiteField, placeholder: "Link of Website")
        
        self.setupFieldView(container: facebookContainer, field: faceboobkField, placeholder: "FaceBook page Link")
        self.setupFieldView(container: linkedinContainer, field: linkedinField, placeholder: "Linkedin Link")
        
        self.setupFieldView(container: instagramContainer, field: instaField, placeholder: "Instagram page Link")
        self.setupFieldView(container: twitterContainer, field: twitterField, placeholder: "twitter Page Link")
        
        self.setShadow(availableContainer)
        self.setShadow(areaOfInterestContainer)
        self.setShadow(bioContainer)
        self.setShadow(availbility)
        self.bioTextView.layer.cornerRadius = 8
        
        setUpDataIntoFields()
        
        let startDatetapGesture = UITapGestureRecognizer(target: self, action: #selector(self.startDatetap(_:)))
        startDateContainer.isUserInteractionEnabled = true
        startDateContainer.addGestureRecognizer(startDatetapGesture)
        
        let endDatetapGesture = UITapGestureRecognizer(target: self, action: #selector(self.endDatetap(_:)))
        endDateContainer.isUserInteractionEnabled = true
        endDateContainer.addGestureRecognizer(endDatetapGesture)
        
        dropDownproperties(dropDown: availabilityField, placeHolder: "Your Availability", listArray: ["Available", "Busy In Other Project"])
        if !isCustomerLogin() {
            if isAvailable() {
                availabilityField.selectedIndex = 0
                self.scrollViewHeight.constant = 1800
            } else {
                availabilityField.selectedIndex = 1
                self.scrollViewHeight.constant = 1900
            }
        }
        
        availabilityField.didSelect { (selectedText , index ,id) in
            if index == 1 {
                self.scrollViewHeight.constant = 1900
                self.availableContainer.isHidden = false
                self.isAvailable = false
                
            } else {
                self.isAvailable = true
                self.scrollViewHeight.constant = 1800
                self.availableContainer.isHidden = true
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
    
    func setShadow(_ view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
    }
    
    
    func setupFieldView(container: UIView, field: AnimatedField, placeholder: String, isApplyShadow: Bool = true ){
        
        if isApplyShadow {
            setShadow(container)
        }
        
        var format = AnimatedFieldFormat()
        
        format.alertColor = .red
        format.alertFieldActive = false
        format.titleAlwaysVisible = true
        format.highlightColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        format.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        field.format = format
        field.attributedPlaceholder = NSAttributedString(string: placeholder)
        
    }
    
    func setUpDataIntoFields() {
        
        let tapGestureUpdateImage = UITapGestureRecognizer(target: self, action: #selector(updateProfileImage(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureUpdateImage)
        userImage.layer.cornerRadius = userImage.layer.frame.height / 2
        
        
        let addressFieldtapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addressFieldTap(_:)))
        locationContainer.isUserInteractionEnabled = true
        locationContainer.addGestureRecognizer(addressFieldtapGesture)
        
        let areaOfInterestFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.areaOfInterestFieldTap(_:)))
        areaOfInterestContainer.isUserInteractionEnabled = true
        areaOfInterestContainer.addGestureRecognizer(areaOfInterestFieldTapGesture)
        userNameField.text =  userProfileInDefault?["name"] as? String
        emailField.text = userProfileInDefault?["email"] as? String
        
        phoneNumber.text = userProfileInDefault?["phone_number"] as? String
        if addresstext == "" {
            locationField.text = userProfileInDefault?["location"] as? String
        }
        
        if !isCustomerLogin() {
            if userProfileInDefault?["availability_start"] as? String != "" {
                startDateField.text = userProfileInDefault?["availability_start"] as? String
               
            }
            
            if userProfileInDefault?["availability_end"]  as? String != "" {
                endDateField.text = userProfileInDefault?["availability_end"] as? String
            }
            let areaOfInterestlist  = userProfileInDefault?["area_of_exp"]
            
//            let decoded  = userProfileInDefault?[ "area_of_exp"]
//            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data)
            
            areaOfInterestCount.isHidden = false
            areaOfInterestCount.text = "\(areaOfInterestlist ?? 0)"
            companyNameField.text = userProfileInDefault?["company_name"] as? String
            licenseNumberField.text = userProfileInDefault?["lisence_number"] as? String
            yearOfExperience.text = userProfileInDefault?["experience"] as? String
            linkOfWebsiteField.text = userProfileInDefault?["website"] as? String
            
            linkedinField.text = userProfileInDefault?["linkedin"]  as? String
            faceboobkField.text = userProfileInDefault?["facebook"] as? String
            instaField.text = userProfileInDefault?["instagram"] as? String
            twitterField.text = userProfileInDefault?["twitter"] as? String
            
            bioTextView.text =  userProfileInDefault?["bio"] as? String
            
        }
        
        
        lng = userProfileInDefault?["longitude"] as? String ?? ""
        lat = userProfileInDefault?["latitude"]  as? String ?? ""
        
        if isCustomerLogin() {
            areaOfInterestContainer.isHidden = true
            companyNameContainer.isHidden = true
            licenseContainer.isHidden = true
            experienceContainer.isHidden = true
            websiteContainer.isHidden = true
            socialLinksContainer.isHidden = true
            availableContainer.isHidden = true
            shortInfoContainer.isHidden = true
            availbility.isHidden = true
            scrollViewHeight.constant = 690
            infoTopConstraint.constant = 20
        }
        
        let url = URL(string: userProfileInDefault?["profile_img_url"] as? String ?? "icons8-user" )
        
        print(userProfileInDefault?["profile_img_url"] ?? "icons8-user")
        
        if url != nil {
            if #available(iOS 13.0, *) {
                userImage.af_setImage(withURL: url!,placeholderImage: UIImage(named: "icons8-user")?.withTintColor( #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysTemplate))
            } else {
                userImage.af_setImage(withURL: url!,placeholderImage: UIImage(named:"icons8-user"))
            }
        } else {
            userImage.image = UIImage(named: "icons8-user")
        }
        
    }
    
}


public extension Data {
    
    var fileExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)

        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = ".jpg"
        case 0x89:
            ext = ".png"
        case 0x47:
            ext = ".gif"
        case 0x49, 0x4D :
            ext = ".tiff"
        default:
            ext = ".png"
        }
        return ext
    }
}
