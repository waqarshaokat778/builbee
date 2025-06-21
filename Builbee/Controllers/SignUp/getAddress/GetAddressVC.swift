//
//  GetAddressVC.swift
//  Builbee
//
//  Created by Abdullah on 11/25/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import GoogleMaps

class GetAddressVC: UIViewController {
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var delegate:getLoacitonDelegate?
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
    }
    
    @IBAction func setLocation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
      let geocoder = GMSGeocoder()
      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
          return
        }
        self.address.text = lines.joined(separator: "\n")
        self.delegate?.getLoaction(address: lines.joined(separator: "\n"), lat: "\(coordinate.latitude)" , lng: "\(coordinate.longitude)")
        UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
        }
      }
    }
    
}

extension GetAddressVC: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
  
    guard status == .authorizedWhenInUse else {
      return
    }
    locationManager.startUpdatingLocation()
      
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
      
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      
    locationManager.stopUpdatingLocation()
  }
}

extension GetAddressVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      reverseGeocodeCoordinate(position.target)
    }
}
