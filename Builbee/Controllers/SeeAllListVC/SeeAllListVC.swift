//
//  SeeAllListVC.swift
//  Builbee
//
//  Created by Abdullah on 11/27/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AlamofireImage

class SeeAllListVC: BaseClass {
    
    var sectionClick = 0
    var agent: [AgentList] = []
    var contractor: [ContractorsList] = []
    var loadingIndicator : NVActivityIndicatorView? = nil
    var headerTitle = ""
    var pageNo = 1
    var isLoading = true
    var isSearchActive: Bool = false
    var searchFieldText: String = ""
    
    
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var searchOuterVu: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        collectionVu.dataSource = self
        collectionVu.delegate = self
        searchField.delegate = self 
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func requestForMoreData() {
        
        loadingIndicator?.startAnimating()
        
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let parameters = ["page": "\(pageNo)", "latitude": dict?["latitude"], "longitude": dict?["longitude"]] as! [String: String]
        let token  = dict?["token"] as! String
        
        GetNearPeopleApis.shared().get(params: parameters, token: token , onSuccess: { (result) in
            self.loadingIndicator?.stopAnimating()
        
            if result?.status ?? false {
                
                if self.sectionClick == 0 {
                    if result?.agents?.count ?? 0 > 0 {
                        if self.pageNo == 1 {
                            self.contractor = result?.contractors ?? []
                        } else {
                            self.contractor.append(contentsOf: (result?.contractors ?? []))
                        }
                        if result?.contractors?.count ?? 0 > 0 {
                            self.isLoading = true
                        }
                    }
                } else {
                    if result?.agents?.count ?? 0 > 0 {
                        if self.pageNo == 1 {
                            self.agent = result?.agents ?? []
                        } else {
                            self.agent.append(contentsOf: (result?.agents ?? []))
                        }
                        
                        if result?.agents?.count ?? 0 > 0 {
                            self.isLoading = true
                        }
                    }
                }
                
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
        let parameters = ["page": pageNo, "general_search": searchFieldText] as [String : Any]
        let token  = dict?["token"] as! String
        print(parameters)
                
        NetWorkCalls.shared().getSearchResult(token: token, params: parameters, onSuccess: { (result) in
            self.loadingIndicator?.stopAnimating()
        
            if result?.status ?? false {
                
                if self.sectionClick == 0 {
                    if result?.contractors?.count ?? 0 > 0 {
                        self.isLoading = true
                    }
                } else {
                    if result?.agentLsit?.count ?? 0 > 0 {
                        if result?.agentLsit?.count ?? 0 > 0 {
                            self.isLoading = true
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    if self.pageNo == 1 {
                        self.contractor = result?.contractors ?? []
                        self.agent = result?.agentLsit ?? []
                    } else {
                        self.contractor += result?.contractors ?? []
                        self.agent += result?.agentLsit ?? []
                    }
                    self.contractor += result?.contractors ?? []
                    self.agent += result?.agentLsit ?? []
                    
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

    
    func setUpLayout() {
        
        searchOuterVu.layer.cornerRadius = 8
        searchOuterVu.layer.masksToBounds = false
        searchOuterVu.layer.shadowColor = UIColor.lightGray.cgColor
        searchOuterVu.layer.shadowOpacity = 0.3
        searchOuterVu.layer.shadowRadius = 8
        
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        headingLabel.text = headerTitle
    }
    
}

extension SeeAllListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if sectionClick == 0 {
            if contractor.count == 0 {
                collectionVu.setEmptyMessage("No Data to Display")
            } else {
                self.collectionVu.restore()
            }
            return contractor.count
        } else {
            if agent.count == 0 {
                collectionVu.setEmptyMessage("No Data to Display")
            } else {
               self.collectionVu.restore()
            }
            return agent.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        paginationCall(indexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seeAllListCell", for: indexPath) as! SeeAllListCell
        if sectionClick == 0 {
            cell.dealerName.text = contractor[indexPath.row].name
            
            let url = URL(string: contractor[indexPath.row].profile_img_url ?? "")!
            
            if #available(iOS 13.0, *) {
                cell.imgVu.af_setImage(withURL: url,placeholderImage: UIImage(named: "user")?.withTintColor(.black, renderingMode: .alwaysTemplate))
            } else {
                cell.imgVu.af_setImage(withURL: url,placeholderImage: UIImage(named:"user"))
            }
            
        } else {
            cell.dealerName.text = agent[indexPath.row].name
            let url = URL(string: agent[indexPath.row].profile_img_url ?? "")!
            
            if #available(iOS 13.0, *) {
                cell.imgVu.af_setImage(withURL: url,placeholderImage: UIImage(named: "user")?.withTintColor(.black, renderingMode: .alwaysTemplate))
            } else {
                cell.imgVu.af_setImage(withURL: url,placeholderImage: UIImage(named:"user"))
            }
            
        }
        return cell
        
    }
    
    func paginationCall(indexPath: IndexPath) {
        if sectionClick == 0 {
            if contractor.count - 1 == indexPath.row  {
                if isLoading {
                    pageNo += 1
                    self.isLoading = false
                    if isSearchActive {
                        getSearchDataList()
                    } else {
                        requestForMoreData()
                    }
                }
            }
        } else {
            if agent.count - 1 == indexPath.row  {
                if isLoading {
                    pageNo += 1
                    self.isLoading = false
                    if isSearchActive {
                        getSearchDataList()
                    } else {
                        requestForMoreData()
                    }
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 5, height: view.frame.width / 2 - 5 )
   }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "myprojects") as! MyProjectsViewController
        vc.isIndividualProject = true
        vc.showAdminHandlerItem = false
        
        if sectionClick == 0 {
            print(indexPath.row)
            vc.idForIndividualProject = contractor[indexPath.row].id ?? -1
            print("id of contractor is :",contractor[indexPath.row].id as Any  )
//            vc.userNameInHeader = contractor[indexPath.row].name!
        } else {
            vc.idForIndividualProject = agent[indexPath.row].id ?? -1
            print("id of agent is :",agent[indexPath.row].id as Any  )
//            vc.userNameInHeader = agent[indexPath.row].name!
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

class SeeAllListCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVu: UIImageView!
    @IBOutlet weak var dealerName: UILabel!
    
}

extension SeeAllListVC: UITextFieldDelegate{

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
            pageNo = 1
            requestForMoreData()
//            collectionVu.reloadData()
        }
    }
    
    func performAction() {
        
        if searchField.text == "" {
            isSearchActive = false
            pageNo = 1
            requestForMoreData()
//            collectionVu.reloadData()
        } else {
            isSearchActive = true
            searchFieldText = searchField.text ?? ""
            getSearchDataList()
        }
        
    }
    
}
