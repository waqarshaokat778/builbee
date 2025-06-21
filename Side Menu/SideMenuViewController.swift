//
//  SideMenuViewController.swift
//  Bot
//
//  Created by Khawar Khan on 6/18/19.
//  Copyright © 2019 Software Alliance. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class SideMenuViewController: BaseClass {
    
    @IBOutlet weak var imgVu: UIImageView!
    @IBOutlet weak var userDpImgVu: UIImageView!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    
    var nameArray = ["Home","My Projects","Profile", "Conversations"]
    var imagesArray = ["homeicon","myprojectsicon","profileicon", "conversationsIcon"]
    var selectedColorHex = "#CFCFCF"
    var selectedIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblVu.delegate = self
        tblVu.dataSource = self
        tblVu.register(UINib(nibName: "DropDownTableViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTableViewCell")
        
        setUpLayout()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isCustomerLogin() {
            nameArray = ["Home","My Jobs","Profile", "Conversations"]
        }
    }

    
    @IBAction func closebtn(_ sender: Any) {
        self.toggleLeftView(self)
    }
    
    
    @IBAction func logOutBtnTpd(_ sender: Any) {
        
        self.loaderIndicator?.startAnimating()
        
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let token  = dict?["token"] as! String
            
        ProfilesHandlerApis.shared().logout(token: token) { (result) in
            print(result?.message as Any)
            
            if result?.status ?? false {
                
                UserDefaults.standard.removeObject(forKey: "ProfileModal")
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootVC = storyboard.instantiateViewController(withIdentifier: "SignInNavigationController") as! SignInNavigationController
                self.view.window?.rootViewController = rootVC
                
            } else {
                print(result?.message as Any)
                self.showAlertWith(title: AlertConstants.Error, message: result?.error ?? AlertConstants.SomeThingWrong)
            }
            
        } onFailure: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error!.localizedDescription )
        } onError: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error!.debugDescription)
        }
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func setUpLayout() {
        
        userNameLbl.text = userProfileInDefault?["name"] as! String
        userEmail.text = userProfileInDefault?["email"] as! String
        
        let url = URL(string: userProfileInDefault?["profile_img_url"] as! String)
        
        if url != nil {
            if #available(iOS 13.0, *) {
                imgVu.af_setImage(withURL: url!,placeholderImage: UIImage(named: "stock_image_four")?.withTintColor(.black, renderingMode: .alwaysTemplate))
            } else {
                // Fallback on earlier versions
                imgVu.af_setImage(withURL: url!,placeholderImage: UIImage(named:"stock_image_four"))
            }
            
        }
        
        imgVu.layer.borderWidth = 1
        imgVu.layer.masksToBounds = false
        imgVu.layer.borderColor = UIColor().colorForHax("#FDC11B").cgColor
        imgVu.layer.cornerRadius = imgVu.frame.height/2
        imgVu.clipsToBounds = true
                
        outerView.layer.cornerRadius = 10
        outerView.layer.borderWidth = 3
        outerView.layer.borderColor = UIColor.white.cgColor
        
    }
    
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 2{
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
//            cell.imgVu.image = UIImage(named: imagesArray[indexPath.row])
//            cell.dropdown.isSearchEnable = false
//            cell.dropdown.optionArray = ["Contacts","Preffered Agents","Preferred Contractors"]
//            cell.dropdown.text = "Contacts"
//            cell.dropdown.textColor = UIColor.black
//            cell.dropdown.selectedRowColor = UIColor().colorForHax("#FDC11B")
//            cell.dropdown.didSelect{(selectedText , index ,id) in cell.dropdown.text = "\(selectedText)"
//
//            }
//            return cell
//
//        } else{
            
            let SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
            SideMenuTableViewCell.nameLbl.text = nameArray[indexPath.row]
            SideMenuTableViewCell.imgVu.image = UIImage(named: imagesArray[indexPath.row])
            
            return SideMenuTableViewCell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row{
        
        case 0 :
            if !isCustomerLogin() {
                NotificationCenter.default.post(name: Notification.Name("changeRootVC"), object: nil, userInfo: ["VCName":"myprojects"])
                self.toggleLeftView(self)
            } else {
                NotificationCenter.default.post(name: Notification.Name("changeRootVC"), object: nil, userInfo: ["VCName":"HomeVC"])
                self.toggleLeftView(self)
            }
            
        
        case 1 :
            NotificationCenter.default.post(name: Notification.Name("changeRootVC"), object: nil, userInfo: ["VCName":"myprojects","isFrom": "leftSideMenu", "isIndividualProject": true])
            self.toggleLeftView(self)
            
//            case 2 :
//                NotificationCenter.default.post(name: Notification.Name("changeRootVC"), object: nil, userInfo: ["VCName":"LikedChannelsViewController"])
//                           self.toggleLeftView(self)
            
        case 2 :
            NotificationCenter.default.post(name: Notification.Name("changeRootVC"), object: nil, userInfo: ["VCName":"UpdateProfileVC"])
            self.toggleLeftView(self)
            
        case 3 :
            NotificationCenter.default.post(name: Notification.Name("changeRootVC"), object: nil, userInfo: ["VCName":"ConversationsVC"])
            self.toggleLeftView(self)
       
        default:
            print("nothing")
        }
        
    }
    
}
