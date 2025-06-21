//
//  PostDetailsViewController.swift
//  Builbee
//
//  Created by Khawar Khan on 03/11/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import ExpandableLabel

class PostDetailsViewController: BaseClass {
    
    @IBOutlet weak var placeholderImage: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectaddress: UILabel!
    @IBOutlet weak var addedDate: UILabel!
    @IBOutlet weak var emailOuterVu: UIView!
    @IBOutlet weak var chatOuterVu: UIView!
    @IBOutlet weak var projectDetail: ExpandableLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var btnStack: UIStackView!
    @IBOutlet weak var contactInfoContainer: UIView!
    
    var timer: Timer?
    var isAgent = false
    var isCustomer = false
    var isFrom = "AgentHomeC"
    var projectList: ProjectData? = nil
    var customerPostedProjects: PostData? = nil
    var agentProfileData :  AgentList? = nil
    var contractorProfileData : ContractorsList? = nil
    
    var projectsListAboutSearch: ProjectData? = nil
    var isResultForSearch = false
    
    var stringAdded: String = ""
    var postingTime: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUpLayout()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        var count = getCount()
        if isResultForSearch {
            count = projectsListAboutSearch?.project_images?.count ?? 0
        } else {
            pageController.numberOfPages = count
        }
        pageController.currentPage = 0
        pageController.isHidden = !(count > 1)
        
        if isCustomerLogin() && isFrom == "AgentHomeC" {
            let param = ["user_id": String(getUserID()), "project_id": projectList?.id ?? "-1"] as [String : Any]
            addCounter(APIUrl.viewCounter, param)
        } else if !isCustomerLogin() && isFrom == "AgentHomeC" {
            let param = ["user_id": String(getUserID()), "post_id": customerPostedProjects?.id ?? "-1"] as [String : Any]
            addCounter(APIUrl.viewCounterForPost, param)
        }
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chatBtnClick(_ sender: Any) {
//        performSegue(withIdentifier: "showChatFromDetail", sender: nil)
    }
    
    @IBAction func reportbtnTap(_ sender: Any) {
        self.performSegue(withIdentifier: "showReportMdl", sender: self)
    }
    
    @IBAction func emailBtnTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SendEmailVC") as! SendEmailVC
        self.present(vc, animated: true, completion: nil)
    }
    
    func setUpLayout(){
        
        emailOuterVu.layer.cornerRadius = 10
        emailOuterVu.layer.borderWidth = 5
        emailOuterVu.layer.borderColor = UIColor().colorForHax("#D2D2D2").cgColor
        
        chatOuterVu.layer.cornerRadius = 10
        chatOuterVu.layer.borderWidth = 5
        chatOuterVu.layer.borderColor = UIColor().colorForHax("#FCB700").cgColor  
        
        contactInfoContainer.dropShadowAllSide(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.5, offSet:  CGSize(width: -1, height: 0.5), radius: 4, scale: true)
        
        let contactInfoGesture = UITapGestureRecognizer.init(target: self, action: #selector(getContactInfoTap(_:)))
        contactInfoContainer.isUserInteractionEnabled = true
        contactInfoContainer.addGestureRecognizer(contactInfoGesture)
       
        setUpFieldData()
    }
    
    func setUpFieldData() {
        
        isCustomer = isCustomerLogin()
        if isResultForSearch {
            projectTitle.text = projectsListAboutSearch?.project_name
//            addedDate.text = projectsListAboutSearch?.added_date
            projectDetail.text = projectsListAboutSearch?.project_detail
            projectaddress.text = projectsListAboutSearch?.location
            setDateAndView(_date: projectsListAboutSearch?.added_date  ?? "-1", view: projectsListAboutSearch?.views ?? "0")
        } else {
            if (!isCustomer && isFrom == "AgentHomeC") || (isCustomer && isFrom != "AgentHomeC") {
                
                projectTitle.text = customerPostedProjects?.title
//                addedDate.text = customerPostedProjects?.added_date
                projectDetail.text = customerPostedProjects?.body
                projectaddress.text = customerPostedProjects?.location
                setDateAndView(_date: customerPostedProjects?.added_date  ?? "-1", view: customerPostedProjects?.views  ?? "0")
                
            } else if (isCustomer && isFrom == "AgentHomeC") || (!isCustomer && isFrom != "AgentHomeC") {
                projectTitle.text = projectList?.project_name
//                addedDate.text = projectList?.added_date
                projectDetail.text = projectList?.project_detail
                projectaddress.text = projectList?.location
                setDateAndView(_date: projectList?.added_date ?? "-1", view: projectList?.views ?? "0")
            }
          
        }
        hideData()
        
    }
    
    func setDateAndView(_date: String, view: String) {
        
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
       var totalViews = view
        
       if totalViews == "" {
         totalViews = "1"
       }

        let timeAndViews = "Added: \(postedDate), Total Views: \(totalViews ?? "")"
        addedDate.text = timeAndViews
        
    }
    
    func hideData() {
        
        if (isCustomer && isFrom != "AgentHomeC") || (!isCustomer && isFrom != "AgentHomeC") {
            btnStack.isHidden = true
            reportBtn.isHidden = true
            contactInfoContainer.isHidden = true
        }
        
    }
    
    func addCounter(_ url: String, _ param : [String: Any]) {
        print(param)
        
        NetWorkCalls.shared().ViewCount(url: url , params: param) { (result) in
            if (result?.status ?? false) as Bool {
                print(result?.message as Any)
            } else {
                print(result?.error as Any)
                self.showAlertWith(title: AlertConstants.Error, message: result?.error ?? AlertConstants.SomeThingWrong)
            }
            print(result?.message as Any)
        } onFailure: { (error) in
            print(error as Any)
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong)
        } onError: { (errorMessage) in
            print(errorMessage as Any)
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage ?? AlertConstants.SomeThingWrong)
            
        }

    }
    
    @objc func getContactInfoTap(_ sender: UITapGestureRecognizer){
        print("tap ")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ModalVC") as! ModalVC
        if isCustomer && isFrom == "AgentHomeC" {
            vc.contractorProfileData = self.contractorProfileData
            vc.agentProfileData = self.agentProfileData
            vc.isAgent = isAgent
        }
        vc.projectID = String(projectList?.id ?? -1)
            vc.isFrom = isFrom
            vc.customerPostedProjects = customerPostedProjects
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SendReportVC {
            let vc = segue.destination as? SendReportVC
            vc?.projectList = projectList
            vc?.customerPostedProjects = customerPostedProjects
            vc?.isFrom = isFrom
            
        } else if segue.identifier == "showChatFromDetail" {
            let navigationContoller = segue.destination as! UINavigationController

            let receiverViewController = navigationContoller.topViewController as? ChatViewController

            receiverViewController?.projectList = projectList
            receiverViewController?.customerPostedProjects = customerPostedProjects
            receiverViewController?.isFrom = isFrom
            
            if self.isAgent {
                receiverViewController?.assigneeId = String(agentProfileData?.id ?? -1)
            } else {
                receiverViewController?.assigneeId = String(contractorProfileData?.id ?? -1)
            }
        } else if segue.identifier == "openImagesCollection" {
            let vc = segue.destination as? ImagesCollectionView
            vc?.imagesArray = projectList?.project_images ?? []
            if (!isCustomer && isFrom == "AgentHomeC") || (isCustomer && isFrom != "AgentHomeC") {
                vc?.imagesArray = customerPostedProjects?.post_images ?? []
            }
        }
        
    }

}

