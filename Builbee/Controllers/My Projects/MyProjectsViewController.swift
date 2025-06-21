//
//  MyProjectsViewController.swift
//  Builbee
//
//  Created by Khawar Khan on 19/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import Popover
import AlamofireImage
import NVActivityIndicatorView

class MyProjectsViewController: BaseClass, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate {
   
    @IBOutlet weak var navigationbtn: UIButton!
    @IBOutlet weak var addProjectsBtn: UIButton!
    @IBOutlet weak var tbvu: UITableView!
    @IBOutlet weak var adminRightsContainer: UIView!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalProject: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var totalRequestlbl: UILabel!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableViewTopConstriant: NSLayoutConstraint!
    
    var index: IndexPath = []
    var isCustomer = false
    var isFrom = "AgentHomeC"
    var showAdminHandlerItem = false
    var isIndividualProject = false
    var isAgent = false
    var idForIndividualProject = -1
    var agentProfileData :  AgentList? = nil
    var contractorProfileData : ContractorsList? = nil
    var projectList: GetProjectResponse? = nil
    var loadingIndicator : NVActivityIndicatorView? = nil
    var customerPostedProjects: GetCustomerPostResponse? = nil
    var projectsListAboutSearch: [ProjectData]? = nil
    var isResultForSearch = false

