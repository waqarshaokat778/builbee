//
//  MyProjectsTableViewCell.swift
//  Builbee
//
//  Created by Khawar Khan on 19/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit

class MyProjectsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var addedDate: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var menuOptionsBtn: UIButton!
    
    var menuTapCallback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func menuBtnTap(_ sender: Any) {
        menuTapCallback?()
    }

}