extension PostDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        var count = getCount()
        if isResultForSearch {
            count = projectsListAboutSearch?.project_images?.count ?? 0
        }
        if count > 0  {
            placeholderImage.isHidden = true
        }
        return count
    
    }
    
    func getCount() -> Int {
        
        if (!isCustomer && isFrom == "AgentHomeC") || (isCustomer && isFrom != "AgentHomeC") {
            return customerPostedProjects?.post_images?.count ?? 0
            
        } else if (isCustomer && isFrom == "AgentHomeC") || (!isCustomer && isFrom != "AgentHomeC") {
            return projectList?.project_images?.count ?? 0
            
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyImagesCollectionCell", for: indexPath) as! PropertyImagesCollectionCell
        if (!isCustomer && isFrom == "AgentHomeC") || (isCustomer && isFrom != "AgentHomeC") {
            let urls = URL(string: (customerPostedProjects?.post_images![indexPath.row]) ?? "")
            if urls != nil {
                if #available(iOS 13.0, *) {
                    cell.paginationImage.af_setImage(withURL: urls! ,placeholderImage: UIImage(named: "stock_image_four")?.withTintColor(.black, renderingMode: .alwaysTemplate))
                } else {
                    cell.paginationImage.af_setImage(withURL: urls! ,placeholderImage: UIImage(named:"stock_image_four"))
                }
            } else {
                cell.paginationImage.image = #imageLiteral(resourceName: "stock_image_four")
            }
            
        } else if (isCustomer && isFrom == "AgentHomeC") || (!isCustomer && isFrom != "AgentHomeC") {
            var dataAtIndex = projectList?.project_images![indexPath.row]
            if isResultForSearch {
                dataAtIndex = projectsListAboutSearch?.project_images![indexPath.row]
            }
            let urls = URL(string: (dataAtIndex) ?? "")
            if urls != nil {
                if #available(iOS 13.0, *) {
                    cell.paginationImage.af_setImage(withURL: urls! ,placeholderImage: UIImage(named: "stock_image_four")?.withTintColor(.black, renderingMode: .alwaysTemplate))
                } else {
                    cell.paginationImage.af_setImage(withURL: urls! ,placeholderImage: UIImage(named:"stock_image_four"))
                }
            } else {
                cell.paginationImage.image = #imageLiteral(resourceName: "stock_image_four")
            }
           
            
        }
        
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width , height: 250 )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openImagesCollection", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageController.currentPage = indexPath.section
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        pageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

class PropertyImagesCollectionCell: UICollectionViewCell {
    @IBOutlet weak var paginationImage: UIImageView!
}

