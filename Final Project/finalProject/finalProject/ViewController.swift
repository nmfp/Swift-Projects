//
//  ViewController.swift
//  finalProject
//
//  Created by Nuno Pereira on 12/12/2016.
//  Copyright © 2016 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var btnAddReminder: UIButton!
    @IBOutlet weak var btnAllReminder: UIButton!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    @IBOutlet weak var viewReminder: UIView!
    
    
    
    //Array de datas
    var cenas : [Date]!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func btnAddReminder(_ sender: Any) {
        viewReminder.isHidden = false;
    }
    @IBAction func btnAllReminder(_ sender: Any) {
        viewReminder.isHidden = false;
    }
}

