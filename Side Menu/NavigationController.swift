//
//  NavigationController.swift
//  Bot
//
//  Created by Khawar Khan on 19/06/2019.
//  Copyright © 2019 Software Alliance. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        
        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String : Any]
        let customer = dict?["user_type"] as! String
        if customer != "customer" {
//            self.setViewControllers([(storyboard?.instantiateViewController(withIdentifier: "myprojects"))!], animated: false)
            let view = storyboard?.instantiateViewController(withIdentifier: "myprojects") as? MyProjectsViewController
//            view?.isFrom = "leftSideMenu"
            self.setViewControllers([(view)!], animated: false)
        } else {
            self.setViewControllers([(storyboard?.instantiateViewController(withIdentifier: "HomeVC"))!], animated: false)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootVC(_:)), name: NSNotification.Name(rawValue: "changeRootVC"), object: nil)
    }
    
    @objc func changeRootVC(_ notification: NSNotification) {
        if let name = notification.userInfo?["VCName"] as? String {
            if let navigationFrom = notification.userInfo?["isFrom"] as? String {
                let view = storyboard?.instantiateViewController(withIdentifier: name) as? MyProjectsViewController
                view?.isFrom = navigationFrom
                if let isIndividualProject = notification.userInfo?["isIndividualProject"] as? Bool {
                    view?.isIndividualProject = isIndividualProject
                }
                
                self.setViewControllers([(view)!], animated: false)
            } else  {
                self.setViewControllers([(storyboard?.instantiateViewController(withIdentifier: name))!], animated: false)
            }
            
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
//    override var prefersStatusBarHidden : Bool {
//        return true
//    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
//    
//    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
//        return sideMenuController!.isRightViewVisible ? .slide : .fade
//    }
    
}
