//
//  ResetPasswordVC.swift
//  Builbee
//
//  Created by Abdullah on 12/3/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import AnimatedField
import NVActivityIndicatorView

class ResetPasswordVC: BaseClass {
  
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var emailTextField: AnimatedField!
    
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendVarificationCode(_ sender: Any) {
        
        guard  let email = emailTextField.text, !email.isEmpty else {
            self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled)
            return
        }
        
        loaderIndicator?.startAnimating()
        let params : [String : Any] = ["is_code_send": true, "email": email] 
        
        ProfilesHandlerApis.shared().sendCodeForRestPassword(params: params) { (result) in
            self.loaderIndicator?.stopAnimating()
            
            if result?.status ?? false {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
                vc.email = email
                vc.forMatchCode = result?.token ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
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
        self.setupFields(container: emailContainer, field: emailTextField, placeholder: "Email")
    }
    
}
