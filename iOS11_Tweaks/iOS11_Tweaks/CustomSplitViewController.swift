//
//  CustomSplitViewController.swift
//  iOS11_Tweaks
//
//  Created by Nuno Pereira on 01/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class CustomSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
        return .top
    }
}
