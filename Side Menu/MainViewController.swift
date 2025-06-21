//
//  MainViewController.swift
//  Bot
//
//  Created by Khawar Khan on 6/18/19.
//  Copyright © 2019 Software Alliance. All rights reserved.
//

import LGSideMenuController

class MainViewController: LGSideMenuController {
    
    private var type: UInt?
    override func viewDidLoad() {
        super.viewDidLoad()
//        let regularStyle: UIBlurEffect.Style
//        if #available(iOS 10.0, *) {
//            regularStyle = .regular
//        }
//        else {
//            regularStyle = .light
//        }
        leftViewWidth = 300.0;
        leftViewPresentationStyle = .slideAbove
    }
    
    deinit {
        print("MainViewController deinitialized")
    }
    //Status bar changed
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
    
}
