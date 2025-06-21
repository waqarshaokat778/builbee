//
//  ConversationsVC.swift
//  Builbee
//
//  Created by Abdullah on 12/15/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit

class ConversationsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func navigateBAck(_ sender: Any) {
        showLeftViewAnimated(sender)
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
//        self.view.window?.rootViewController = rootVC
    
    }
    
}

extension ConversationsVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as! ConversationListCell
        
//        let url = URL(string:  ?? "")
//
//        if url != nil {
//            if #available(iOS 13.0, *) {
//                cell.userImage.af.setImage(withURL: url!,placeholderImage: UIImage(named: "icons8-user_male_circle")?.withTintColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), renderingMode: .alwaysTemplate))
//            } else {
//                // Fallback on earlier versions
//                cell.userImage.af.setImage(withURL: url!,placeholderImage: UIImage(named:"icons8-user_male_circle"))
//            }
//        } else {
//            cell.userImage.image = UIImage(named: "icons8-user_male_circle")
//        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class ConversationListCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var status: UILabel!
    
}
