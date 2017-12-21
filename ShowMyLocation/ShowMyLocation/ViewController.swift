//
//  ViewController.swift
//  ShowMyLocation
//
//  Created by Nuno Pereira on 14/05/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager();
    var annotation = MKPointAnnotation();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.requestWhenInUseAuthorization();
            
            mapView.delegate = self;
            mapView.showsUserLocation = true;
            mapView.showsScale = true;
            mapView.showsCompass = true;
        }
        else{
            print("Serviços de localização desactivados.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation();
            print("Serviços de localização activos.")
        }
        else{
            print("Não foi autorizado o uso da localização.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locObj = locations.last;
        let coord = locObj?.coordinate;
        
        if let c = coord {
            print("latitude: \(c.latitude), longitude: \(c.longitude)")
            mapView.setRegion(MKCoordinateRegionMake(c, MKCoordinateSpanMake(0.005, 0.005)), animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)");
    }
    
    
    @IBAction func didTapMap(_ sender: UITapGestureRecognizer) {
        let tapPoint : CGPoint = sender.location(in: mapView);
        let location = mapView.convert(tapPoint, toCoordinateFrom: mapView);
        
        if location.latitude != annotation.coordinate.latitude || location.longitude != annotation.coordinate.longitude{
            mapView.removeAnnotation(annotation);
            annotation.coordinate = location;
            annotation.title = "Food location";
            annotation.subtitle = "Teste"
            mapView.addAnnotation(annotation);
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "identifier";
        var annotationView:MKPinAnnotationView?;
        
        if annotation.isKind(of: MKPointAnnotation.self){
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView;
            
            if annotationView == nil{
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier);
                annotationView?.canShowCallout = true;
                annotationView?.pinTintColor = UIColor.purple;
            }
            else{
                annotationView?.annotation = annotation;
            }
            return annotationView;
        }
        return nil;
    }
}

