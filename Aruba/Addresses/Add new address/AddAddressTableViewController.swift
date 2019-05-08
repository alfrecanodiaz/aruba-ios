//
//  AddAddressTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/7/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit
import GoogleMaps

protocol AddAddressDelegate: class {
    func didSaveAddress(address: AAddress)
}

class AddAddressTableViewController: UITableViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    weak var delegate: AddAddressDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        configureLocationManager()
    }

    private func setupMap() {
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break

        case .restricted, .denied:
            // Disable location features

            break

        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            locationManager.startUpdatingLocation()
            break
        }
    }

}

extension AddAddressTableViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {

    }

}

extension AddAddressTableViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:

            break

        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break

        case .notDetermined, .authorizedAlways:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
}
