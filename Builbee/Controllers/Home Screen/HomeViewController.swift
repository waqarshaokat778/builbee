//
//  HomeViewController.swift
//  Builbee
//
//  Created by Khawar Khan on 16/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import JEKScrollableSectionCollectionViewLayout
import NVActivityIndicatorView
import AlamofireImage

class HomeViewController: BaseClass {
   
    @IBOutlet weak var searchOuterVu: UIView!
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var searchTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var projectContainerView: UIView!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var projectListContain: UIView!
    
    var projectListVC = MyProjectsViewController()
    
    var pageNo: Int = 1
    var agent: [AgentList] = []
    var contractor: [ContractorsList] = []
    var loadingIndicator : NVActivityIndicatorView? = nil
   
    var isSearchActive: Bool = false
    var searchModalData: SearchResultModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchField.delegate = self
        
        setupCollectionvu()
        setupcollectionvuLayout()
        setUpLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        scrollHeight.constant = 835
        collectionViewHeight.constant = 714
        
        projectContainerView.isHidden = true
        
        getDataList()
        
        if !(searchField.text?.isEmpty ?? false) {
            isSearchActive = true
            getSearchDataList()
        }
    }
    
    func projectlistView() {
        
        scrollHeight.constant = 1620
        collectionViewHeight.constant = 550
        projectContainerView.isHidden = false
        
        projectListVC = self.storyboard!.instantiateViewController(withIdentifier: "myprojects") as! MyProjectsViewController
        projectListVC.isFrom = "AgentHomeC"
        projectListVC.isResultForSearch = true
        projectListVC.showAdminHandlerItem = false
        projectListVC.projectsListAboutSearch = searchModalData?.projects
        projectListVC.view.frame = self.projectListContain.bounds
        self.projectListContain.addSubview(projectListVC.view)
        self.addChild(projectListVC)
    }
    
    func getDataList() {
        
        loadingIndicator?.startAnimating()
        
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let parameters = ["page": "1", "latitude": dict?["latitude"], "longitude": dict?["longitude"]] as! [String: String]
        let token  = dict?["token"] as! String
        
        agent = []
        contractor = []
        
        GetNearPeopleApis.shared().get(params: parameters, token: token , onSuccess: { (result) in
            self.loadingIndicator?.stopAnimating()
        
            if result?.status ?? false {
                self.agent.append(contentsOf: (result?.agents ?? []))
                self.contractor.append(contentsOf: (result?.contractors ?? []))
                
                DispatchQueue.main.async {
                    self.collectionVu.reloadData()
                }
                
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: result?.error?.description ?? AlertConstants.SomeThingWrong)
            }
            
        }, onFailure: { (error) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
            
        }) { (errorMessage) in
            self.loadingIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
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
                
                DispatchQueue.main.async {
                    self.searchModalData = result
                    self.projectlistView()
                    print(self.searchModalData!, result as Any)
                    self.collectionVu.reloadData()
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
    
    func setupcollectionvuLayout(){
        
        let layout = JEKScrollableSectionCollectionViewLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/2 - 26, height: self.view.frame.width/2 - 26);
        layout.headerReferenceSize = CGSize(width: 0, height: 22)
        layout.minimumInteritemSpacing = 5
        collectionVu.collectionViewLayout = layout
        
    }
    
    func setupCollectionvu(){
        
        
        collectionVu.dataSource = self
        collectionVu.delegate = self

        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionVu.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")

        self.collectionVu.register(UINib(nibName: "AdvertisementCell", bundle: Bundle(for: AdvertisementCollecCell.self)), forCellWithReuseIdentifier: "AdvertisementCollecCell")

    }
    
    func setUpLayout() {
        
        searchOuterVu.layer.cornerRadius = 8
        searchOuterVu.layer.masksToBounds = false
        searchOuterVu.layer.shadowColor = UIColor.lightGray.cgColor
        searchOuterVu.layer.shadowOpacity = 0.3
        searchOuterVu.layer.shadowRadius = 8

        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        
    }
}


extension HomeViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 11 {
            textField.resignFirstResponder()
            performAction()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 11 && searchField.text == "" {
            print("show old data")
            isSearchActive = false
            collectionViewHeight.constant = 714
            scrollHeight.constant = 835
            projectContainerView.isHidden = true
            collectionVu.reloadData()
        }
    }
    
    func performAction() {
        
        if searchField.text == "" {
            isSearchActive = false
            collectionVu.reloadData()
        } else {
            isSearchActive = true
            getSearchDataList()
        }
        
    }
    
}