    var totalListCount: Int = 0
    fileprivate var texts = ["Edit", "Delete"]
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
    .type(.up),
    .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    var pageNo = 1
    var isLoading = true
    var isSearchActive: Bool = false
    var searchModalData: SearchResultModal?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        tbvu.delegate = self
        tbvu.dataSource = self
        tbvu.tableFooterView = UIView()
        searchField.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        isCustomer = isCustomerLogin()
        if !isResultForSearch {
            loadDataAccordingToView()
        } else {
            viewForSearchResult()
        }
        
    }
    
    func viewForSearchResult() {
        
        searchContainer.isHidden = true
        adminRightsContainer.isHidden = true
        headerView.isHidden = true
        tableViewTopConstriant.constant = 0
    }
    
    func loadDataAccordingToView() {
        
        if isCustomer && isFrom == "AgentHomeC"  {
            navigationbtn.setImage(#imageLiteral(resourceName: "backicon"), for: .normal)
            headingLabel.text = "Projects"
            addProjectsBtn.setTitle("Add Jobs", for: .normal)
            totalRequestlbl.text = "Total Jobs"
            tableTopConstraint.constant = 70
            tableViewTopConstriant.constant = 140
            getDataList()

        } else if !isCustomer && isFrom == "AgentHomeC" {
            navigationbtn.setImage(#imageLiteral(resourceName: "menuicon"), for: .normal)
            headingLabel.text = "Job"
            addProjectsBtn.setTitle("Add Jobs", for: .normal)
            totalRequestlbl.text = "Total Jobs"
            adminRightsContainer.isHidden = !isIndividualProject
            tableTopConstraint.constant = 70
            tableViewTopConstriant.constant = 140
            getRelatedPost()
        } else if isCustomer && isFrom != "AgentHomeC" {
            navigationbtn.setImage(#imageLiteral(resourceName: "menuicon"), for: .normal)
            headingLabel.text = "Job"
            addProjectsBtn.setTitle("Add Jobs", for: .normal)
            totalRequestlbl.text = "Total Jobs"
            tableTopConstraint.constant = 145
            getRelatedPost()
        } else {
            navigationbtn.setImage(#imageLiteral(resourceName: "menuicon"), for: .normal)
            headingLabel.text = "Projects"
            addProjectsBtn.setTitle("Add Project", for: .normal)
            totalRequestlbl.text = "Total Projects"
            adminRightsContainer.isHidden = false
            print("!Customer && isFrom != AgentHomeC ")
            tableTopConstraint.constant = 145
            getDataList()
        }
    }
    
    func reloadDataAfterUpdateOrDelete() {
        if isCustomer && isFrom == "AgentHomeC"  {
            getRelatedPost()
        } else if !isCustomer && isFrom == "AgentHomeC" {
            getRelatedPost()
        } else if isCustomer && isFrom != "AgentHomeC" {
            getRelatedPost()
        } else {
            getDataList()
        }
    }
    
    func getSearchDataList() {
        
        loadingIndicator?.startAnimating()
        
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let parameters = ["page": pageNo, "general_search": searchField.text!] as [String : Any]
        let token  = dict?["token"] as! String
        print(parameters)
                
        NetWorkCalls.shared().getSearchResult(token: token, params: parameters, onSuccess: { (result) in
            self.loadingIndicator?.stopAnimating()
        
            if result?.status ?? false {
                print(type(of: result), type(of: self.searchModalData))
                
                DispatchQueue.main.async {
                    self.searchModalData = result
                    print(self.searchModalData!, result as Any)
                    self.tbvu.reloadData()
                }
                
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.SomeThingWrong)
            }
            
        }, onFailure: { (error) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
            
        }) { (errorMessage) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        }
        
    }
    
    func getRelatedPost() {
        
        loadingIndicator?.startAnimating()
        
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let token  = dict?["token"] as! String
        
        var url = APIUrl.post
        
        if !isIndividualProject {
            
            url = APIUrl.allPost + "?page=\(pageNo)"
            if idForIndividualProject == -1 {
                url = APIUrl.allPost + "?page=\(pageNo)"
            }
            
        }
        
        print(url)
        
        PostAPIs.shared().get(url: url, token: token) { (result) in
            self.loadingIndicator?.stopAnimating()
            
            if result?.status ?? false {
                if result?.data?.count ?? 0 > 0 {
//                    s
                    self.customerPostedProjects = result
                    self.totalProject.text = String(describing: result!.data!.count)
                }
                
                DispatchQueue.main.async {
                    self.tbvu.reloadData()
//                    self.isLoading = true
                }
                
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: result?.error?.description ?? AlertConstants.SomeThingWrong)
            }
            
        } onFailure: { (error) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
        } onError: { (errorMessage) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        }


    }
    
    func getDataList() {
        
        loadingIndicator?.startAnimating()
        
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let parameters = ["page": pageNo] as [String: Any]
        let token  = dict?["token"] as! String
        
        var url = APIUrl.project
        
        if isIndividualProject {
            
            url = url + "/id=\(idForIndividualProject)?page=\(pageNo)"
            
            if idForIndividualProject == -1 {
                
                url = APIUrl.project + "?page=\(pageNo)"
//                let alertController = UIAlertController(title: AlertConstants.Alert, message: "No Project exist. Click ok To Navigate Back", preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//                    UIAlertAction in
//                    self.navigationController?.popViewController(animated: true)
//                }
//
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//
//                return
            }
            
        }
        
        print(url,parameters)
        
        ProjectApis.shared().get(apiURL: url, params: parameters, token: token) { (result) in
            
            self.loadingIndicator?.stopAnimating()
            
            if result?.status ?? false {
                
                    if result?.data?.count ?? 0 > 0 {
                        self.isLoading = true
                        self.projectList = result
                        self.totalProject.text = String(result?.total_project ?? 0)
                        self.totalListCount = result?.total_project ?? 0
                    }
                
                DispatchQueue.main.async {
                    self.tbvu.reloadData()
                }
                
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: result?.error?.description ?? AlertConstants.SomeThingWrong)
            }
            
        } onFailure: { (error) in

            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )

        } onError: {(errorMessage) in
            
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        
        }

        
    }
    
    func setUpLayout() {
        
        searchContainer.layer.cornerRadius = 8
        searchContainer.layer.masksToBounds = false
        searchContainer.layer.shadowColor = UIColor.lightGray.cgColor
        searchContainer.layer.shadowOpacity = 0.3
        searchContainer.layer.shadowRadius = 8
        
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        
        addProjectsBtn.layer.cornerRadius = 5
        addProjectsBtn.layer.borderWidth = 3
        addProjectsBtn.layer.borderColor = UIColor().colorForHax("#FDC11B").cgColor
        
//        checkFromWhereUserCome()
        
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return texts.count
        } else {
            if getNumberOfRow() == 0 {
                tbvu.setEmptyMessageForTbl("No Data Found")
            } else {
                self.tbvu.restoreForTbl()
            }
            print(getNumberOfRow())
            return getNumberOfRow()
        }
    }
    
    func getNumberOfRow() -> Int {
        if isResultForSearch {
            return projectsListAboutSearch?.count ?? 0
        }
        
        if isCustomer && isFrom == "AgentHomeC"  {
            return projectList?.data?.count ?? 0
        } else if !isCustomer && isFrom == "AgentHomeC" {
            if isSearchActive {
                return searchModalData?.posts?.count ?? 0
            }
            return customerPostedProjects?.data?.count ?? 0
        } else if isCustomer && isFrom != "AgentHomeC" {
            return customerPostedProjects?.data?.count ?? 0
        } else {
            return projectList?.data?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        startPaginationObserver(indexPath: indexPath)
        

        if tableView.tag == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProjectsTableViewCell", for: indexPath) as! MyProjectsTableViewCell
        return returnProjectCell(cell, indexPath)
    
    }
    
    func startPaginationObserver(indexPath: IndexPath) {
        
        if isCustomer && isFrom == "AgentHomeC"  {
            if (projectList?.data!.count)! - 1 == indexPath.row  {
                if isLoading {
                    pageNo += 1
                    self.isLoading = false
                    getDataList()
                }
            }
        } else if !isCustomer && isFrom == "AgentHomeC" {
            if (customerPostedProjects?.data!.count)! - 1 == indexPath.row  {
                if isLoading {
                    pageNo += 1
                    self.isLoading = false
                    getRelatedPost()
                }
            }
            print("!Customer && isFrom == AgentHomeC ")
        } else if isCustomer && isFrom != "AgentHomeC" {
            if (customerPostedProjects?.data!.count)! - 1 == indexPath.row  {
                if isLoading {
                    pageNo += 1
                    self.isLoading = false
                    getRelatedPost()
                    print("0 Customer && isFrom != AgentHomeC ")
                }
                print("1 Customer && isFrom != AgentHomeC ")
            }
            print("Customer && isFrom != AgentHomeC ")
        } else {
            if (projectList?.data!.count)! - 1 == indexPath.row  {
                if isLoading {
                    pageNo += 1
                    self.isLoading = false
                    getDataList()
                }
            }
            print("!Customer && isFrom != AgentHomeC ")
        }
    }
    
    func returnProjectCell(_ cell : MyProjectsTableViewCell, _ indexPath: IndexPath) -> MyProjectsTableViewCell {
        
        var stringAdded: String
        var postingTime: String
        var urls = URL(string: "")
        
        
        if (!isCustomer && isFrom == "AgentHomeC") || (isCustomer && isFrom != "AgentHomeC") {
            
            let _date = customerPostedProjects?.data?[indexPath.row].added_date ?? ""
            
           if self.getDate(date: _date) == "0" {
               postingTime = _date
               stringAdded = " days ago"
           } else {
               postingTime = self.getHours(date: _date)
             if Int(postingTime) ?? 0 > 168 {
               postingTime = self.getWeeks(date: _date)
               stringAdded = " week ago"
             } else{
               stringAdded = " hours ago"
             }
           }

           let postedDate = postingTime + stringAdded
           var totalViews = customerPostedProjects?.data?[indexPath.row].views
           if totalViews == "" {
             totalViews = "1"
           }

            let timeAndViews = "Added: \(postedDate), Total Views: \(totalViews ?? "")"
           cell.addedDate.text = timeAndViews
            
            
            var dataAtIndex = customerPostedProjects?.data?[indexPath.row]
           
            if isSearchActive && isFrom == "AgentHomeC" {
                dataAtIndex = searchModalData?.posts?[indexPath.row]
            }
            cell.projectTitle.text = dataAtIndex?.title
            cell.address.text = dataAtIndex?.location

            if dataAtIndex?.post_images?.count ?? 0 > 0 {

                urls = URL(string: (dataAtIndex?.post_images![0]) ?? "")

                if #available(iOS 13.0, *) {
                    cell.propertyImage.af_setImage(withURL: urls! ,placeholderImage: UIImage(named: "stock_image_four")?.withTintColor(.black, renderingMode: .alwaysTemplate))
                } else {
                    cell.propertyImage.af_setImage(withURL: urls! ,placeholderImage: UIImage(named:"stock_image_four"))
                }
            } else {
                cell.propertyImage.image = #imageLiteral(resourceName: "stock_image_four")
            }

            cell.contentView.layer.cornerRadius = 8
//            cell.menuOptionsBtn.isHidden = false
//            cell.chatBtn.isHidden = true

        } else if (isCustomer && isFrom == "AgentHomeC") || (!isCustomer && isFrom != "AgentHomeC") {
            let _date = projectList?.data?[indexPath.row].added_date ?? ""
            
           if self.getDate(date: _date) == "0" {
               postingTime = _date
               stringAdded = " days ago"
           } else {
               postingTime = self.getHours(date: _date)
             if Int(postingTime) ?? 0 > 168 {
               postingTime = self.getWeeks(date: _date)
               stringAdded = " week ago"
             } else{
               stringAdded = " hours ago"
             }
           }

           let postedDate = postingTime + stringAdded
           var totalViews = projectList?.data?[indexPath.row].views
           if totalViews == "" {
             totalViews = "1"
           }

            let timeAndViews = "Added: \(postedDate), Total Views: \(totalViews ?? "")"
           cell.addedDate.text = timeAndViews
           var dataAtIndex = projectList?.data?[indexPath.row]
            if isResultForSearch {
                dataAtIndex = projectsListAboutSearch?[indexPath.row]
            }
            cell.projectTitle.text = dataAtIndex?.project_name
           cell.address.text = dataAtIndex?.location

           if dataAtIndex?.project_images?.count ?? 0 > 0 {
               urls = URL(string: (dataAtIndex?.project_images![0]) ?? "")

               if #available(iOS 13.0, *) {
                   cell.propertyImage.af_setImage(withURL: urls! ,placeholderImage: UIImage(named: "stock_image_four")?.withTintColor(.black, renderingMode: .alwaysTemplate))
               } else {
                   // Fallback on earlier versions
                   cell.propertyImage.af_setImage(withURL: urls! ,placeholderImage: UIImage(named:"stock_image_four"))
               }
           } else {
            cell.propertyImage.image = #imageLiteral(resourceName: "stock_image_four")
           }

           cell.contentView.layer.cornerRadius = 8


           cell.selectionStyle = .none

    //            cell.menuOptionsBtn.isHidden = isIndividualProject
    //            cell.chatBtn.isHidden = !isIndividualProject

       
        }
    
        cell.menuTapCallback = {
            
            let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 160, height: 74))
            self.index = indexPath
            tableView.tag = 1
            tableView.delegate = self
            tableView.dataSource = self
            tableView.isScrollEnabled = false
            self.popover = Popover(options: self.popoverOptions)
            self.popover.willShowHandler = {
             print("willShowHandler")
            }
            self.popover.didShowHandler = {
             print("didDismissHandler")
            }
            self.popover.willDismissHandler = {
             print("willDismissHandler")
            }
            self.popover.didDismissHandler = {
             print("didDismissHandler")
            }
            self.popover.show(tableView, fromView: cell.menuOptionsBtn)
           
        }
