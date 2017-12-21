//
//  ShowLocationViewController.swift
//  Taster
//
//  Created by Nuno Pereira on 24/04/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ShowLocationViewController: UIViewController {

    let defaults = UserDefaults.standard;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GeonamesClient.findNearbyWikipedia(loc, completionHandler: {(geoWiki) in
            if geoWiki != nil {
                OperationQueue.main.addOperation {
                    self.showNearbyWikipedia(geoWiki!)
                }
            }})
        let uName = defaults.object(forKey: "username");
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    init?(coder: NSCoder)

}
