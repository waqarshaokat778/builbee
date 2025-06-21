//
//  SignInViewController.swift
//  Builbee
//
//  Created by Khawar Khan on 12/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import RYFloatingInput
import GoogleSignIn
import FBSDKLoginKit
import NVActivityIndicatorView

class SignInViewController: BaseClass {
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var emailField: RYFloatingInput!
    @IBOutlet weak var passwordField: RYFloatingInput!
    @IBOutlet weak var facebookbtn: FBLoginButton!
    @IBOutlet weak var termsOfService: UILabel! {
        didSet {
            termsOfService.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    @IBOutlet weak var privacyPolicy: UILabel! {
        didSet {
            privacyPolicy.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    var isNewUser = false
    var userName : String = ""
    var email : String = ""
    var loadingIndicator : NVActivityIndicatorView? = nil
    
    override func viewDidLoad() {
        setupfields()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
//        facebookbtn.permissions = ["public_profile", "email"]
        
        setTextForTermsandPolicy()
    }
    
    func setTextForTermsandPolicy() {
        
        let servicelbltap = UITapGestureRecognizer(target: self, action: #selector(termsOfServiceTap(tapGestureRecognizer:)))
        termsOfService.isUserInteractionEnabled = true
        termsOfService.addGestureRecognizer(servicelbltap)

        let privacylbltap = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTap(tapGestureRecognizer:)))
        privacyPolicy.isUserInteractionEnabled = true
        privacyPolicy.addGestureRecognizer(privacylbltap)
    }
    
    @objc func termsOfServiceTap(tapGestureRecognizer: UITapGestureRecognizer) {
        print("terms of service label click")
        self.pushController(controller: TermsAndPolicyVC.id, storyboard: Storyboards.Main.id)
    }
    
    @objc func privacyPolicyTap(tapGestureRecognizer: UITapGestureRecognizer) {
        print("privacy policy label click")
        self.pushController(controller: TermsAndPolicyVC.id, storyboard: Storyboards.Main.id)
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        pushController(controller: ResetPasswordVC.id, storyboard: Storyboards.Main.id)
    }
    
    @IBAction func navigateToSignUp(_ sender: Any) {
        self.pushController(controller: SignUpViewController.id , storyboard: Storyboards.Main.id)
    }
    
    @IBAction func loginBtnTpd(_ sender: Any) {
        
        guard let email = emailField.text(), !email.isEmpty, let password = passwordField.text(), !password.isEmpty else {
            self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled )
            return
        }

        self.loadingIndicator?.startAnimating()
        let parameters = ["email": email, "password": password, "device_token": "\(randomString(length: 8))"]
        SignIn(parameters: parameters)
    
    }
    
    @IBAction func logInWithFaceBook(_ sender: Any) {
       
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            self.loadingIndicator?.startAnimating()
            guard let accessToken = FBSDKLoginKit.AccessToken.current else { return }
            
            let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                          parameters: ["fields": "email, name"],
                                                          tokenString: accessToken.tokenString,
                                                          version: nil,
                                                          httpMethod: .get)
            graphRequest.start { (connection, result, error) -> Void in
                if error == nil {
                    
                    let loginManager = LoginManager()
                    loginManager.logOut()
                    
                    let modal = result as? [String: String]
                    print(modal!)
                    guard modal!["email"] != nil else {
                        self.showAlertWith(title: "error", message: "Email not exist. Please SignUp")
                        return
                    }
                    self.email = (modal?["email"])!
                    self.userName = (modal?["name"])!
//                    self.checkLogin(email: modal?["email"] ?? "test@gmail.com")
                }
                else {
                    self.loadingIndicator?.stopAnimating()
                    print("error \(String(describing: error))")
                }
            }
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func SignIn(parameters: [String: Any]){
        
        ProfilesHandlerApis.shared().logIn(params: parameters, onSuccess: { (result) in
            self.loadingIndicator?.stopAnimating()
        
            if result?.status ?? false {
                print("successful login", result?.data ?? "")
                self.performSegue(withIdentifier: "HomeVC", sender: self)
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
    
    func checkLogin(email: String) {
        
        let parameters = ["email": email, "password": "12345678"]
        self.isNewUser = true
        
        ProfilesHandlerApis.shared().logIn(params: parameters, onSuccess: { (result) in
            self.loadingIndicator?.stopAnimating()
            
            if result?.status ?? false {
            
                print("successful login", result?.data ?? "")
                self.performSegue(withIdentifier: "Home", sender: self)
            
//            } else {
//                
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//                vc.userName = self.userName
//                vc.email = self.email
//                self.navigationController?.pushViewController(vc, animated: true)
//            
            }
            
        }, onFailure: { (error) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error!.localizedDescription )
            
        }) { (errorMessage) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        }
        
    }
    
    func setupfields(){
        
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        
        loginBtn.layer.cornerRadius = 10
        loginBtn.layer.borderWidth = 5
        loginBtn.layer.borderColor = UIColor().colorForHax("#FDC11B").cgColor
        
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
        
        passwordField.layer.cornerRadius = 8
        passwordField.layer.masksToBounds = false
        passwordField.layer.shadowColor = UIColor.lightGray.cgColor
        passwordField.layer.shadowOpacity = 0.3
        passwordField.layer.shadowRadius = 8
        let setting1 = RYFloatingInputSetting.Builder.instance()
            .theme(.standard).iconImage(UIImage(named: "icons8-password.png")!)
            .placeholer("Password")
            .secure(true)
            .build()
        
        passwordField.setup(setting: setting1)
    }
    
}

extension SignInViewController: GIDSignInDelegate {
    
    //MARK:Google SignIn Delegate
     func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
      // myActivityIndicator.stopAnimating()
        }

    // Present a view that prompts the user to sign in with Google
       func sign(_ signIn: GIDSignIn!,
                  present viewController: UIViewController!) {
            self.present(viewController, animated: true, completion: nil)
        }

    // Dismiss the "Sign in with Google" view
     func sign(_ signIn: GIDSignIn!,
                  dismiss viewController: UIViewController!) {
            self.dismiss(animated: true, completion: nil)
        }

    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.loadingIndicator?.startAnimating()
        if (error == nil) {
            self.email = user.profile.email
            self.userName = user.profile.name
//            checkLogin(email: user.profile.email ?? "test@gmail.com")
        } else {
            self.loadingIndicator?.stopAnimating()
            print("\(error.localizedDescription)")
        }
    }
}


extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
