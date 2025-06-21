//
//  DropDownTblCell.swift
//  Builbee
//
//  Created by Abdullah on 12/21/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit

class DropDownTblCell: UITableViewCell {

    @IBOutlet weak var dropDownLbl: UILabel!
    @IBOutlet weak var dropDownSelectedImage: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