//        print("rights",showAdminHandlerItem)
        
        cell.chatBtn.addTarget(self, action: #selector(chatBtnTapped), for: .touchUpInside)
        
        if showAdminHandlerItem {
            cell.menuOptionsBtn.isHidden = false
            cell.chatBtn.isHidden = true
        } else {
            cell.menuOptionsBtn.isHidden = true
            cell.chatBtn.isHidden = false
        }
        hideOrShowItems(cell)
        return cell
    }
    
    @objc func chatBtnTapped(sender: UIButton!) {
//        self.performSegue(withIdentifier: "chatviewcontroller", sender: self)
//        self.pushController(controller: ChatViewController.id, storyboard: Storyboards.Main.id)
    }
    
    func timestampString( _ date: String) -> String? {
     
       let formatter = DateComponentsFormatter()
       formatter.unitsStyle = .full
       formatter.maximumUnitCount = 1
       formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]

        print(Date())

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ss.SSSSSSz"
        let gettingDate = dateFormatter.date(from:date)
        
        guard let timeString = formatter.string(from: gettingDate ?? Date(), to: Date()) else {
            return nil
       }

       let formatString = NSLocalizedString("%@ ago", comment: "")
       return String(format: formatString, timeString)
    }
    
    func hideOrShowItems(_ cell : MyProjectsTableViewCell) {
        
        if isCustomer && isFrom == "AgentHomeC"  {
            cell.chatBtn.isHidden = true
            cell.menuOptionsBtn.isHidden = true
        } else if !isCustomer && isFrom == "AgentHomeC" {
            cell.chatBtn.isHidden = false
            cell.menuOptionsBtn.isHidden = true
            
        } else if isCustomer && isFrom != "AgentHomeC" {
            cell.chatBtn.isHidden = true
            cell.menuOptionsBtn.isHidden = false
            
        } else {
            cell.chatBtn.isHidden = true
            cell.menuOptionsBtn.isHidden = false
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //table view with tag 1 is for edit or delete the project\Post
        if tableView.tag == 1 {
            self.popover.dismiss()
            print(indexPath.row)
            if indexPath.row == 0 {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddProjectViewController") as! AddProjectViewController
//                vc.projectDetail = projectList?.data?[index.row]
//                vc.isForUpdate = true
//                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let url = APIUrl.project + "?project_id=\(String(describing: (projectList?.data?[index.row].id ?? -1) as Int))"
                deleteProject(url: url,indexPath)
            }
        } else {
            let detail = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
            detail.projectList = self.projectList?.data?[indexPath.row]
            detail.customerPostedProjects = self.customerPostedProjects?.data?[indexPath.row]
            detail.isFrom = self.isFrom
            if isCustomer && isFrom == "AgentHomeC" {
                if isResultForSearch {
                    detail.projectsListAboutSearch = self.projectsListAboutSearch?[indexPath.row]
                    detail.isResultForSearch = true
                } else {
                    detail.contractorProfileData = self.contractorProfileData
                    detail.agentProfileData = self.agentProfileData
                    detail.isAgent = isAgent
                }
                
            }
            if isSearchActive {
                detail.customerPostedProjects = self.searchModalData?.posts?[indexPath.row]
            }
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        
        if isCustomer && isFrom == "AgentHomeC"  {
            navigationController?.popViewController(animated: true)
        } else if !isCustomer && isFrom == "AgentHomeC" {
            showLeftViewAnimated(sender)
        } else if isCustomer && isFrom != "AgentHomeC" {
            showLeftViewAnimated(sender)
        } else {
            showLeftViewAnimated(sender)
        }
        
    }
    
    @IBAction func addProjectBtnTpd(_ sender: Any) {
        self.performSegue(withIdentifier: "addproject", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddProjectViewController {
            let vc = segue.destination as? AddProjectViewController
            vc?.isCusotmer = isCustomer
        }
    }
    
     
    func deleteProject(url: String, _ indexPath: IndexPath) {
        
        self.loaderIndicator?.startAnimating()
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let token  = dict?["token"] as! String
        
        ProjectApis.shared().delete(url: url, token: token) { (respones) in
            self.loaderIndicator?.stopAnimating()
            
            if self.isCustomer && self.isFrom == "AgentHomeC"  {
                self.customerPostedProjects?.data?.remove(at: self.index.row)
            } else if !self.isCustomer && self.isFrom == "AgentHomeC" {
                self.customerPostedProjects?.data?.remove(at: self.index.row)
            } else if self.isCustomer && self.isFrom != "AgentHomeC" {
                self.customerPostedProjects?.data?.remove(at: self.index.row)
            } else {
                self.projectList?.data?.remove(at: self.index.row)
            }
            
            DispatchQueue.main.async {
                self.totalListCount = self.totalListCount - 1
                self.totalProject.text = String(self.totalListCount)
               
                self.tbvu.reloadData()
                self.tbvu.layoutIfNeeded()
//            self.perform(#selector(self.reloadTable), with: nil, afterDelay: 2)

            }
            self.tbvu.deleteRows(at: [self.index], with: .fade)
        } onFailure: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
        } onError: { (errorMessage) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage?.description ?? AlertConstants.SomeThingWrong )
        }
        
    }
    @objc func reloadTable() {
        self.tbvu.reloadData()
    }

}


extension MyProjectsViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 11 {
            print("edit click")
            textField.resignFirstResponder()  //if desired
            performAction()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 11 && searchField.text == "" {
            print("show old data")
            isSearchActive = false
            tbvu.reloadData()
        }
    }
    
    func performAction() {
        
        if searchField.text == "" {
            print("show old data")
            isSearchActive = false
            tbvu.reloadData()
        } else {
            isSearchActive = true
            print("search click ")
            getSearchDataList()
        }
        
    }
    
}

extension Date {
    init(dateString:String) {
        self = Date.iso8601Formatter.date(from: dateString)!
    }

    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                          .withTime,
                                          .withDashSeparatorInDate,
                                          .withColonSeparatorInTime]
        return formatter
    }()
}
