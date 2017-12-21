//
//  ViewController.swift
//  FacebookAnimation
//
//  Created by Nuno Pereira on 15/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc func handleTap() {
        (0...10).forEach { (_) in
            generateAnimatedView()
        }
    }

    func generateAnimatedView() {
        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "thumbs_up") : #imageLiteral(resourceName: "heart")
        let imageView = UIImageView(image: image)
        let dimension = 20 + drand48() * 10
        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        animation.path = customPath().cgPath
        animation.duration = 2 + drand48() * 3
        
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        imageView.layer.add(animation, forKey: nil)
        view.addSubview(imageView)
    }
}

func customPath() -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 200))
    
    let finalPoint = CGPoint(x: 400, y: 200)
    //        path.addLine(to: finalPoint)
    
    let randomYShift = 200 + drand48() * 300
    let cp1 = CGPoint(x: 100, y: 100 - randomYShift)
    let cp2 = CGPoint(x: 200, y: 300 + randomYShift)
    
    path.addCurve(to: finalPoint, controlPoint1: cp1, controlPoint2: cp2)
    return path
}

class CurvedView: UIView {
    override func draw(_ rect: CGRect) {
        //do some fancy curve drawing
        let path = customPath()
        path.lineWidth = 3
        path.stroke()
    }
}
