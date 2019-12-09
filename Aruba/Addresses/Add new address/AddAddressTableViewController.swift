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

class AddAddressTableViewController: BaseTableViewController {
    @IBOutlet weak var street1Txt: ATextField!
    @IBOutlet weak var street2Txt: ATextField!
    @IBOutlet weak var houseNumberTxt: ATextField!
    @IBOutlet weak var referencesTxt: ATextField!
    @IBOutlet weak var nameTxt: ATextField!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    weak var delegate: AddAddressDelegate?
    let userManager: UserManagerProtocol = UserManager()
    private var lastLocation: CLLocation?
    
    private var shouldUpdateCameraAutomatically: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        configureLocationManager()
    }
    
    private func setupMap() {
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        mapView.settings.myLocationButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    
    private func configureLocationManager() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Disable location features
            AlertManager.showNotice(in: self, title: "Necesitamos un permiso", description: "Habilita los servicios de localización para que podamos utilizar tu GPS para tu dirección.") {
                self.locationManager.requestWhenInUseAuthorization()
            }
            break
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func saveAction(_ sender: AButton) {
        view.endEditing(true)
        guard let name = nameTxt.text, let street1 = street1Txt.text, let street2 = street2Txt.text, let houseNumber = houseNumberTxt.text, let references = referencesTxt.text else {
            
            return
        }
        let location = mapView.projection.coordinate(for: mapView.center)
        ALoader.show()
        userManager.saveAddress(name: name,
                                street1: street1,
                                street2: street2,
                                houseNumber: houseNumber,
                                references: references,
                                lat: location.latitude,
                                lng: location.longitude,
                                is_default: true) { (address, error) in
                                    ALoader.hide()
                                    
                                    if let error = error {
                                        AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message)
                                    } else if let address = address {
                                        self.delegate?.didSaveAddress(address: address)
                                        guard let loggedUser = UserManager.shared.loggedUser, let index = loggedUser.addresses.firstIndex(where: {$0.isDefault}) else {
                                            return
                                        }
                                        UserManager.shared.loggedUser?.addresses[index].setNonDefault()
                                        UserManager.shared.loggedUser?.addresses.append(address)
                                        self.showSuccess()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            if let navigationController = self.navigationController {
                                                navigationController.popViewController(animated: true)
                                            } else {
                                                self.dismiss(animated: true, completion: nil)
                                            }
                                        }
                                    }
                                    
        }
        
    }
}

extension AddAddressTableViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        shouldUpdateCameraAutomatically = false
        guard let myLocation = lastLocation else { return true }
        let camera = GMSCameraPosition.camera(withLatitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        return false
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
        case .notDetermined, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        if shouldUpdateCameraAutomatically {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
            self.mapView.animate(to: camera)
        }
    }
}
