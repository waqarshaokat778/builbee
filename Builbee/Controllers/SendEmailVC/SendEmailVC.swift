//
//  SendEmailVC.swift
//  Builbee
//
//  Created by Abdullah on 12/3/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import RYFloatingInput


class SendEmailVC: BaseClass {

    @IBOutlet weak var emailAddressField: RYFloatingInput!
    @IBOutlet weak var subjectField: RYFloatingInput!
    @IBOutlet weak var textViewField: UITextView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var textViewBackGround: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayouts()
        textViewField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        textViewField.text = "Email Body here..."
        textViewField.textColor = UIColor.lightGray
    }
    
    @IBAction func sendEmailbtnTap(_ sender: Any) {
        
        guard let subject = subjectField.text(), !subject.isEmpty, let email = emailAddressField.text() , !email.isEmpty, let body = textViewField.text , !body.isEmpty else {
            showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled)
            return
        }
        
        let mailURL = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)")
        if mailURL != nil {
            if UIApplication.shared.canOpenURL((mailURL!)) {
                UIApplication.shared.open(mailURL!, options: [:], completionHandler: nil)
            }
        } else {
            showAlertWith(title: AlertConstants.Error, message: AlertConstants.SomeThingWrong)
        }
    }
    
    func openMailApp() {

        let toEmail = "stavik@outlook.com"
        let subject = "Test email".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let body = "Just testing ...".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

         let
            urlString = "mailto:\(toEmail)?subject=\(subject)&body=\(body)",
            url = URL(string:urlString)
        UIApplication.shared.openURL(url!)
        
    }
    
    func setUpLayouts() {
        self.setUpTextFields(emailAddressField, "emailicon", "To")
        self.setUpTextFields(subjectField, "icons8-licence_filled", " Subject")
        createShadow(view: textViewBackGround)
        
        let backgroundGesture = UITapGestureRecognizer.init(target: self, action: #selector(navigateBackTap(_:)))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(backgroundGesture)
    }
    
    @objc func navigateBackTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpTextFields(_ txtFld: RYFloatingInput, _ imageName: String, _ placeholder: String) {
        txtFld.layer.cornerRadius = 8
        txtFld.layer.masksToBounds = false
        txtFld.layer.shadowColor = UIColor.lightGray.cgColor
        txtFld.layer.shadowOpacity = 0.3
        txtFld.layer.shadowRadius = 8
        let fullnameSetting = RYFloatingInputSetting.Builder.instance()
            .theme(.standard).iconImage(UIImage(named: imageName)!)
            .placeholer(placeholder)
            .secure(false)
            .build()
        txtFld.setup(setting: fullnameSetting)
    }
    
    func createShadow(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
    }
}

extension SendEmailVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewField.textColor == UIColor.lightGray {
            textViewField.text = ""
            textViewField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewField.text == "" {
            textViewField.text = "Email Body..."
            textViewField.textColor = UIColor.lightGray
        }
    }
}
