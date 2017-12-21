//
//  FoodInsertViewController.swift
//  Taster
//
//  Created by Nuno Pereira on 11/04/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import CoreLocation

class FoodInsertViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var location:CLLocationCoordinate2D?
    
    
    var cameraUI : UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraUI = UIImagePickerController();
        cameraUI.sourceType = UIImagePickerControllerSourceType.camera;
        cameraUI.delegate = self;
        cameraUI.present(cameraUI, animated: true, completion: nil );
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image;
            self.newImage = image;
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        if let loc = location {
            self.food?.location = loc;
        }
        else {
            if let local = food?.local {
                let geocoder = CLGeocoder();
                geocoder.geocodeAddressString(local, completionHandler: {(placemarks, error) in
                    if let coord = placemarks?.first?.location{
                        self.food?.location = coord.coordinate;
                    }
                })
            }
        }
    }
    
    
    
   
    
    
    
}
