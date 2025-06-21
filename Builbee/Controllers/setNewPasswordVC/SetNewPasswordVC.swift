//
//  SetNewPasswordVC.swift
//  Builbee
//
//  Created by Abdullah on 12/3/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import AnimatedField
import NVActivityIndicatorView

class SetNewPasswordVC: BaseClass {
   
    @IBOutlet weak var newPasswordIcon: UIImageView!
    @IBOutlet weak var passwordContaienr: UIView!
    @IBOutlet weak var passwordTextField: AnimatedField!
    @IBOutlet weak var repasswordContainer: UIView!
    @IBOutlet weak var confirmPassword: AnimatedField!
    
    var email = ""
    var token = ""
    var loadingIndicator : NVActivityIndicatorView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.newPasswordIcon.isUserInteractionEnabled = true
        self.newPasswordIcon.addGestureRecognizer(tapGesture)
        
        self.setupFields(container: passwordContaienr, field: passwordTextField, placeholder: "Password")
        self.setupFields(container: repasswordContainer, field: confirmPassword, placeholder: "Repassword")
        
    }
    
    @objc func tapped(_ sender: UIButton){
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        guard let password = passwordTextField.text, !password.isEmpty, let rePassword = confirmPassword.text, !rePassword.isEmpty else {
            self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled)
            return
        }
        
        guard  password == rePassword else {
            self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.PasswordNotMatch)
            return
        }
        
        loadingIndicator?.startAnimating()
        
        let params : [String:Any] = ["is_code_send": false, "email": email, "new_password": password , "code": token]
        
        ProfilesHandlerApis.shared().setNewPassword(params: params) { (result) in
            self.loadingIndicator?.stopAnimating()
            
            if result?.status ?? false {
                self.pushController(controller: SignInViewController.id , storyboard: Storyboards.Main.id)

            } else {
                print(result?.message as Any)
                self.showAlertWith(title: AlertConstants.Error, message: result?.message ?? AlertConstants.SomeThingWrong)
            }
            
        }  onFailure: { (error) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error!.localizedDescription )
        } onError: { (error) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error!.debugDescription)
        }
    
    
    }
    
}
