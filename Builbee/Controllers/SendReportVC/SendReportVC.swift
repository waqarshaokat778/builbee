//
//  SendReportVC.swift
//  Builbee
//
//  Created by Abdullah on 12/23/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import iOSDropDown

class SendReportVC: BaseClass {

    @IBOutlet weak var reportCatagoryContainer: UIView! {
        didSet {
            reportCatagoryContainer.layer.borderWidth = 1
            reportCatagoryContainer.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            reportCatagoryContainer.layer.cornerRadius = 8
        }
    }
   
    @IBOutlet weak var reasonReportContainer: UIView! {
        didSet {
            reasonReportContainer.layer.borderWidth = 1
            reasonReportContainer.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            reasonReportContainer.layer.cornerRadius = 8
        }
    }
   
    @IBOutlet weak var reasonDetailfield: UITextView!
    @IBOutlet weak var reportTypeField: DropDown!
    
    var isCustomer = false
    var isFrom = "AgentHomeC"
    var projectList: ProjectData? = nil
    var customerPostedProjects: PostData? = nil
    
    var reportTypesForProject: [String] = []
    var reportTypesForUser: [String] = []
    var reportTypesForPost: [String] = []
    var reportTypeResult: ReportTypeModal? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCustomer = isCustomerLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getReportType()
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportBtnTap(_ sender: Any) {
        guard let detail = reasonDetailfield.text, !detail.isEmpty else {
            showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled)
            return
        }
        reportUser(detail)
    }
    
    func setupUserTypedropdown(){
        
        // The the Closure returns Selected Index and String
        
        if isCustomerLogin() && isFrom == "AgentHomeC" {
            
        dropDownproperties(dropDown: reportTypeField, placeHolder: "Select Report Type", listArray: reportTypesForProject)
        } else if !isCustomerLogin() && isFrom == "AgentHomeC"{
        dropDownproperties(dropDown: reportTypeField, placeHolder: "Select Report Type", listArray: reportTypesForPost)
        } else {
            dropDownproperties(dropDown: reportTypeField, placeHolder: "Select Report Type", listArray: reportTypesForUser)
        }
        
        reportTypeField.didSelect{(selectedText , index ,id) in
            if index != 0 {
          
            } else {
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
    
    func reportUser(_ detail: String) {
        
        loaderIndicator?.startAnimating()
        
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let token  = dict?["token"] as! String
        
        var parameters = ["reported_post": 1, "reason": detail] as [String: Any]
        var url = APIUrl.reportUser
        
        
        if (!isCustomer && isFrom == "AgentHomeC") || (isCustomer && isFrom != "AgentHomeC") {
            parameters = ["reported_post": customerPostedProjects!.id ?? "-1", "reason": detail] as [String: Any]
            url = APIUrl.reportPost
        } else {
            parameters = ["reported_project": projectList!.id ?? "-1", "reason": detail] as [String: Any]
            url = APIUrl.reportProject
        }
        
        print(url,parameters)
        
        ReportsAPIs.shared().get(url: url, params: parameters, token: token) { (result) in
            
            self.loaderIndicator?.stopAnimating()
            
            if result?.status ?? false {
                self.showAlertWith(title: AlertConstants.Success, message: "Email send  Successfully")
                
                DispatchQueue.main.async {
                    self.reasonDetailfield.text = ""
                }
                
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: result?.error?.description ?? AlertConstants.SomeThingWrong)
            }
            
        } onFailure: { (error) in

            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )

        } onError: {(errorMessage) in
            
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        
        }

        
    }
    
    func getReportType() {
        
        ReportsAPIs.shared().getTypes( token: getToken()) { (result) in
            
            self.loaderIndicator?.stopAnimating()
            
            if result?.status ?? false {
                self.reportTypeResult = result
                self.reportTypesForUser = result?.user_report_types?.enumerated().map({
                    return $0.element.name
                }) as! [String]
                
                self.reportTypesForPost = result?.post_report_types?.enumerated().map({
                    return $0.element.name
                }) as! [String]
                
                self.reportTypesForProject = result?.project_report_types?.enumerated().map({
                    return $0.element.name
                }) as! [String]
               
        
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: result?.error?.description ?? AlertConstants.SomeThingWrong)
            }
            DispatchQueue.main.async {                self.setupUserTypedropdown()
            }
        } onFailure: { (error) in

            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )

        } onError: {(errorMessage) in
            
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        
        }

    }
    
    func setupFields(container: UIView){
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.lightGray.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowRadius = 8
    }
}
