//
//  PickLocationViewController.swift
//  Taster
//
//  Created by Nuno Pereira on 20/05/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PickLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationObj = locations.last;
        let coord = locationObj?.coordinate;
        
        if let c = coord {
            map.setRegion(MKCoordinateRegionMake(c, MKCoordinateSpanMake(0.1, 0.1)), animated: true)
        }
    }

}
