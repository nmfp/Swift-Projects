//
//  ViewController.swift
//  AnimationsAutoLayoutConstraints
//
//  Created by Nuno Pereira on 22/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "profile_image"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAnimate)))
        return iv
    }()
    
    var leftAnchor: NSLayoutConstraint?
    var rightAnchor: NSLayoutConstraint?
    var topAnchor: NSLayoutConstraint?
    var bottomAnchor: NSLayoutConstraint?
    
    @objc func handleAnimate() {
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
//        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        topAnchor = imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        topAnchor?.isActive = true
//        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        leftAnchor = imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        leftAnchor?.isActive = true
//        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rightAnchor = imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        bottomAnchor = imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
    }



}

