//
//  SideMenuTableViewCell.swift
//  Bot
//
//  Created by Khawar Khan on 19/06/2019.
//  Copyright © 2019 Software Alliance. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!

    @IBOutlet weak var imgVu: UIImageView!
    
    @IBOutlet weak var forgetpassbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        setting text color for dark mode
       if #available(iOS 13.0, *) {
           if self.traitCollection.userInterfaceStyle == .dark {
            self.nameLbl.textColor = UIColor.black
               self.backgroundColor = UIColor.white
           } else {
               self.nameLbl.textColor = UIColor.black
               
           }
       } else {
           if self.traitCollection.userInterfaceStyle == .dark {
                      self.nameLbl.textColor = UIColor.black
                         self.backgroundColor = UIColor.white
                     } else {
                         self.nameLbl.textColor = UIColor.black
                         
                     }
       }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.selectionStyle = UITableViewCell.SelectionStyle.none;

        // Configure the view for the selected state
    }

}
