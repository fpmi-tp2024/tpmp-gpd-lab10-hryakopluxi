//
//  ClinicsMapViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 28.05.24.
//

import UIKit
import MapKit
import CoreLocation

class ClinicsMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var clinicNameLabel: UILabel!
    @IBOutlet weak var clinicAddressLabel: UILabel!
    @IBOutlet weak var clinicDescriptionTextView: UITextView!
    //@IBOutlet weak var chooseButton: UIButton!
    
    var clinics: [Clinic] = []
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupLocationManager()
        clinics = ClinicController.shared.getAllClinics()
        showClinicsOnMap()
        updateClinicDetails(with: nil)
        //chooseButton.isHidden = true
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("Location Manager setup complete")
    }
    
    func parseCoordinates(from addressCoords: String) -> CLLocationCoordinate2D? {
        let components = addressCoords.split(separator: ",")
        guard components.count == 2,
              let latitude = Double(components[0].trimmingCharacters(in: .whitespaces)),
              let longitude = Double(components[1].trimmingCharacters(in: .whitespaces)) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func showClinicsOnMap() {
        var annotations: [MKPointAnnotation] = []
        
        for clinic in clinics {
            guard let coordinates = parseCoordinates(from: clinic.addressCoords) else { continue }
            print("Clinic: \(clinic.name), Coordinates: \(coordinates.latitude), \(coordinates.longitude)") // Print coordinates
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = clinic.name
            annotations.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
            
            if !annotations.isEmpty {
                var region = MKCoordinateRegion()
                region.center = annotations[0].coordinate
                
                var minLat = annotations[0].coordinate.latitude
                var minLng = annotations[0].coordinate.longitude
                var maxLat = annotations[0].coordinate.latitude
                var maxLng = annotations[0].coordinate.longitude
                
                for annotation in annotations {
                    minLat = min(minLat, annotation.coordinate.latitude)
                    minLng = min(minLng, annotation.coordinate.longitude)
                    maxLat = max(maxLat, annotation.coordinate.latitude)
                    maxLng = max(maxLng, annotation.coordinate.longitude)
                }
                
                let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2)
                let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLng - minLng) * 1.5)
                region = MKCoordinateRegion(center: center, span: span)
                
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
    func updateClinicDetails(with clinic: Clinic?) {
        DispatchQueue.main.async {
            if let clinic = clinic {
                self.clinicNameLabel.text = clinic.name
                self.clinicAddressLabel.text = clinic.address
                self.clinicDescriptionTextView.text = clinic.description
                self.clinicNameLabel.isHidden = false
                self.clinicAddressLabel.isHidden = false
                self.clinicDescriptionTextView.isHidden = false
                //self.chooseButton.isHidden = false
            } else {
                self.clinicNameLabel.isHidden = true
                self.clinicAddressLabel.isHidden = true
                self.clinicDescriptionTextView.isHidden = true
                //self.chooseButton.isHidden = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? MKPointAnnotation,
              let selectedClinic = clinics.first(where: { $0.name == selectedAnnotation.title }) else {
            return
        }
        updateClinicDetails(with: selectedClinic)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polylineOverlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polylineOverlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        print("User location updated: \(userLocation.coordinate)")
        highlightNearestClinic(to: userLocation.coordinate)
    }
    
    func highlightNearestClinic(to userLocation: CLLocationCoordinate2D) {
        guard let nearestClinic = clinics.compactMap({ clinic -> (clinic: Clinic, coordinate: CLLocationCoordinate2D)? in
            guard let coordinates = parseCoordinates(from: clinic.addressCoords) else { return nil }
            return (clinic, coordinates)
        }).min(by: { userLocation.distance(to: $0.coordinate) < userLocation.distance(to: $1.coordinate) })?.clinic else { return }
        
        DispatchQueue.main.async {
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
            
            let userAnnotation = MKPointAnnotation()
            userAnnotation.coordinate = userLocation
            userAnnotation.title = "You are here"
            self.mapView.addAnnotation(userAnnotation)
            
            self.updateClinicDetails(with: nearestClinic)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let toLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return fromLocation.distance(from: toLocation)
    }
}
