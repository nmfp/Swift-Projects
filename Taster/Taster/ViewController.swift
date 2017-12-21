//
//  ViewController.swift
//  Taster
//
//  Created by Nuno Pereira on 22/03/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldText: UITextField!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldText.delegate = self;

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        labelText.text = textFieldText.text;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldText{
             textField.resignFirstResponder()
        }
        return true;
    }
    
    
}

