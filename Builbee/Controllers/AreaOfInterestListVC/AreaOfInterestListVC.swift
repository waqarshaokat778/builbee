//
//  AreaOfInterestListVC.swift
//  Builbee
//
//  Created by Abdullah on 12/8/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit

class AreaOfInterestCell: UITableViewCell {
    
    @IBOutlet weak var imageContainer: UIView! {
        didSet{
            imageContainer.layer.borderWidth = 1
            imageContainer.layer.borderColor = #colorLiteral(red: 0.9946972728, green: 0.7222921252, blue: 0, alpha: 1)
        }
    }
    
    @IBOutlet weak var checkedImage: UIImageView!
    @IBOutlet weak var areaOfInterestLabel: UILabel!
    
}

class AreaOfInterestListVC: BaseClass {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var responseResult: [AreaOfInterestDataModal]? = nil
    var selectedUser: [Int]? = []
    var delegate: selectedAreaOfInterestDelegate?
    var isForSelectedArea = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        curveTopCorners(view: headerView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isForSelectedArea {
            getSelectedDataList()
        } else {
            getDataList()
        }
        
    }
    
    @IBAction func cancelBtnTap(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func doneBtnClick(_ sender: Any) {
        print("done btn click ")
        
        UIView.animate(withDuration: 0.5,delay: 0.5) {
            self.delegate?.selectedListAreaOfInterest(list: self.selectedUser ?? [])
            self.dismiss(animated: true)
        }
        
    }
    
    func getDataList() {
        
        loaderIndicator?.startAnimating()
        AreaOfInterestAPIs.shared().get(onSuccess: { (result) in
            self.loaderIndicator?.stopAnimating()
            if result?.status ?? false {
                self.responseResult = result?.data
                
                self.setUpModal()
                
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.SomeThingWrong)
            }
        }, onFailure: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
        }) { (errorMessage) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        }
        
    }
    
    func getSelectedDataList() {
        
        loaderIndicator?.startAnimating()
        AreaOfInterestAPIs.shared().getSepecificeList(token: getToken(), onSuccess: { (result) in
            self.loaderIndicator?.stopAnimating()
            if result?.status ?? false {
                self.responseResult = result?.data
                print(result?.data?[0].selected, result?.data?[1].selected)
                self.tableView.reloadData()
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.SomeThingWrong)
            }
        }, onFailure: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
        }) { (errorMessage) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        }
        
    }
    
}

extension AreaOfInterestListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaOfInterestCell", for: indexPath) as! AreaOfInterestCell
        cell.areaOfInterestLabel.text = responseResult?[indexPath.row].name
        if isForSelectedArea {
            if (responseResult?[indexPath.row].selected ?? false) {
                cell.checkedImage.image = UIImage(named: "icons8-checkmark_filled.png")
            } else {
                cell.checkedImage.image = UIImage(named: "")
            }
        } else {
            if (responseResult?[indexPath.row].selectedArea ?? false) {
                cell.checkedImage.image = UIImage(named: "icons8-checkmark_filled.png")
            } else {
                cell.checkedImage.image = UIImage(named: "")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let index = selectedUser?.firstIndex(of: (responseResult?[indexPath.row].id)!)
        
        if index == nil {
            self.responseResult?[indexPath.row].selectedArea = true
            self.selectedUser?.append((responseResult?[indexPath.row].id!)!)
        } else {
            self.selectedUser?.remove(at: index!)
            self.responseResult?[indexPath.row].selectedArea = false
        }
        tableView.reloadData()
    }
    
    func setUpModal() {
        
        guard let listModal = responseResult?.count else {
            return
        }
        
        for indexPath in 0...listModal - 1  {
            let index = selectedUser?.firstIndex(of: (responseResult?[indexPath].id)!)
            if index == nil {
                self.responseResult?[indexPath].selectedArea = false
            } else {
                self.responseResult?[indexPath].selectedArea = true
            }
        }
        
        tableView.reloadData()
    }
}

