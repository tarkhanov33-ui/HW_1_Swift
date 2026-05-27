import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithError(_ error: Error)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            delegate?.didFailWithError(NSError(domain: "LocationManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied"]))
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            delegate?.didFailWithError(NSError(domain: "LocationManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied"]))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        delegate?.didUpdateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error)
    }
}
