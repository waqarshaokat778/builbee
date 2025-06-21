//
//  ModalVC.swift
//  Builbee
//
//  Created by Abdullah on 12/26/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit

class ModalVC: BaseClass {

    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var phoneNolbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var errorlbl: UILabel!
    
    @IBOutlet weak var userNameContainer: UIStackView!
    @IBOutlet weak var phoneNumberContainer: UIStackView!
    @IBOutlet weak var emailContainer: UIStackView!
    @IBOutlet weak var websiteContainer: UIStackView!
    
    
    var isFrom = "AgentHomeC"
    var isAgent = false
    var agentProfileData :  AgentList? = nil
    var contractorProfileData : ContractorsList? = nil
    var customerPostedProjects: PostData? = nil
    var projectID = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorlbl.isHidden = true
       
        setFieldData()
    }
    
    func setFieldData() {
        if isCustomerLogin() && isFrom == "AgentHomeC" {
            if isAgent {
                namelbl.text = (agentProfileData?.name ?? "")
                phoneNolbl.text = (agentProfileData?.phone_number ?? "")
                emaillbl.text = (agentProfileData?.email ?? "")
                addresslbl.text = (agentProfileData?.agent?.website ?? "")
            } else {
                
                namelbl.text = (contractorProfileData?.name ?? "")
                phoneNolbl.text = (contractorProfileData?.phone_number ?? "")
                emaillbl.text = (contractorProfileData?.email ?? "")
                addresslbl.text = (contractorProfileData?.contractor?.website ?? "")
            }
        } else {
                namelbl.text = (customerPostedProjects?.created_by?.name ?? "")
                phoneNolbl.text = (customerPostedProjects?.created_by?.phone_number ?? "")
                emaillbl.text = (customerPostedProjects?.created_by?.email ?? "")
                websiteContainer.isHidden = true
            
    //            addresslbl.text =  "Website: " + (userProfileInDefault?["website"] ?? "")
            }
        
        let phoneTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(openPhone(_:)))
        phoneNumberContainer.isUserInteractionEnabled = true
        phoneNumberContainer.addGestureRecognizer(phoneTapGesture)
       
        let emailTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(openEmail(_:)))
        emailContainer.isUserInteractionEnabled = true
        emailContainer.addGestureRecognizer(emailTapGesture)
      
        let addressTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(openAddress(_:)))
        websiteContainer.isUserInteractionEnabled = true
        websiteContainer.addGestureRecognizer(addressTapGesture)
        
    }
    
    @objc func openPhone(_ tapGesture: UITapGestureRecognizer) {
        let url = URL(string: "TEL://\(phoneNolbl.text!)")
        if url != nil {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func openEmail(_ tapGesture: UITapGestureRecognizer) {
        let url = URL(string: "mailto:\( String(describing: emaillbl.text!))")
        if url != nil {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func openAddress(_ tapGesture: UITapGestureRecognizer) {
 
        let url = URL(string: addresslbl.text!)
        print(addresslbl.text)
        if url != nil {
            UIApplication.shared.open(url!)
        }
    }
    
    @IBAction func okBtnTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
}
