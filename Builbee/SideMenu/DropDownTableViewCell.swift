//
//  DropDownTableViewCell.swift
//  Builbee
//
//  Created by Khawar Khan on 26/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import iOSDropDown

class DropDownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgVu: UIImageView!
    
    @IBOutlet weak var dropdown: DropDown!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
