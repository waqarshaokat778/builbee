//
//  BaseClass.swift
//  Builbee
//
//  Created by Abdullah on 11/20/20.
//  Copyright © 2020 KK. All rights reserved.
//

import Foundation
import UIKit
import AnimatedField
import NVActivityIndicatorView

class BaseClass: UIViewController {
    
    var loaderIndicator: NVActivityIndicatorView? = nil
    var userProfileInDefault = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderinit()
    }
    
    func loaderinit() {
        loaderIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), padding: 1)
        view.addSubview(loaderIndicator!)
    }
    
    func showLoader(){
        let loader = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.contentMode = .scaleAspectFit
        loader.image = UIImage(named: "loader")
        loader.tag = 111
        self.view.isUserInteractionEnabled = false
        loader.center = self.view.center
        self.view.addSubview(loader)
    }
    
    func hideLoader(){
        guard let loader = self.view.viewWithTag(111) as? UIImageView else {return}
        self.view.isUserInteractionEnabled = true
        loader.removeFromSuperview()
    }

    func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(AlertConstants.Ok.uppercased(), comment: ""), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func showAlertWith(title: String, message: String, onSuccess closure: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(AlertConstants.Ok.uppercased(), comment: ""), style: .`default`, handler: { _ in
            closure()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func pushController(controller toPush: String, storyboard: String) {
        let controller = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: toPush)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getControllerRef(controller toPush: String, storyboard: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: toPush)
    }
    
    func curveTopCorners(view: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
    
//    func getDate(date: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ss.SSSSSSz"
//        let localDate = formatter.date(from: date)
//        guard let date = localDate else {return ""}
//        print("\(Date().days(from: date))")
//        return "\(Date().days(from: date))"
//      }
//      func getHours(date: String) -> String{
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ss.SSSSSSz"
//        let localDate = formatter.date(from: date)
//        guard let date = localDate else {return ""}
//        print("\(Date().hours(from: date))")
//        return "\(Date().hours(from: date))"
//      }
//      func getWeeks(date: String) -> String{
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ss.SSSSSSz"
//        let localDate = formatter.date(from: date)
//        guard let date = localDate else {return ""}
//        print("\(Date().weeks(from: date))")
//        return "\(Date().weeks(from: date))"
//      }
    
//    func convertDateTo(dateString: String) -> String  {
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        dateFormatter.calendar = Calendar(identifier: .gregorian)
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        if let dateFromString = dateFormatter.date(from: dateString.components(separatedBy: " ").first ?? "") {
//            print(dateFromString)  // "2019-05-04 00:00:00 +0000"
//        }
//        return String(description: dateFormatter)
//    }
    
    func isCustomerLogin() -> Bool {
        let customer = userProfileInDefault?["user_type"]
        if customer as! String == "customer" { return true }
        return false
    }
    
    func getUserID() -> String {
        return userProfileInDefault?["id"] as! String
    }
    
    func getToken() -> String {
        return (userProfileInDefault?["token"])! as! String
    }
    
    func isAvailable() -> Bool  {
//        if userProfileInDefault?["availability"] != nil {
            return (userProfileInDefault?["availability"]) as! Bool
//        }
    }
    
    func setupFields(container: UIView, field: AnimatedField, placeholder: String){
        
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.lightGray.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowRadius = 8
        
        var format = AnimatedFieldFormat()
        
        format.alertColor = .red
        format.alertFieldActive = false
        format.titleAlwaysVisible = true
        format.highlightColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        format.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        field.format = format
        field.attributedPlaceholder = NSAttributedString(string: placeholder)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func readUserObject() -> [AreaOfInterestDataModal] {
        
        var areaOfExp : [AreaOfInterestDataModal]?
        if let decodedNSDataBlob = UserDefaults.standard.object(forKey: Constants.areaOfExperience) as? NSData {
            if let savedAreaOfExp = NSKeyedUnarchiver.unarchiveObject(with: decodedNSDataBlob as Data) as? [AreaOfInterestDataModal] {
                areaOfExp = savedAreaOfExp
            }
        }
        
        return areaOfExp!
    }
    
     func saveUserObject(_ areaOfExp: [AreaOfInterestDataModal]) {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: areaOfExp)
        let defaults = UserDefaults.standard
        defaults.set(archivedObject, forKey: Constants.areaOfExperience)
        defaults.synchronize()
        
    }
    
    func getDate(date: String) -> String {
       
        let formatter = ISO8601DateFormatter()
        
        formatter.formatOptions = [.withFullDate,
                                          .withTime,
                                          .withDashSeparatorInDate,
                                          .withColonSeparatorInTime]
    
        let localDate = formatter.date(from: date)
        guard let date = localDate else {return ""}
        return "\(Date().days(from: date))"
      }
    
    func getHours(date: String) -> String{
        let formatter = ISO8601DateFormatter()
        
        formatter.formatOptions = [.withFullDate,
                                          .withTime,
                                          .withDashSeparatorInDate,
                                          .withColonSeparatorInTime]
        let localDate = formatter.date(from: date)
        guard let date = localDate else {return ""}
        print("\(Date().hours(from: date))")
        return "\(Date().hours(from: date))"
    }
    
    func getWeeks(date: String) -> String{
        let formatter = ISO8601DateFormatter()
        
        formatter.formatOptions = [.withFullDate,
                                          .withTime,
                                          .withDashSeparatorInDate,
                                          .withColonSeparatorInTime]
            let localDate = formatter.date(from: date)
        guard let date = localDate else {return ""}
        print("\(Date().weeks(from: date))")
        return "\(Date().weeks(from: date))"
      }
    
   
}
