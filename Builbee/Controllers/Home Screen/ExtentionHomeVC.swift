//
//  ExtentionHomeVC.swift
//  Builbee
//
//  Created by Abdullah on 12/21/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isSearchActive {
             return 2
        }
        return 3
    }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getItemCount(section)
    }
    
    func getItemCount(_ section: Int) -> Int {
        
        if isSearchActive {
            
            if section == 0 {
                return searchModalData?.contractors?.count ?? 0
            } else {
                return searchModalData?.agentLsit?.count ?? 0
            }
            
        } else {
            
            if section == 0 {
                return contractor.count
            } else if section == 1 {
                return 3
            } else {
                return agent.count
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        if section == 1 && !isSearchActive {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: self.collectionVu.bounds.width, height: 70)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 1 && !isSearchActive {
            return CGSize(width: self.collectionVu.frame.width , height: 180)
        } else {
            return CGSize(width: 200, height: 200);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return headerViewReturn(indexPath, kind)
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if isSearchActive {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
           
            if indexPath.section == 0 {
                geViewOfCell(url: searchModalData?.contractors?[indexPath.row].profile_img_url ?? "", name: searchModalData?.contractors?[indexPath.row].name ?? "", cell: cell, isAvailability: searchModalData?.contractors?[indexPath.row].contractor?.availability ?? true)
            } else if indexPath.section == 1 {
                geViewOfCell(url: searchModalData?.agentLsit?[indexPath.row].profile_img_url ?? "", name: searchModalData?.agentLsit?[indexPath.row].name ?? "", cell: cell, isAvailability: searchModalData?.agentLsit?[indexPath.row].agent?.availability ?? true)
            } else {
                if  ((searchModalData?.projects?[indexPath.row].project_images?.count ?? 0) > 0)  {
                    geViewOfCell(url: searchModalData?.projects?[indexPath.row].project_images?[0] ?? "", name: searchModalData?.projects?[indexPath.row].project_name ?? "", cell: cell, isAvailability:  true)
                } else {
                    geViewOfCell(url: "", name: searchModalData?.projects?[indexPath.row].project_name ?? "", cell: cell, isAvailability: true)
                }
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
           
            if indexPath.section == 0 {
                geViewOfCell(url: contractor[indexPath.row].profile_img_url ?? "", name: contractor[indexPath.row].name ?? "", cell: cell, isAvailability: contractor[indexPath.row].contractor?.availability ?? true)
            } else if indexPath.section == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertisementCollecCell", for: indexPath) as! AdvertisementCollecCell
                return cell
            } else {
                geViewOfCell(url: agent[indexPath.row].profile_img_url ?? "", name: agent[indexPath.row].name ?? "", cell: cell, isAvailability: agent[indexPath.row].agent?.availability ?? true)
            }
            return cell
        }
        
        

   }
    
    
    func geViewOfCell(url: String, name: String, cell: HomeCollectionViewCell, isAvailability: Bool ) {
        
        let url = URL(string: url)
        if url != nil {
            if #available(iOS 13.0, *) {
                cell.imgVu.af_setImage(withURL: url!, placeholderImage: UIImage(named: "stock_image_four")?.withTintColor(.black, renderingMode: .alwaysTemplate))
            } else {
                cell.imgVu.af_setImage(withURL: url!, placeholderImage: UIImage(named:"stock_image_four"))
            }
        } else {
            cell.imgVu.image = #imageLiteral(resourceName: "stock_image_four")
        }
        
        if isAvailability {
            cell.availableLbl.text = "Available"
            cell.AvailabilityIcon.image = #imageLiteral(resourceName: "available")
        } else {
            cell.availableLbl.text = "Unavailable"
            cell.AvailabilityIcon.image = #imageLiteral(resourceName: "not_available")
        }
        
        cell.txtLbl.text = name
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor().colorForHax("#FFFFFF").cgColor
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 1 && !isSearchActive  {
            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func showAllList(sender : UIButton){
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SeeAllListVC") as! SeeAllListVC
        if isSearchActive {
            controller.agent = searchModalData?.agentLsit ?? []
            controller.headerTitle = "Agent"
            controller.sectionClick = 1
            controller.isSearchActive = true
            controller.searchFieldText = searchField.text ?? ""
            if (sender.tag == 0) {
                controller.contractor = searchModalData?.contractors ?? []
                controller.headerTitle = "Contractor"
                controller.sectionClick = 0
            }
        } else {
            controller.agent = agent
            controller.headerTitle = "Agent"
                controller.sectionClick = 1
            if (sender.tag == 0) {
                controller.contractor = contractor
                controller.headerTitle = "Contractor"
                controller.sectionClick = 0
            }
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "myprojects") as! MyProjectsViewController
        vc.isIndividualProject = true
        vc.isFrom = "AgentHomeC"
        vc.showAdminHandlerItem = false
        if isSearchActive {
            if indexPath.section == 0 {
                vc.idForIndividualProject = searchModalData?.contractors?[indexPath.row].id ?? -1
                print(searchModalData?.contractors?[indexPath.row].id as Any)
                vc.contractorProfileData = searchModalData?.contractors?[indexPath.row]
                vc.isAgent = false
                
            } else {
                vc.idForIndividualProject = searchModalData?.agentLsit?[indexPath.row].id ?? -1
                print(searchModalData?.agentLsit?[indexPath.row].id as Any)
                vc.agentProfileData = searchModalData?.agentLsit?[indexPath.row]
                vc.isAgent = true
            }
        } else {
            if indexPath.section == 0 {
                vc.idForIndividualProject = contractor[indexPath.row].id ?? -1
                print(contractor[indexPath.row].id as Any)
                vc.contractorProfileData = contractor[indexPath.row]
                vc.isAgent = false
                
            } else if indexPath.section == 1{
                print("section one advertisement banner click")
            } else {
                vc.idForIndividualProject = agent[indexPath.row].id ?? -1
                print(agent[indexPath.row].id as Any)
                vc.agentProfileData = agent[indexPath.row]
                vc.isAgent = true
            }
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    func headerViewReturn(_ indexPath : IndexPath, _ kind: String) -> HomeCollectionReusableView {
        
        let sectionHeaderView = collectionVu.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionReusableView", for: indexPath) as! HomeCollectionReusableView
        viewInHeader(sectionHeaderView, indexPath)
        return sectionHeaderView
    }
    
    func viewInHeader(_ sectionHeaderView: HomeCollectionReusableView ,_ indexPath: IndexPath) {
        
        sectionHeaderView.layer.cornerRadius = 8
        sectionHeaderView.layer.masksToBounds = false
        sectionHeaderView.layer.shadowColor = UIColor.black.cgColor
        sectionHeaderView.layer.shadowOpacity = 0.23
        sectionHeaderView.layer.shadowRadius = 4
        sectionHeaderView.showAllList.tag = indexPath.section
        sectionHeaderView.showAllList.addTarget(self, action: #selector(self.showAllList), for: .touchUpInside)
        
        if isSearchActive {
            if indexPath.section == 0 {
                sectionHeaderView.headerTitle.text = "Contractor"
            } else if indexPath.section == 1 {
                sectionHeaderView.headerTitle.text = "Agent"
            } else if indexPath.section == 2 {
                sectionHeaderView.headerTitle.text = "Projects"
            }
        } else {
            if indexPath.section == 0 {
                sectionHeaderView.headerTitle.text = "Contractor"
            } else {
                sectionHeaderView.headerTitle.text = "Agent"
            }
        }
    }
    
}
