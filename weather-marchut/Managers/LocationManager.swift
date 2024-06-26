//
//  LocationManager.swift
//  weather-marchut
//
//  Created by Jakub Marchut on 24/06/2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var cityName: String = "" {
        didSet {
            if !cityName.isEmpty {
                isCityNameUpdated = true
            }
        }
    }
    @Published var isCityNameUpdated: Bool = false

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    func requestLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        self.location = latestLocation
        self.locationManager.stopUpdatingLocation()
        fetchCityName(from: latestLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    private func fetchCityName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                self.cityName = placemark.locality ?? "Unknown"
            }
        }
    }
}

