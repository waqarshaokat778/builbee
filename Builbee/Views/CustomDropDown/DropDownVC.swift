//
//  DropDownVC.swift
//  Builbee
//
//  Created by Abdullah on 12/21/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit

class DropDownVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "DropDownCustomView", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "dropDownTblCell")

        tableView.dataSource = self
        tableView.delegate = self


    }
}

extension DropDownVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropDownTblCell", for: indexPath) as! DropDownTblCell
        return cell
    }
    
}
 
