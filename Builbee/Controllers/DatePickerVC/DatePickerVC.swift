//
//  DatePickerVC.swift
//  Builbee
//
//  Created by Abdullah on 12/23/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit

protocol datePickerDelegate {
    func getData(_ date: String, _ isStart: Bool)
}
class DatePickerVC: UIViewController {

    var delegate: datePickerDelegate?
    var isStart: Bool = true
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneBtnTap(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.delegate?.getData(formatter.string(from: datePicker.date), isStart)
        
        dismiss(animated: true,completion: nil)

    }
    
    @IBAction func cancelBtnTap(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
}

