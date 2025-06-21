//
//  EmailVerificationVC.swift
//  Builbee
//
//  Created by Abdullah on 12/15/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import AnimatedField

class EmailVerificationVC: BaseClass {

    @IBOutlet weak var codeContainer: UIView!
    @IBOutlet weak var codeFields: AnimatedField!
    
    var forMatchCode = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    @IBAction func verifyEmail(_ sender: Any) {
        
        guard let code = codeFields.text, !code.isEmpty else {
            showAlertWith(title: AlertConstants.Error, message: "Please enter the code")
            return
        }
         
        if code == forMatchCode {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetNewPasswordVC") as! SetNewPasswordVC
            vc.email = self.email
            vc.token = self.forMatchCode
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showAlertWith(title: AlertConstants.Error, message: "Incorrect code")
        }
        
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendCodetap(_ sender: Any) {
        resendCode()
    }
    
    func resendCode() {
        
        loaderIndicator?.startAnimating()
        let params : [String : Any] = ["is_code_send": true, "email": email]
        
        ProfilesHandlerApis.shared().sendCodeForRestPassword(params: params) { (result) in
            self.loaderIndicator?.stopAnimating()
            
            if result?.status ?? false {
                self.forMatchCode = result?.token ?? ""
            } else {
                print(result?.message as Any)
                self.showAlertWith(title: AlertConstants.Error, message: result?.message ?? AlertConstants.SomeThingWrong)
            }
            
        }  onFailure: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error!.localizedDescription )
        } onError: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error!.debugDescription)
        }
    
    }
    
    func setLayout() {
        self.setupFields(container: codeContainer, field: codeFields, placeholder: "Enter vrifiaction code")
    }
  
    
}
