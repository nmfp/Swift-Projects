//
//  GeonamesWikipedia.swift
//  Taster
//
//  Created by Nuno Pereira on 23/04/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation
import CoreLocation

struct GeonamesWikipedia {
    let title:String;
    let summary:String;
    let feature:String;
    
    let url:URL?
    let coordinate : CLLocationCoordinate2D;
}

class GeonamesClient{
    
    static func findNearbyWikipedia( loc: CLLocationCoordinate2D, completionHandler: @escaping ([GeonamesWikipedia]?) -> Void ){
        
        let urlString = "http://api.geonames.org/findNearbyWikipediaJSON?lat=\(loc.latitude)&lng=\(loc.longitude)&lang=PT&username=desenvolvimentoswift";
        
        if let url = NSURL(string: urlString){
            let session = URLSession.shared;
            let sessionTask = session.dataTask(with: url, completionHandler: {(data, response, error) in completionHandler(nil) })
            sessionTask.resume();
        }
    }
}
